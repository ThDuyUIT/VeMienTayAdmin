import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';

class TriggerController {
  Future checkBookedRoute(String idRoute) async {
    List<Ticket> tickets = [];
    tickets = await GetData.fetchTicket();
    bool isBooked = false;
    for (var ticket in tickets) {
      if (ticket.idTransition == idRoute) {
        isBooked = true;
        break;
      }
    }
    return isBooked;
  }

  Future checkActiveCity(String idCity) async {
    List<Transitions> routes = [];
    routes = await GetData.fetchRoute();
    bool isActive = false;
    for (var route in routes) {
      if (route.from == idCity || route.where == idCity) {
        isActive = true;
        break;
      }
    }
    return isActive;
  }

  Future checkActiveVehicle(String idVehicle) async {
    List<Transitions> routes = [];
    routes = await GetData.fetchRoute();
    bool isActive = false;
    for (var route in routes) {
      if (route.idVehicle == idVehicle) {
        isActive = true;
        break;
      }
    }
    return isActive;
  }
}
