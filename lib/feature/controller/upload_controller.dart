import 'dart:math';
import 'dart:typed_data';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/feature/services/insert_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class UploadController {
  Future uploadImageCity(
      Uint8List image, String nameBranch, String keyChild) async {
    img.Image? resizedImage = img.decodeImage(image);
    // img.Image resized =
    //     img.copyResize(resizedImage!, width: width, height: height);
    Uint8List resizedImageData =
        Uint8List.fromList(img.encodeJpg(resizedImage!));
    final urlImage =
        await InsertData().insertImage(resizedImageData, nameBranch, keyChild);

    return urlImage;
  }

  Future uploadImageVehicle(
    Uint8List image,
    int width,
    int height,
    String nameBranch,
    String keyChild,
  ) async {
    img.Image? resizedImage = img.decodeImage(image);
    img.Image resized =
        img.copyResize(resizedImage!, width: width, height: height);
    Uint8List resizedImageData = Uint8List.fromList(img.encodeJpg(resized));
    final urlImage =
        await InsertData().insertImage(resizedImageData, nameBranch, keyChild);

    return urlImage;
  }

  Future updateVehicle(Vehicle vehicle) async {
    final isUpdate = await InsertData().insertVehicle(vehicle);
    return isUpdate;
  }

  Future updateCity(City city) async {
    final isUpdate = await InsertData().insertCity(city);
    return isUpdate;
  }

  Future updateRoute(Transitions route) async {
    final isUpdate = await InsertData().insertRoute(route);
    return isUpdate;
  }

  Future updateStatusTicket(Transitions route) async {
    List<Ticket> tickets = [];
    tickets = await GetData.fetchTicket();
    tickets.forEach((element) async {
      if (element.idTransition == route.keyRoute &&
          element.statusTicket != '2') {
        element.statusTicket = route.statusActive;
        await InsertData().insertTicket(element);
        // if (element.statusTicket == '1') {

        //   DatabaseReference refBranch =
        //       FirebaseDatabase.instance.ref().child('XE');
        //   DatabaseReference refChild = refBranch.child(route.idVehicle);

        //   await refChild.set({'location': route.where});
        // }
      }
    });
  }

  Future updateLocationVehicle(Transitions route) async {
    List<Vehicle> vehicles = [];
    vehicles = await GetData.fetchVehicle();
    vehicles.forEach((element) async {
      if (element.idVehicle == route.idVehicle) {
        //print()
        element.location = route.where;
        await InsertData().insertVehicle(element);
      }
    });
  }

  Future updateTicket(Ticket ticket) async {
    final isUpdate = await InsertData().insertTicket(ticket);
    // if(isUpdateTicket){
    //   final isUpdateSeat = await InsertData().insertDetailTicket(detailTicket)
    // }
    return isUpdate;
  }
}
