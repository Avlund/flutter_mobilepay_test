import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.io/mobilepay');

  @override
  Widget build(BuildContext context) {




    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Betal:',
            ),
            new Text(_mobilePayStatus)
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          new PageRouteBuilder(
            pageBuilder: (_, __, ___) => new SelectCarPage(),
          ),
        ),
        tooltip: 'pay',
        child: new Icon(Icons.add),
      ),
    );
  }
}