import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Shared {
  Future<bool> isLogged() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged');
  }

  userPhone() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone');
  }

  userUid() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('uid');
  }


}
