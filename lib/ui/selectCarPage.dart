import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_pay_test/model/car.dart';
import 'package:mobile_pay_test/ui/buyPage.dart';

class SelectCarPage extends StatefulWidget {
  SelectCarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectCarPageState createState() => new _SelectCarPageState();
}

class _SelectCarPageState extends State<SelectCarPage> {
  List<Car> _searchResult;
  TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    var list = cars.where((car) => car.used).toList();
    list.sort((car1, car2) => car1.licensePlate.compareTo(car2.licensePlate));
    _searchResult = [];

    _searchController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var searchField = new TextField(
      controller: _searchController,
      decoration: new InputDecoration(
        hintText: 'Søg',
        hintStyle:
            new TextStyle(fontFamily: 'Rooboto', fontWeight: FontWeight.w300),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: searchField,
      ),
      body: new Container(
        alignment: new Alignment(0.0, 0.0),
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: cars
              .where((car) => car.used)
              .map(
                (Car car) => new Card(
                      child: new FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                                new PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new BuyPage(car),
                                ),
                              );
                        },
                        child: new ListTile(
                          leading: new Icon(Icons.add),
                          title: new Text(
                            car.make,
                          ),
                          subtitle: new Text(
                            car.model,
                          ),
                        ),
                      ),
                    ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.search),
          onPressed: () {
            Car foundCar = cars.firstWhere((car) =>
                car.licensePlate.toLowerCase() ==
                _searchController.text.toLowerCase());

            if (foundCar != null) {
              Navigator.of(context).push(
                    new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new BuyPage(foundCar),
                    ),
                  );
            }
          }),
    );
  }
}
