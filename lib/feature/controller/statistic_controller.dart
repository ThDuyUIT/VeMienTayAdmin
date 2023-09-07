import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:booking_transition_admin/router/app_routes.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatisticController {
  Future totalSale(String time) async {
    int sales = 0;
    // List<String> prices = [];
    // prices = await GetData.fetchTicketTotalSale(time);
    // prices.forEach((element) {
    //   print(element);
    //   sales += int.parse(element);
    // });

    List<Ticket> tickets = [];
    tickets = await GetData.fetchTicket();
    tickets.forEach((element) {
      int timeStamp = int.parse(element.keyTicket.toString().substring(2));
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String formattedDate = DateFormat('M/yyyy').format(dateTime);
      print(formattedDate);
      if (formattedDate == time && element.statusPayment == '1') {
        sales += int.parse(element.priceTotal);
      }
    });

    return sales;
  }

  Future countTicket(String time) async {
    int numberOfTickets = 0;
    List<Ticket> tickets = [];
    tickets = await GetData.fetchTicket();
    tickets.forEach((element) {
      int timeStamp = int.parse(element.keyTicket.toString().substring(2));
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String formattedDate = DateFormat('M/yyyy').format(dateTime);

      if (formattedDate == time) {
        numberOfTickets += 1;
      }
    });
    print(numberOfTickets);
    return numberOfTickets;
  }

  Future predictSales(String time) async {
    List<Vehicle> vehicles = [];
    List<Transitions> routes = [];
    //int totalCapcity = 0;
    double predictSales = 0;
    vehicles = await GetData.fetchVehicle();
    routes = await GetData.fetchRoute();

    routes.forEach((elementRoutes) {
      int indexStart = elementRoutes.departureDate.indexOf('/') + 1;
      if (elementRoutes.departureDate.substring(indexStart) == time) {
        vehicles.forEach((elementVehicle) {
          if (elementRoutes.idVehicle == elementVehicle.idVehicle) {
            predictSales = predictSales +
                elementVehicle.capacity * int.parse(elementRoutes.prices);
          }
        });
      }
    });
    return predictSales;
  }

  Future percentEmptySeat(String time) async {
    List<Vehicle> vehicles = [];
    List<Transitions> routes = [];
    List<Ticket> tickets = [];
    List<DetailTicket> details = [];

    vehicles = await GetData.fetchVehicle();
    routes = await GetData.fetchRoute();
    tickets = await GetData.fetchTicket();
    details = await GetData.fetchDetailTicket();

    double sumSeat = 0;
    double bookedSeat = 0;
    double percentEmpty = 0;
    routes.forEach((elementRoute) {
      int indexStart = elementRoute.departureDate.indexOf('/') + 1;
      if (elementRoute.departureDate.substring(indexStart) == time) {
        vehicles.forEach((elementVehicle) {
          if (elementRoute.idVehicle == elementVehicle.idVehicle) {
            print(elementVehicle.capacity);
            sumSeat = sumSeat + (elementVehicle.capacity - 1);
          }
        });
        print(elementRoute.keyRoute);
        print(sumSeat);
        tickets.forEach((elementTicket) {
          if (elementRoute.keyRoute == elementTicket.idTransition) {
            details.forEach((elementDetail) {
              if (elementDetail.idTicket == elementTicket.keyTicket) {
                bookedSeat += 1;
              }
            });
          }
        });
      }
    });

    if (sumSeat == 0) {
      return 0;
    }

    percentEmpty = ((sumSeat - bookedSeat) / sumSeat) * 100;
    print(percentEmpty);
    return percentEmpty;
  }
}
