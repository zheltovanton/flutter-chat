import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../includes/globals.dart'  as g;
import 'package:flutter/material.dart';
import 'dart:async';
import 'tools.dart';

class LoginAuth extends BaseObject {
  String tag;
  String phone;
  String password;
  String imei;
  String hard;
  String soft;
  String key;

  Map<String, String> toMap() {
//    super.toMap();
    return {"tag": tag,
      "phone": phone,
      "password": password,
      "imei": imei,
      "hard": hard,
      "soft": soft,
      "key": key};
  }
}

class SaveToken extends BaseObject {
  String tag;
  String user;
  String imei;
  String token;
  String key;

  Map<String, String> toMap() {
//    super.toMap();
    return {"tag": tag,
      "user": user,
      "imei": imei,
      "token": token,
      "key": key};
  }
}

class LoadChat extends BaseObject {
  String user;
  String task;
  String logist;
  String key;

  Map<String, String> toMap() {
//    super.toMap();
    return {
      "task": task,
      "user": user,
      "logist": "true",
      "key": key
    };
  }
}

class SendChatModal extends BaseObject {
  String message;
  String user;
  String key;
  String message_datetime;

  Map<String, String> toMap() {
    return {
      "user": user,
      "message": message,
      "message_datetime": message_datetime,
      "key": key};
  }
}

abstract class BaseObject {
  Map<String, String> toMap();
}

class RestHelper {
  post(String url, BaseObject obj, BuildContext context) async {
    String ret = "";
    var client = new http.Client();
    var req = http.Request('POST', Uri.parse(url));

    req.bodyFields = obj.toMap();

    await client.send(req).then((response) =>
        response.stream.bytesToString().then((value) => ret = value.toString()))
        .catchError((error) => print(error.toString()));

    return ret;
  }

  post_json(String url, BaseObject obj, BuildContext context) async {
    String ret = "";

    var client = new http.Client();
    var req= http.Request('POST', Uri.parse(url));

    req.body = json.encode(obj.toMap());

    await client.send(req).then((response)
    => response.stream.bytesToString().then((value)
    => ret=value.toString())).catchError((error) => print(error.toString()));

    return ret;
  }
}

class RestHelperGET {
  post(String url, BaseObject obj, BuildContext context) async {
    String ret = "";

    var client = new http.Client();
    var req= http.Request('GET', Uri.parse(url));

    req.bodyFields = obj.toMap();
    await client.send(req).then((response)
    => response.stream.bytesToString().then((value)
    => ret=value.toString())).catchError((error) => print(error.toString()));

//     new Future.delayed(Duration.zero,() {
//       showDialog(context: context, builder: (context) => new AlertDialog(
//         title: new Text("rest response"),
//         content: new Text(ret),
//         actions: <Widget>[
//           new FlatButton(onPressed: (){
//             Navigator.pop(context);
//           }, child: new Text('OK')),
//         ],
//       ));
//     });
    return ret;
  }
}
