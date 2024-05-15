class Event {
  late String id;
  late String name;
  late int numReservation;
  late String address;
  late String photo;
  late double prix;
  late int numMax;

  Event({
    required this.id,
    required this.name,
    required this.numReservation,
    required this.address,
    required this.photo,
    required this.prix,
    required this.numMax,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    name = json['nom'];
    numReservation = json['numReservation'];
    address = json['address'];
    photo = json['photo'];
    prix = double.parse(json['prix'].toString());
    numMax = json['numMax'];
  }
}
