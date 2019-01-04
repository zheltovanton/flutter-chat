import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import '../component/rest.dart';
import '../modal/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../includes/strings.dart' as s;
import '../includes/globals.dart' as g;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:core';

class ChatSenderPage extends StatefulWidget {
  BuildContext context;
  String uid;
  ChatSenderPage(BuildContext context, String uid) {
    this.context = context;
    this.uid = uid;
  }

  @override
  State<StatefulWidget> createState() => new ChatSenderState(context, uid);
}

class ChatSenderState extends State<ChatSenderPage>
    with TickerProviderStateMixin {
  BuildContext context;
  final GlobalKey<ScaffoldState> _scaffoldKey1 = new GlobalKey<ScaffoldState>();
  String uid;
  final TextEditingController _chatController = new TextEditingController();

  void _handleSubmit(String text) async {

    DateTime dateTime = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');//"2018-12-25 22:46:56"
    String date2;

    try {
      date2 = formatter.format(dateTime);
    } catch (e) { }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = await prefs.getInt('uid');

    var p = new SendChatModal();
    p.user = uid;
    p.message = _text;
    //p.target = "1";
    p.message_datetime = date2;
    p.key = g.API_KEY;

    var restHelper = new RestHelper();
    print(g.URL_SERVER+"?key="+g.API_KEY+
        "&user="+user.toString()+
        "&task="+uid);
    print(p.toMap().toString());
    String lResp = await restHelper.post_json(g.URL_SERVER+"?key="+g.API_KEY+
        "&user="+user.toString(), p, context);

    var ret = json.decode(lResp);
    if (ret["error"]==false){
      Navigator.popAndPushNamed(context, "/task:"+uid+"+4");
    }
    print(ret.toString());
  }

  ChatSenderState(BuildContext context, String uid) {
    this.context = context;
    this.uid = uid;
    }

  String _status = 'no-action';
  String _text = '';

  @override
  void initState() {

    SystemChannels.textInput.invokeMethod('TextInput.show');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  Widget _chatEnvironment () {
    return  new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                autofocus: true,
                decoration: new InputDecoration.collapsed(
                    hintText: s.txtStartType),
                controller: _chatController,
                onSubmitted: _handleSubmit,
                onChanged: (String messageText) {
                  setState(() {
                    _text = messageText;
                  });
                },
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(
                    Icons.send,
                    color:g.clDefault),
                onPressed: () => _handleSubmit(_chatController.text),
              ),
            )
          ],
        ),
    );
  }

  Widget buildAppBar() {
    return new AppBar(
      backgroundColor: g.clBack,
      leading:IconButton(
        icon: new Icon(Icons.arrow_back),
        color: g.clDefault,
        tooltip: s.txtToBack,
        onPressed: ()=> Navigator.of(context).pop(),
      ),
      title: new Text(s.txtWriteToChat),
    );

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
        key: _scaffoldKey1,
        appBar: buildAppBar(),
        body:new Column(
          children: <Widget>[
            new Flexible(
                child: new Container(decoration: new BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                  child: _chatEnvironment(),
                )
            )
          ],
        )
    );
  }
}
