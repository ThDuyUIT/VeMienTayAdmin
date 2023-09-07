import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RemoveData {
  static Future removeDetailTicket(List<String> detailID) async {
    DatabaseReference detailRef = FirebaseDatabase.instance.ref().child('CTVE');
    detailID.forEach((element) {
      DatabaseReference detailChild = detailRef.child(element);
      detailChild.remove();
    });
  }

  static Future removeTicket(String idTicket) async {
    try {
      DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');
      DatabaseReference ticketChild = ticketRef.child(idTicket);
      ticketChild.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future removeRoute(String idRoute) async {
    try {
      DatabaseReference routeRef =
          FirebaseDatabase.instance.ref().child('CHUYENXE');
      DatabaseReference routeChild = routeRef.child(idRoute);
      routeChild.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future removeCity(String idCity) async {
    try {
      DatabaseReference routeRef =
          FirebaseDatabase.instance.ref().child('DIADIEM');
      DatabaseReference routeChild = routeRef.child(idCity);
      routeChild.remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future removeImage(String nameBranch, String childBranch) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(nameBranch);
      final child = ref.child(childBranch);
      child.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future removeVehicle(String idVehicle) async {
    try {
      DatabaseReference routeRef = FirebaseDatabase.instance.ref().child('XE');
      DatabaseReference routeChild = routeRef.child(idVehicle);
      routeChild.remove();
      return true;
    } catch (e) {
      return false;
    }
  }
}
