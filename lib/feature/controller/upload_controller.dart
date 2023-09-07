import 'dart:typed_data';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/services/insert_data.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class UploadController {
  Future uploadImage(
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

  Future updateTicket(Ticket ticket) async {
    final isUpdate = await InsertData().insertTicket(ticket);
    // if(isUpdateTicket){
    //   final isUpdateSeat = await InsertData().insertDetailTicket(detailTicket)
    // }
    return isUpdate;
  }
}
