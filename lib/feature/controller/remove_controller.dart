import 'package:booking_transition_admin/feature/controller/trigger_controller.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/feature/services/remove_data.dart';
import 'package:flutter/material.dart';

class RemoveController {
  Future removeSelectedSeats(List<String> detailID) async {
    try {
      await RemoveData.removeDetailTicket(detailID);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future removeATicket(String idTicket) async {
    late bool isRemove;
    isRemove = await RemoveData.removeTicket(idTicket);
    return isRemove;
  }

  Future removeARoute(String idRoute) async {
    late bool isRemove;
    bool isBooked = false;
    List<Ticket> tickets = [];
    tickets = await GetData.fetchTicket();
    for (var element in tickets) {
      if (element.idTransition == idRoute) {
        isBooked = true;
        break;
      }
    }
    if (isBooked) {
      isRemove = false;
    } else {
      isRemove = await RemoveData.removeRoute(idRoute);
    }
    return isRemove;
  }

  Future removeACity(String idCity) async {
    late bool isRemove;
    late bool isRemoveImg;
    final _triggerController = TriggerController();
    bool isActive = await _triggerController.checkActiveCity(idCity);
    // bool isActive = false;
    // List<Transitions> routes = [];
    // routes = await GetData.fetchRoute();
    // for (var element in routes) {
    //   if (element.from == idCity || element.where == idCity) {
    //     isActive = true;
    //     break;
    //   }
    // }
    if (isActive) {
      isRemove = false;
    } else {
      String childBranch = "img$idCity.png";
      isRemoveImg = await RemoveData.removeImage("DIADIEM", childBranch);
      if (isRemoveImg) {
        isRemove = await RemoveData.removeCity(idCity);
      }
    }
    return isRemove;
  }

  Future removeAVehicle(String idVehicle) async {
    late bool isRemove;
    late bool isRemoveImg;
    final _triggerController = TriggerController();
    bool isActive = await _triggerController.checkActiveVehicle(idVehicle);
    // bool isActive = false;
    // List<Transitions> routes = [];
    // routes = await GetData.fetchRoute();
    // for (var element in routes) {
    //   if (element.idVehicle == idVehicle) {
    //     isActive = true;
    //     break;
    //   }
    // }
    if (isActive) {
      isRemove = false;
    } else {
      String childBranch = "img$idVehicle.png";
      isRemoveImg = await RemoveData.removeImage("XE", childBranch);
      if (isRemoveImg) {
        isRemove = await RemoveData.removeVehicle(idVehicle);
      }
    }
    return isRemove;
  }
}
