import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> logged() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool logged = await prefs.getBool('logged');

  if (logged==null) {
    logged = false;
  }
  return logged;
}

bool isStringNOTEmpty(String s){
  try {
    if (s != null){
      if (s
          .toString()
          .length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print(e.toString());
    return false;
  }
}

bool addToList(List<String> list, String s){
  if (isStringNOTEmpty(s))
    if (s!="null"){
      list.add(s);
    }
}

bool addToListManyStings(List<String> list, String s, String check){
  if (isStringNOTEmpty(check))
    if (check!="null"){
      list.add(s);
    }
}

Widget widgetNetworkPhoto(BuildContext context, String navi,String url){
  //add foto
  return
        new GestureDetector(
          onTap: () {
             Navigator.of(context).pushNamed(navi);
          },
          child: new Image.network(url,
            fit: BoxFit.cover
          ),
        );

}