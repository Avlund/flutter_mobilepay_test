import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_pay_test/model/car.dart';
import 'package:mobile_pay_test/model/dagsbevis.dart';
import 'package:mobile_pay_test/ui/homePage.dart';

class BuyPage extends StatefulWidget {
  BuyPage(this.car, {Key key, this.title}) : super(key: key);

  final Car car;
  final String title;

  @override
  _BuyPageState createState() => new _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  static const platform = const MethodChannel('samples.flutter.io/mobilepay');

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  bool _returned;
  DateTime selectedFromDate;
  String selectFromDate;
  DateTime selectedToDate;
  String selectToDate;
  String _selectedPrice;

  @override
  void initState() {
    _returned = false;

    selectedFromDate = new DateTime.now();
    selectFromDate = _dateToString(selectedFromDate);
    selectedToDate = new DateTime.now();
    selectToDate = _dateToString(selectedToDate);
  }

  Widget buildBody(BuildContext context) {
    if (_returned) {
      Scaffold
          .of(context)
          .showSnackBar(new SnackBar(content: new Text("test")));
    }

    return new ListView(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      children: [
        new Card(
            child: new RadioListTile(
          title: new Row(
            children: <Widget>[new Icon(Icons.payment), new Text("kr 180")],
          ),
          groupValue: _selectedPrice,
          onChanged: (String value) {
            setState(() {
              _selectedPrice = value;
            });
          },
          value: "180",
        )),
        new Card(
            child: new RadioListTile(
          title: new Row(
            children: <Widget>[new Icon(Icons.payment), new Text("kr 240")],
          ),
          groupValue: _selectedPrice,
          onChanged: (String value) {
            setState(() {
              _selectedPrice = value;
            });
          },
          value: "240",
        )),
        new Card(
          child: new Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.arrow_forward),
                  onPressed: () => _selectFromDate(context)),
              new Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: new Text(selectFromDate),
              ),
            ],
          ),
        ),
        new Card(
          child: new Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () => _selectToDate(context)),
              new Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: new Text(selectToDate),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new ListTile(
          title: new Text(
            widget.car.licensePlate,
            style: new TextStyle(
                fontFamily: 'Rooboto',
                fontSize: 18.0,
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold),
          ),
          subtitle: new Text(
            widget.car.make + " - " + widget.car.model,
            style: new TextStyle(fontFamily: 'Rooboto', color: Colors.orange),
          ),
        ),
      ),
      body: new Builder(builder: buildBody),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _pay(_selectedPrice),
        child: new Icon(Icons.shopping_cart),
      ),
    );
  }

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: selectedFromDate,
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        selectFromDate = _dateToString(picked);
      });
    }
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: selectedToDate,
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedToDate) {
      setState(() {
        selectToDate = _dateToString(picked);
      });
    }
  }

  Future<Null> _pay(String price) async {
    // 0: OK, 1: CANCELLED, 2: ERROR
    try {
      int status = await platform.invokeMethod('getMobilePayStatus', {"price": price});

      if (status == 0) {
        Dagsbevis bevis = new Dagsbevis(
          car: widget.car,
          fromDate: selectedFromDate,
          toDate: selectedToDate,
        );

        dagsbevisList.add(bevis);

        Navigator.of(context).push(
          new PageRouteBuilder(
            pageBuilder: (_, __, ___) => new HomePage(),
          ),
        );
      }
//      setState(() {
//        _returned = true;
//        _returnedWithStatus = status >= 0 ? 0 : 1;
//      });
    } catch (e) {
        int i = 0;
//      setState(() {
//        _returned = true;
//        _returnedWithStatus = 2;
//      });
    }
  }

  String _dateToString(DateTime date) {
    return "${date.year.toString()}-${date.month.toString().padLeft(
        2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
