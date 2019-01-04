import '../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import '../component/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';
import '../includes/strings.dart' as s;

RegExp _alphanumeric = new RegExp(r'^[a-zA-Z0-9]+$');

bool isAlphanumeric(String str) {
  return _alphanumeric.hasMatch(str);
}

class LoginPage extends StatefulWidget {
  BuildContext _context;
  LoginPage(BuildContext context) {
    this._context = context;
  }

  @override
  State<StatefulWidget> createState() => new _LoginPageState(_context);
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  BuildContext context;
  _LoginPageState(BuildContext _context) {
    this.context = _context;
  }
  String _status = 'no-action';

  String _phone = '';
  String _password = '';
  bool _loginButtonState = true;
  AnimationController _loginButtonController;
  final GlobalKey<FormState> _formLoginKey = new GlobalKey<FormState>();
  //FocusNode _focusNode = new FocusNode();
  static const String PATTERN_ALPHANUMERIC  = "^[a-zA-Z0-9öäüÖÄÜß]+\$";
  bool _obscureText = true;
  final _UsNumberTextInputFormatter _phoneNumberFormatter = new _UsNumberTextInputFormatter();
  bool logged;
  var animationStatus = 0;

  AuthService appAuth = new AuthService();

  void CheckLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final logged = await prefs.getBool('logged');

    if (logged){
      Navigator.of(context).pushReplacementNamed('/home');
      print("already logged, move to /");
    }

  }

  @override
  void initState() {
    CheckLogin();

    SystemChannels.textInput.invokeMethod('TextInput.show');
    super.initState();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }
  bool matchesPattern(String input, RegExp pattern) {
    return pattern.hasMatch(input);
  }

  bool isAlphaNumeric(String input) {
    return matchesPattern(input,new RegExp(PATTERN_ALPHANUMERIC));
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation(BuildContext context) async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
      Navigator.pushReplacementNamed(context, "/home");
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (new Scaffold(
      body: new Container(
          child: new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: <Color>[
                      const Color.fromRGBO(162, 162, 162, 0.8),
                      const Color.fromRGBO(51, 51, 51, 0.9),
                    ],
                    stops: [0.2, 1.0],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                  )),
              child: new ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  new Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.symmetric(horizontal: 20.0),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Form(
                                    key:_formLoginKey,
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        new Container(
                                          decoration: new BoxDecoration(
                                            border: new Border(
                                              bottom: new BorderSide(
                                                width: 0.5,
                                                color: Colors.white24,
                                              ),
                                            ),
                                          ),
                                          child:  new TextFormField(
                                            obscureText: false,
                                            maxLength: 10,
                                            //focusNode: _focusNode,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            onSaved: (val) {
                                              this._phone = val;
                                            },
                                            keyboardType: TextInputType.phone,
                                            validator: (String val) {
                                              //print(val);
                                              if (val.length < 10) {
                                                return "Формат телефона 79001234567";
                                              }
                                              if (!isAlphanumeric(val)){
                                                return "Формат телефона 79001234567";
                                              }
                                            },
                                            inputFormatters: <TextInputFormatter> [
                                              WhitelistingTextInputFormatter.digitsOnly,
                                              // Fit the validating format.
                                              //        _phoneNumberFormatter,
                                            ],

                                            decoration: new InputDecoration(
                                              icon: new Icon(
                                                Icons.person_outline,
                                                color: Colors.white,
                                              ),
                                              border: InputBorder.none,
                                              hintText: "Телефон",
                                              prefixText: '+7',
                                              hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),

                                              contentPadding: const EdgeInsets.only(
                                                  top: 10.0, right: 30.0, bottom: 10.0, left: 5.0),
                                            ),

                                          ),
                                        ),
                                        new Container(
                                          decoration: new BoxDecoration(
                                            border: new Border(
                                              bottom: new BorderSide(
                                                width: 0.5,
                                                color: Colors.white24,
                                              ),
                                            ),
                                          ),

                                          child: new TextFormField(
                                            obscureText: _obscureText,
                                            //focusNode: _focusNode,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                            onSaved: (val) => this._password = val,

                                            decoration: new InputDecoration(
                                              icon: new Icon(
                                                Icons.lock_outline,
                                                color: Colors.white,
                                              ),
                                              suffixIcon: new GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _obscureText = !_obscureText;
                                                  });
                                                },
                                                child: new Icon(
                                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                                    color: Colors.white),
                                              ),
                                              border: InputBorder.none,
                                              hintText: s.txtPassword,
                                              hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                              contentPadding: const EdgeInsets.only(
                                                  top: 20.0, right: 20.0, bottom: 20.0, left: 5.0),
                                            ),
                                          ),
                                        ),


                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(bottom: 50.0),
                        child: new InkWell(
                            onTap: () {
                              setState(() => this.animationStatus = 1);
                              setState(() => this._status = 'loading');
                              final form = _formLoginKey.currentState;
                              form.save();
                              print ("_phone,_password = " + _phone + _password);
                              appAuth.login(_phone,_password,context).then((result) {
                                if (result) {
                                  print(result.toString());
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  _playAnimation(context);
                                } else {
                                  setState(() => this.animationStatus = 0);
                                  setState(() => this._status = 'rejected');
                                  print('rejected');
                                }
                              });

                            }),
                      )

                    ],
                  ),
                ],
              ))),
    )
    );
  }
}

class _UsNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue
      ) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = new StringBuffer();
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1)
        selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3)
        selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6)
        selectionIndex++;
    }
    if (newTextLength >= 11) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 10) + ' ');
      if (newValue.selection.end >= 10)
        selectionIndex++;
    }
    // Dump the rest.
    if (newTextLength >= usedSubstringIndex)
      newText.write(newValue.text.substring(usedSubstringIndex));
    return new TextEditingValue(
      text: newText.toString(),
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }


}