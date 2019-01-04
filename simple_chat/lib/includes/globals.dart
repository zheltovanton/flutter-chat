library globals;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';

String API_KEY = "tetetetet";

String URL_SERVER = "https://xdev.team/";
String URL_REGISTER = "login.php";

String Google_Maps_Key = "sasas";
String Google_Server_Key = "asasa";

String phonePrefix = "7";

class GlKeys {
  static final glKey1 = const Key('__GLKEY1__');
  static Key glKey2 = const Key('__GLKEY2__');
  static final glKey3 = const Key('__GLKEY3__');
}

class App {
  static SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}

const List<Color> coolColors = const <Color>[
  const Color.fromARGB(255, 255, 59, 48),
  const Color.fromARGB(255, 255, 149, 0),
  const Color.fromARGB(255, 255, 204, 0),
  const Color.fromARGB(255, 76, 217, 100),
  const Color.fromARGB(255, 90, 200, 250),
  const Color.fromARGB(255, 0, 122, 255),
  const Color.fromARGB(255, 88, 86, 214),
  const Color.fromARGB(255, 255, 45, 85),
];


const Color clBack = Color(0xFF272a29);
const Color clDefault = Color(0xFFdb992f);
const Color clDefaultLight = Color(0xFFdeceb3);
const Color clTextDefault = Color(0xFF4d4d4d);
const Color clDisabled = Color(0xFFe5e5e5);
MaterialColor clMatBack = const MaterialColor(0xFF272a29,
    const {
      50 : const Color(0xFF272a29),
      100 : const Color(0xFF272a29),
      200 : const Color(0xFF272a29),
      300 : const Color(0xFF272a29),
      400 : const Color(0xFF272a29),
      500 : const Color(0xFF272a29),
      600 : const Color(0xFF272a29),
      700 : const Color(0xFF272a29),
      800 : const Color(0xFF272a29),
      900 : const Color(0xFF272a29)});