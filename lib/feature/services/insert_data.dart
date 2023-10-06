import 'dart:io';
import 'dart:typed_data';

import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InsertData {
  Future insertImage(
      Uint8List resizedImageData, String nameBranch, String childBranch) async {
    print(nameBranch);
    print(childBranch);
    try {
      final ref = FirebaseStorage.instance.ref().child(nameBranch);
      final uploadTask = await ref
          .child('img$childBranch.png')
          .putData(resizedImageData, SettableMetadata(contentType: 'image/png'))
          .whenComplete(() {});
      final urlDownload = await uploadTask.ref.getDownloadURL();
      return urlDownload;
    } catch (e) {
      print(e);
      print('fail upload image');
    }
  }

  // Future updateVehicle(Vehicle updateVehicle) async {
  //   DatabaseReference refBranch = FirebaseDatabase.instance.ref().child('XE');
  //   DatabaseReference refChild = refBranch.child(updateVehicle.idVehicle);

  //   try {
  //     await refChild.set({
  //       'nameTicket': updateVehicle.name,
  //       'capacity': updateVehicle.capacity,
  //       'anhdaidienXe': updateVehicle.urlImage
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future insertVehicle(Vehicle newVehicle) async {
    DatabaseReference refBranch = FirebaseDatabase.instance.ref().child('XE');
    DatabaseReference refChild = refBranch.child(newVehicle.idVehicle);

    try {
      await refChild.set({
        'namevehicle': newVehicle.name,
        'capacity': newVehicle.capacity,
        'imgvehicle': newVehicle.urlImage,
        'location': newVehicle.location
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future insertCity(City newCity) async {
    DatabaseReference refBranch =
        FirebaseDatabase.instance.ref().child('DIADIEM');
    DatabaseReference refChild = refBranch.child(newCity.idCity);

    try {
      await refChild
          .set({'namecity': newCity.nameCity, 'imgcity': newCity.urlImage});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future insertRoute(Transitions newRoute) async {
    DatabaseReference refBranch =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseReference refChild = refBranch.child(newRoute.keyRoute);

    try {
      await refChild.set({
        'idvehicle': newRoute.idVehicle,
        'departuredate': newRoute.departureDate,
        'departuretime': newRoute.departureTime,
        'endpoint': newRoute.where,
        'featuredroute': newRoute.featured,
        'priceticket': newRoute.prices,
        'startpoint': newRoute.from,
        'statusactive': newRoute.statusActive
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future insertTicket(Ticket ticket) async {
    DatabaseReference refBranch = FirebaseDatabase.instance.ref().child('VE');
    DatabaseReference refChild = refBranch.child(ticket.keyTicket);

    try {
      await refChild.set({
        'idaccount': ticket.idAccount,
        'idtransition': ticket.idTransition,
        'methodpayment': ticket.methodPayment,
        'pricestotal': ticket.priceTotal,
        'statuspayment': ticket.statusPayment,
        'statusticket': ticket.statusTicket
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future insertDetailTicket(DetailTicket detailTicket) async {
    DatabaseReference refBranch = FirebaseDatabase.instance.ref().child('CTVE');
    DatabaseReference refChild =
        refBranch.child('CT${DateTime.now().millisecondsSinceEpoch}');

    try {
      await refChild.set({
        'idticket': detailTicket.idTicket,
        'numberseat': detailTicket.numberSeat,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
