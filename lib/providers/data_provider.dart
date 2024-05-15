import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:travel_app_admin/models/event.dart';
import 'package:travel_app_admin/models/hotel.dart';
import 'package:travel_app_admin/models/reservation.dart';
import 'package:travel_app_admin/models/user.dart';
import 'package:travel_app_admin/models/voyage.dart';
import 'package:path/path.dart';
import "package:async/async.dart";

class DataProvider with ChangeNotifier {
  String serverUrl = "http://localhost:3000";
  //String serverUrl = "http://10.0.2.2:6000";
  late User user;
  String token = "";
  List<Hotel> hotels = [];
  List<Event> events = [];
  List<Voyage> voyages = [];
  List<Reservation> reservations = [];
  List<User> agents = [];
  List<User> clients = [];

  double totalIcome = 0;

  Future<void> loadData() async {
    await getEvents();
    await getReservations();
    await getHotels();
    await getVoyages();
    await getUsers();
  }

  Future<bool> login(String emailaddress, String password) async {
    bool resultat = false;
    final url = serverUrl + "/signin/";

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"emailaddress": "test@gmail.com", "password": password}));

    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      user = User.fromJson(extractedData['User']);
      token = extractedData['token'];
      await loadData();
      resultat = true;
    } else {
      print(response.body);
    }

    notifyListeners();

    return resultat;
  }

  Future<void> register(String name, String emailaddress, String password,
      String telephone) async {
    final url = serverUrl + "/signin/signup";

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "emailaddress": emailaddress,
          "password": password,
          "telephone": telephone
        }));

    print(response.body);
  }

  Future<void> getHotels() async {
    hotels = [];
    final url = serverUrl + "/hotel";

    final response = await http.get(Uri.parse(url));

    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final hotelsList = extractedData['hotelList'] as List<dynamic>;
      hotelsList.forEach((element) {
        var hotel = Hotel.fromJson(element);

        hotels.add(hotel);
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getEvents() async {
    events = [];
    final url = serverUrl + "/event";

    final response = await http.get(Uri.parse(url));

    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final eventList = extractedData['eventList'] as List<dynamic>;
      eventList.forEach((element) {
        var event = Event.fromJson(element);

        events.add(event);
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getVoyages() async {
    voyages = [];
    final url = serverUrl + "/voyage";

    final response = await http.get(Uri.parse(url));

    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final voyageList = extractedData['voyageList'] as List<dynamic>;
      voyageList.forEach((element) {
        var voyage = Voyage.fromJson(element);

        voyages.add(voyage);
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> confirmReservation(String id) async {
    final url = serverUrl + "/booking/confirmBooking";

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "date": DateTime.now().toString().substring(0, 10),
          "idBooking": id,
        }));

    print(response.body);
    await getReservations();
  }

  Future<void> getReservations() async {
    reservations = [];
    totalIcome = 0;
    final url = serverUrl + "/booking";

    final response = await http.get(Uri.parse(url));

    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final bookingList = extractedData['bookingList'] as List<dynamic>;
      for (var element in bookingList) {
        var reservation = Reservation.fromJson(element);
        final url2 = serverUrl + "/payment/get/" + reservation.paymentId;
        final response2 = await http.get(Uri.parse(url2));
        final paymentData = json.decode(response2.body) as Map<String, dynamic>;
        reservation.prix = double.parse(paymentData["montant"].toString());

        reservations.add(reservation);

        if (reservation.validated) {
          totalIcome += reservation.prix;
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getUsers() async {
    agents = [];
    clients = [];
    final url = serverUrl + "/signin";

    final response = await http.get(Uri.parse(url));

    try {
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final userList = extractedData['userList'] as List<dynamic>;
      userList.forEach((element) {
        var user = User.fromJson(element);

        if (user.role == "user") {
          clients.add(user);
        } else if (user.role == "agent") {
          agents.add(user);
        }
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> addAgent(String name, String emailaddress, String password,
      String telephone) async {
    final url = serverUrl + "/signin/signup";

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "emailaddress": emailaddress,
          "password": password,
          "telephone": telephone,
          "role": "agent"
        }));

    print(response.body);
    await getUsers();
  }

  Future<void> addEvent(
      String name, int numMax, String address, double prix, XFile image) async {
    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse(serverUrl + '/event/ajouter');

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile =
        new http.MultipartFile("file", stream, length, filename: 'event.jpg');

    request.files.add(multipartFile);
    request.fields['numMax'] = numMax.toString();
    request.fields['nom'] = name;
    request.fields['address'] = address;
    request.fields['desc'] = "Description";
    request.fields['prix'] = prix.toString();

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Uploaded");
    } else {
      print(respond.statusCode);
      final bodyres = await respond.stream.bytesToString();
      print(bodyres);
      print("Upload Failed");
    }

    // final url = serverUrl + "/event/ajouter";

    // final response = await http.post(Uri.parse(url),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       "nom": name,
    //       "numMax": numMax,
    //       "address": address,
    //       "photo": "https://linstant-m.tn//uploads/6522.png",
    //       "desc": "Hammamet : Les soirées les plus sympas du week-end !",
    //       "prix": prix
    //     }));

    // print(response.body);
    await getEvents();
  }

  Future<void> addVoyage(
      String name, int numMax, String address, double prix, XFile image) async {
    // final url = serverUrl + "/voyage/ajouter";

    // final response = await http.post(Uri.parse(url),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       "nom": name,
    //       "numMax": numMax,
    //       "address": address,
    //       "photo":
    //           "https://images.etstur.com/files/images/hotelImages/TR/50292/m/Voyage-Belek-Golf---Spa-Genel-366453.jpg",
    //       "desc": "Hammamet : Les soirées les plus sympas du week-end !",
    //       "prix": prix
    //     }));

    // print(response.body);

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse(serverUrl + '/voyage/ajouter');

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile =
        new http.MultipartFile("file", stream, length, filename: 'voyage.png');

    request.files.add(multipartFile);
    request.fields['numMax'] = numMax.toString();
    request.fields['nom'] = name;
    request.fields['address'] = address;
    request.fields['desc'] = "Description";
    request.fields['prix'] = prix.toString();

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Uploaded");
    } else {
      print("Upload Failed");
    }
    await getVoyages();
  }

  Future<void> addHotel(
      String name, int etoile, String address, double prix, XFile image) async {
    // final url = serverUrl + "/hotel/ajouter";

    // final response = await http.post(Uri.parse(url),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       "nom": name,
    //       "etoile": etoile,
    //       "address": address,
    //       "photo":
    //           "https://images.etstur.com/files/images/hotelImages/TR/50292/m/Voyage-Belek-Golf---Spa-Genel-366453.jpg",
    //       "desc": "Hammamet : Les soirées les plus sympas du week-end !",
    //       "prix": prix
    //     }));

    // print(response.body);

    var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse(serverUrl + '/hotel/ajouter');

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile =
        new http.MultipartFile("file", stream, length, filename: 'hotel.png');

    request.files.add(multipartFile);
    request.fields['etoile'] = etoile.toString();
    request.fields['nom'] = name;
    request.fields['address'] = address;
    request.fields['desc'] = "Description";
    request.fields['prix'] = prix.toString();

    var respond = await request.send();
    if (respond.statusCode == 200) {
      print("Uploaded");
    } else {
      print("Upload Failed");
    }
    await getHotels();
  }
}
