class Reservation {
  late String id;
  late String dateReservation;
  late String dateDep;
  late String dateFin;
  late String userId;
  late String activityId;
  late String paymentId;
  late int numPerson;
  late String type;
  late bool validated;
  late double prix;

  Reservation({
    required this.id,
    required this.dateReservation,
    required this.dateDep,
    required this.dateFin,
    required this.userId,
    required this.paymentId,
    required this.activityId,
    required this.numPerson,
    required this.type,
    required this.validated,
    required this.prix,
  });

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['_id'].toString();
    dateReservation = json['dateReservation'];
    dateDep = json['dateDep'];
    dateFin = json['dateFin'];
    userId = json['userId'];
    numPerson = json['numPerson'];
    type = json['type'];
    validated = json['validated'];
    paymentId = json['paymentId'];
    activityId = json['activityId'];
  }
}
