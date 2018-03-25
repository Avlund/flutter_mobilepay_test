import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_pay_test/model/dagsbevis.dart';
import 'package:mobile_pay_test/ui/selectCarPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView(
        children: dagsbevisList.map((Dagsbevis db) {
          return _dagsbevisInfo(db);
        }).toList(),
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

  Widget _dagsbevisInfo(Dagsbevis bevis) {
    return new Card(
      child: new Row(
        children: <Widget>[
          new Text(
            bevis.car.licensePlate,
            style: new TextStyle(
                fontFamily: 'Rooboto',
                fontSize: 18.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          new Column(
            children: <Widget>[
              new Text(
          _dateToString(bevis.fromDate),
                style: new TextStyle(
                    fontFamily: 'Rooboto',
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
              new Text(
                _dateToString(bevis.toDate),
                style: new TextStyle(
                    fontFamily: 'Rooboto',
                    fontSize: 14.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _dateToString(DateTime date) {
    return "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
