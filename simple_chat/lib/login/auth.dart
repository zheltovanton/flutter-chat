import 'dart:async';
import 'dart:convert';
import '../includes/globals.dart' as g;
import '../component/rest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../includes/strings.dart' as s;

class auth_post {
  final bool error;
  final String error_msg ;

  auth_post({this.error, this.error_msg});

  factory auth_post.fromJson(Map<String, dynamic> json) {
    return new auth_post(
      error: json['error'],
      error_msg: json['error_msg'],
    );
  }
}

class AuthService {
  Future<bool> _showFailedLogin(BuildContext context,String text) {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(text),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(s.txtshowFailedOkButton),
          )
        ],
      ),
    ) ??
        false;
  }


  Future<bool> login(String phone, String password, BuildContext context) async {

    var p = new LoginAuth();
    p.tag = "login";
    p.phone = g.phonePrefix+phone;
    p.password = password;
    p.key = g.API_KEY;

    var restHelper = new RestHelper();
    String lResp = await restHelper.post(g.URL_SERVER, p, context);
    var ret = json.decode(lResp);
    print(lResp);
    bool success = !ret["error"];

    if (success){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', p.phone);
      await prefs.setBool('logged', true);
      await prefs.setInt('uid', int.parse(ret["uid"]));
      await prefs.setString('name', ret["user"]["name"]);
      print(ret["user"]["name"]);
      print(int.parse(ret["uid"]).toString());

    } else {
      if (ret["error_msg"]=="wrong_auth_data") {
        _showFailedLogin(context, s.txtshowFailedLogin);
      } else if (ret["error_msg"]=="permission_denied") {
        _showFailedLogin(context, s.txtshowFailedDenied);
      } else if (ret["error_msg"]=="user_deactivated") {
        _showFailedLogin(context, s.txtshowFailedOff);
      } else {
        _showFailedLogin(context, s.txtshowFailedUnknown+": " +ret["error_msg"]);
      }
    }

    return success;
  }

  Future<bool> wait1sec() async {
    // Simulate a future for response after 1 second.
    await new Future<void>.delayed(
        new Duration(
            microseconds: 500
        )
    );
    return true;
  }

  // Logout
  Future<bool> logout(BuildContext context) async {
    bool success = true;
    // Simulate a future for response after 1 second.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', "");
    await prefs.setBool('logged', false);
    wait1sec();
    print("logout");
    Navigator.of(context).pushNamed('/login');
    return success;
  }
}
