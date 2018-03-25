import 'package:mobile_pay_test/model/car.dart';

class Dagsbevis {
  Car car;
  DateTime fromDate;
  DateTime toDate;

  Dagsbevis({
    this.car,
    this.fromDate,
    this.toDate,
  });
}

List<Dagsbevis> dagsbevisList = [
  new Dagsbevis(
      car: new Car(
        licensePlate: "AB12345",
        make: "BMW",
        model: "X5",
      ),
      fromDate: new DateTime(2018, 2, 3),
      toDate: new DateTime(2018, 2, 3)),
  new Dagsbevis(
      car: new Car(
        licensePlate: "AB12345",
        make: "BMW",
        model: "X5",
      ),
      fromDate: new DateTime(2018, 2, 21),
      toDate: new DateTime(2018, 2, 22)),
];
