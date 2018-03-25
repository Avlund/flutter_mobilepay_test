class Car {
  String licensePlate;
  String make;
  String model;
  int weight;
  bool used;

  Car({
    this.licensePlate,
    this.make,
    this.model,
    this.weight,
    this.used
  });
}

List<Car> cars = [
  new Car(
    licensePlate: "AB12345",
    make: "BMW",
    model: "X5",
    weight: 2000,
    used: false,
  ),
  new Car(
    licensePlate: "FE00700",
    make: "Citren",
    model: "DS4",
    weight: 1300,
    used: true,
  ),
  new Car(
    licensePlate: "AF65322",
    make: "AUDI",
    model: "Q7",
    weight: 2100,
    used: false,
  ),
];