class Hotel {
  late String id;
  late String name;
  late int stars;
  late String address;
  late String photo;
  late double prix;

  Hotel({
    required this.id,
    required this.name,
    required this.stars,
    required this.address,
    required this.photo,
    required this.prix,
  });

  Hotel.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    name = json['nom'];
    stars = json['etoile'];
    address = json['address'];
    photo = json['photo'];
    prix = double.parse(json['prix'].toString());
  }
}
