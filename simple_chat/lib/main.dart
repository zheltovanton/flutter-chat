import 'modal/chat.dart';
import 'package:flutter/material.dart';
import 'login/login.dart';
import 'login/auth.dart';
import 'chat/chat_sender.dart';
import 'chat/chat.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'includes/strings.dart' as s;
import 'includes/globals.dart' as g;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'component/rest.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'component/tools.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

AuthService appAuth = new AuthService();

void main() async{
  runApp(new MyHome());
}

class MyHome extends StatefulWidget {

  final Widget child;

  MyHome({this.child});

  @override
  MyHomeState createState() => new MyHomeState();

  static restartApp(BuildContext context) {
    final MyHomeState state =
    context.ancestorStateOfType(const TypeMatcher<MyHomeState>());
    state.restartApp();
  }
}

class MyHomeState extends State<MyHome> with SingleTickerProviderStateMixin {
  // Create a tab controller

  Timer _timer;
  TabController controller;
  String _newtoken = "Waiting for token...";
  String _name = "...";
  String _uid = "...";
  String _imei = "...";
  bool _topicButtonsDisabled = false;
  String _udid = 'Unknown';

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FirebaseAnalytics analytics = new FirebaseAnalytics();

  final TextEditingController _topicController =
  new TextEditingController(text: 'topic');

  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  void _handleSearchBegin(BuildContext context) {
    print("_handleSearchBegin");
    Navigator.of(context).pushNamed('/search');
  }

  hideKeyboard() async {
    // Simulate a future for response after 1 second.
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      print("hideKeyboard");
    });
  }

  loadUserName(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString('name');
    setState(() {
      _name = username;
    });
  }

  loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.getString('username');
    String uid = prefs.getInt('uid').toString();
    setState(() {
      _name = username;
      _uid = uid;
    });
  }

  Future<void> saveToken(String str) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getInt('uid').toString();
    await prefs.setString('token', str);
    print("saveToken");

    if (!isStringNOTEmpty(str)) {
      str = await prefs.getString('token');
    }

    bool res = false;
    if ((_uid!=null)&&(_imei!=null)) {
      var p = new SaveToken();
      p.tag = "savetoken";
      p.user = uid;
      p.token = str;
      p.key = g.API_KEY;
      print(p.toString());
      print("saveToken");
      var restHelper = new RestHelper();
      String lResp = await restHelper.post(g.URL_SERVER, p, context);
      var ret = json.decode(lResp);
      //var user = json.decode(ret["user"]);
      print(lResp);
    }
  }

  saveTokenF(String str) async {
    //await loadUserData();
    await saveToken(str);

  }

  @override
  void initState() {
    super.initState();
    hideKeyboard();

    controller = new TabController(length: 3, vsync: this);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage notification: " + message['notification'].toString());

        String title = message['notification']['title'].toString();
        String body = message['notification']['body'].toString();

        switch (title)
        {
          case "newchatmessage": title = s.txtNewchatmessage; break;
          default: title = s.txtNewmessage;break;
        }

        print(title + "" + body);
        new Future.delayed(Duration.zero,() {
          showDialog(context: context, builder: (context) => new AlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: new Text('OK')),
            ],
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      print ("getnewtoken");
      setState(() {
        _newtoken = token;
      });

      saveTokenF(token);
    });

  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  Route<dynamic> _getRoute(BuildContext context, RouteSettings settings) {
    final List<String> path = settings.name.split('/');
    if (path[0] != '')
      return null;

//    if (path[1].startsWith('sr:')) {
//      print(path[1]);
//      if (path.length != 2)
//        return null;
//      String query = path[1].substring(3);
//      final List<String> params = query.split('+');
//      return new MaterialPageRoute<void>(
//        settings: settings,
//        builder: (BuildContext context) => new SearchResult(int.parse(params[0]) ,params[1]),
//      );
//    }

    if (path[1].startsWith('chatsender:')) {
      if (path.length != 2)
        return null;
      final String uid = path[1].substring(11);
      final List<String> params = uid.split('+');
      print("chatsender uid="+params[0]);
      return new MaterialPageRoute<void>(
        settings: settings,
        builder: (BuildContext context) => new ChatSenderPage(context, params[0]),
      );
    }

    if (path[1].startsWith('image:')) {
      print(path[1]);
      if (path.length != 2)
        return null;
      String query = path[1].substring(6);
      final List<String> params = query.split('+');
      for (var i in params){
        print (i);
      }
      String URL = g.URL_SERVER+
          "?tag=image&task="+params[0]+
          "&filename="+params[1]+
          "&user="+params[2]+
          "&key="+g.API_KEY;
      print(URL);
      return
        new MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => new WebviewScaffold(
            url: URL,
            appBar: new AppBar(
              title: new Text("Фото"),
            ),
            withZoom: true,
            withLocalStorage: true,
          ),
        );
    }


    return null;
  }

  ThemeData get theme {
    return new ThemeData(
        brightness: Brightness.light,
        primarySwatch: g.clMatBack
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text("Chat"),
        elevation: 0.0,
        backgroundColor: g.clBack,
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _handleSearchBegin(context),
            tooltip: 'Search',
          ),
        ]
    );
  }

  void SearchDisable(){
    print("SearchDisable");
    setState(() {

    });
  }

  Widget MainBuilder(BuildContext context){

    loadUserName(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ( new Scaffold(
      // Appbar
      //key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: buildAppBar(context),
      body: new Container(
          child: Chat(context: context,)
          )
      )

    );
  }

  Widget _buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          DrawerHeader(child: Center(child: Text(_name))),
          const ListTile(
            leading: const Icon(Icons.dehaze),
            title: const Text(s.txtTasks),
            selected: true,
          ),
          const ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text(s.txtProfile),
            enabled: false,
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(s.txtSettings),
            onTap: null,//Navigator.pushNamed(context, "/setting"),
          ),
          const Divider(),
          new ListTile(
            leading: const Icon(Icons.help),
            title: Text(s.txtExit),
            onTap: () {appAuth.logout(context).then(
                    (_) => RestartWidget.restartApp(context));

            },
          ),
        ],
      ),
    );
  }

  Widget MainTabBar() {
    return new Material(
      color: Colors.white,
      child: new TabBar(
        labelColor: g.clTextDefault,
        tabs: <Tab>[
          new Tab(
            // set icon to the tab
            text:  s.txtTaskCurrent,
          ),
          new Tab(
              text:  s.txtTaskWait
          ),
          new Tab(
              text:  s.txtTaskClosed
          ),
        ],
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tasks',
      theme: theme,
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => LoginPage(context),
        '/home': (BuildContext context) => MainBuilder(context),
        '/login': (BuildContext context) => LoginPage(context),
        '/settings': (BuildContext context) => null,
      },
      onGenerateRoute: (RouteSettings settings) =>_getRoute(context, settings),
      onUnknownRoute: (RouteSettings settings) =>_getRoute(context, settings),
    );


  }
}

class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({this.child});

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
    context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => new _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: key,
      child: widget.child,
    );
  }
}