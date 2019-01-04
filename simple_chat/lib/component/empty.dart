
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../includes/strings.dart' as s;
import '../includes/globals.dart' as g;

class UIElementEmpty extends StatelessWidget {

  final TextStyle style = new TextStyle(color:g.clTextDefault, fontSize: 22.0, fontFamily: 'Roboto');

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    alignment: new FractionalOffset(1.0, 2.0),
                    child: new Icon(Icons.error, color: g.clDefault)),
                new Text(
                  s.txtNothingFind,
                  style: style,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UIElementLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Dialog(
        child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child:new Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                new CircularProgressIndicator(
                    value: null,
                    strokeWidth: 2.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        g.clDefault)),
                new Text(s.txtLoading),
              ],
            )
        )
    );
  }
}
