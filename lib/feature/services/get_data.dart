import 'package:booking_transition_admin/feature/model/account.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GetData {
  // static Future fetchTicketTotalSale(String time) async {
  //   List<String> prices = [];
  //   DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');
  //   DatabaseEvent event = await ticketRef.once();
  //   if (event.snapshot.value != null) {
  //     Map<dynamic, dynamic> ticketData =
  //         event.snapshot.value as Map<dynamic, dynamic>;
  //     for (var ticketEntry in ticketData.entries) {
  //       var keyTicket = ticketEntry.key;
  //       var valueTicket = ticketEntry.value;

  //       int timeStamp = int.parse(keyTicket.toString().substring(2));
  //       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  //       String formattedDate = DateFormat('M/yyyy').format(dateTime);
  //       if (formattedDate == time && valueTicket['statusPayment'] == '1') {
  //         prices.add(valueTicket['priceTotal']);
  //       }
  //     }
  //   }
  //   return prices;
  // }

  static Future fetchTicket() async {
    List<Ticket> tickets = [];

    DatabaseReference ticketRef = FirebaseDatabase.instance.ref().child('VE');
    DatabaseEvent event = await ticketRef.orderByKey().once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> ticketData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var ticketEntry in ticketData.entries) {
        var keyTicket = ticketEntry.key;
        var valueTicket = ticketEntry.value;

        print(keyTicket);

        Ticket item = Ticket(
            keyTicket: keyTicket,
            idAccount: valueTicket['idaccount'],
            idTransition: valueTicket['idtransition'],
            priceTotal: valueTicket['pricestotal'],
            methodPayment: valueTicket['methodpayment'],
            statusPayment: valueTicket['statuspayment'],
            statusTicket: valueTicket['statusticket']);

        tickets.add(item);
      }
    }
    return tickets.reversed.toList();
  }

  static Future fetchVehicle() async {
    List<Vehicle> vehicles = [];

    DatabaseReference vehicleRef = FirebaseDatabase.instance.ref().child('XE');
    DatabaseEvent event = await vehicleRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> vehicleData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var vehicleEntry in vehicleData.entries) {
        var keyVehicle = vehicleEntry.key;
        var valueVehicle = vehicleEntry.value;

        Vehicle item = Vehicle(
            idVehicle: keyVehicle,
            name: valueVehicle['namevehicle'],
            capacity: valueVehicle['capacity'],
            urlImage: valueVehicle['imgvehicle'],
            location: valueVehicle['location']);

        vehicles.add(item);
      }
    }

    return vehicles;
  }

  // static Future fetchVehicleWithLocation(String idCity) async {
  //   List<Vehicle> vehicles = [];

  //   DatabaseReference vehicleRef = FirebaseDatabase.instance.ref().child('XE');
  //   DatabaseEvent event = await vehicleRef.once();
  //   if (event.snapshot.value != null) {
  //     Map<dynamic, dynamic> vehicleData =
  //         event.snapshot.value as Map<dynamic, dynamic>;
  //     for (var vehicleEntry in vehicleData.entries) {
  //       var keyVehicle = vehicleEntry.key;
  //       var valueVehicle = vehicleEntry.value;
  //       if()
  //       Vehicle item = Vehicle(
  //           idVehicle: keyVehicle,
  //           name: valueVehicle['namevehicle'],
  //           capacity: valueVehicle['capacity'],
  //           urlImage: valueVehicle['imgvehicle'],
  //           location: valueVehicle['location']);

  //       vehicles.add(item);
  //     }
  //   }

  //   return vehicles;
  // }

  static Future fetchRoute() async {
    List<Transitions> routes = [];

    DatabaseReference routeRef =
        FirebaseDatabase.instance.ref().child('CHUYENXE');
    DatabaseEvent event = await routeRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> routeData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var routeEntry in routeData.entries) {
        var keyRoute = routeEntry.key;
        var valueRoute = routeEntry.value;

        Transitions item = Transitions(
            keyRoute: keyRoute,
            prices: valueRoute['priceticket'],
            idVehicle: valueRoute['idvehicle'],
            departureDate: valueRoute['departuredate'],
            departureTime: valueRoute['departuretime'],
            from: valueRoute['startpoint'],
            where: valueRoute['endpoint'],
            featured: valueRoute['featuredroute'],
            statusActive: valueRoute['statusactive']);

        routes.add(item);
      }
    }
    //print()
    return routes.reversed.toList();
  }

  static Future fetchDetailTicket() async {
    List<DetailTicket> detailTickets = [];
    DatabaseReference detailRef = FirebaseDatabase.instance.ref().child('CTVE');
    DatabaseEvent event = await detailRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> detailData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var detailEntry in detailData.entries) {
        var keyDetail = detailEntry.key;
        var valueDetail = detailEntry.value;

        DetailTicket item = DetailTicket(
            idTicket: valueDetail['idticket'],
            numberSeat: valueDetail['numberseat']);
        item.keyDetail = keyDetail;
        detailTickets.add(item);
      }
    }
    return detailTickets;
  }

  static Future fetchInfoAccount() async {
    List<Account> accounts = [];
    DatabaseReference accountRef =
        FirebaseDatabase.instance.ref().child('KHACHHANG');
    DatabaseEvent event = await accountRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> accountData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var accountEntry in accountData.entries) {
        var keyAccount = accountEntry.key;
        var valueAccount = accountEntry.value;

        Account item = Account(
            idAccount: keyAccount,
            fullName: valueAccount['fullname'],
            phoneNums: valueAccount['phonenums']);

        accounts.add(item);
      }
    }
    return accounts;
  }

  static Future fetchCities() async {
    List<City> cities = [];
    DatabaseReference citieslRef =
        FirebaseDatabase.instance.ref().child('DIADIEM');
    DatabaseEvent event = await citieslRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> citiesData =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var citytEntry in citiesData.entries) {
        var keyCity = citytEntry.key;
        var valueCity = citytEntry.value;

        City item = City(
            idCity: keyCity,
            nameCity: valueCity['namecity'],
            urlImage: valueCity['imgcity']);

        cities.add(item);
      }
    }
    return cities;
  }
}
