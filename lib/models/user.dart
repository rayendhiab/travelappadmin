class User {
  late String id;
  late String nom;
  late String prenom;
  late DateTime date_de_naissance;
  late String email;
  late String mdp;
  late String role;
  late String domaine;
  late String emplacement;
  late String image;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.date_de_naissance,
    required this.email,
    required this.mdp,
    required this.role,
    required this.domaine,
    required this.emplacement,
    required this.image,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    nom = json['nom'];
    prenom = json['prenom'];
    date_de_naissance = json['date_de_naissance'];
    email = json['emailaddress'];
    mdp = json['mdp'];
    role = json['role'];
    domaine = json['domaine'];
    emplacement = json['emplacement'];
    image = json['image'];

  }
}
