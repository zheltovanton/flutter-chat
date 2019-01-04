library chat;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../component/empty.dart';
import '../includes/strings.dart' as s;
import '../includes/globals.dart' as g;
import 'package:async_loader/async_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../component/rest.dart';
import 'dart:convert';
import '../modal/chat.dart';
import '../component/tools.dart';

class ExitButton extends StatelessWidget {
  const ExitButton();

  @override
  Widget build(BuildContext context) {
    return new CupertinoButton(
      padding: EdgeInsets.zero,
      child: const Tooltip(
        message: 'Back',
        child: const Text('Exit'),
        excludeFromSemantics: true,
      ),
      onPressed: () {
        // The demo is on the root navigator.
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }
}


Widget chatWidget (BuildContext context, List<ChatModal> chat, String user)
{
  ScrollController _scrollController = new ScrollController();

  if (chat != null) {
    if (chat.length > 0) {
      return new SingleChildScrollView(
        reverse: true,
        //key: _scaffoldKey,
          child:new Container(
            padding: const EdgeInsets.all(4.0),
            child: new Column(
              children: <Widget>[
              ]
                ..addAll(buildTab2Conversation(context, chat, user)),
            ),
          )
      );
    } else {
      return new UIElementEmpty();
    }
  } else {
    return new UIElementEmpty();
  }
}

class Chat extends StatefulWidget {
  Chat({  this.context });

  BuildContext context;
  String number;

  @override
   createState() =>
      new _ChatState( context: context, number: number);
}

class _ChatState extends State<Chat> with WidgetsBindingObserver {
  _ChatState({  this.context, this.number });
  BuildContext context;
  String number;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  AppLifecycleState _lastLifecycleState;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      print("new _lastLifecycleState " +_lastLifecycleState.toString());
      _lastLifecycleState = state;
      _handleRefresh;
    });
  }


  Future<Null> _handleRefresh() async {
    _asyncLoaderState.currentState.reloadState();
    return null;
  }

  _getTaskTask(String uid, BuildContext context) async{
    List<ChatModal> _data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = await prefs.getInt('uid');

    var p = new LoadChat();
    p.user = user.toString();
    p.task = uid;
    p.key = g.API_KEY;

    print(p.user.toString());
    print(p.task.toString());

    var restHelper = new RestHelperGET();
    String lResp = await restHelper.post(g.URL_SERVER, p, context);

    var ret = json.decode(lResp);

    //print(ret["data"].toString());
    if (ret["data"]!=null) {
      _data = new List<ChatModal>();
      for (var i in ret["data"]) {
        //print(i["photo"]);
        _data.add(new ChatModal.fromFields(i));
      }
    }

    return _data;
  }

  @override
  Widget build(BuildContext context) {
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await _getTaskTask(number.toString(), context),
      renderLoad: () => new UIElementLoading(),
      renderError: ([error]) =>  new Text(s.txtErrorLoading),
      renderSuccess: ({data}) =>  chatWidget(context, data, number)

    );

    return _asyncLoader;
  }
}

List<Widget> buildTab2Conversation(BuildContext context,
    List<ChatModal> chat, String user) {
  List<Widget> _data;

  _data = new List<Widget>();

  for (var i in chat) {

    _data.add(_ChatItem(
        time: i.message_datetime,
        text: i.message,
        photo: i.photo,
        user: user,
        me: i.from_1c==1 ? false:true
    ));
    }
  return _data;
}

class _ChatItem extends StatelessWidget {
  _ChatItem({
    this.text,
    this.time,
    this.photo,
    this.task,
    this.user,
    this.me});

  final String text;
  final String time;
  final String photo;
  final String task;
  final String user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final List<Widget> columnChildren = new List<Widget>();
    columnChildren.add(new Text(text));
    columnChildren.add(new Text(time, style: themeData.textTheme.caption));

    if (isStringNOTEmpty(photo)) {
      columnChildren.add(widgetNetworkPhoto(context,
          '/image:' + task + "+" + photo + "+" + user,
          g.URL_SERVER +
              "?tag=image" +
              "&user=" + user +
              "&task=" + task +
              "&filename=" + photo +
              "&key=" + g.API_KEY)
      );
    }

      final List<Widget> rowChildren = <Widget>[
      new Expanded(
          child: new Container(
              width: 300.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              decoration: new BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(18.0)),
                color: me
                    ? Colors.amberAccent
                    : Colors.black12,
              ),
              child: new Column(
              crossAxisAlignment: me ?
                CrossAxisAlignment.start :
                CrossAxisAlignment.end,
              children: columnChildren
          )
          )
      )
    ];

    return new MergeSemantics(
      child: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren
          )
      ),
    );
  }
}
