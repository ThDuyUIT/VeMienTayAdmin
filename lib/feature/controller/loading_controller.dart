import 'package:booking_transition_admin/feature/model/account.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/detail_ticket.dart';
import 'package:booking_transition_admin/feature/model/route.dart';
import 'package:booking_transition_admin/feature/model/ticket.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/item_city_data.dart';
import 'package:booking_transition_admin/feature/presentation/Dashboard/item_dashboard_data.dart';
import 'package:booking_transition_admin/feature/presentation/Route/item_route_data.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/item_ticket_data.dart';
import 'package:booking_transition_admin/feature/presentation/Ticket/seat_item.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/item_vehicle_data.dart';
import 'package:booking_transition_admin/feature/services/get_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LoadingController {
//   class DashBoardRowData {
//   late int number;
//   String fullName = '';
//   String phone = '';
//   String from = '';
//   String where = '';
//   String departureDate = '';
//   String bookedDate = '';
//   String prices = '';
// }
  Future setTicketData(String time, String phone) async {
    List<Ticket> tickets = [];
    List<Transitions> routes = [];
    List<Account> accounts = [];
    List<City> cities = [];
    List<TicketRowData> data = [];
    List<TicketRowData> result = [];

    tickets = await GetData.fetchTicket();
    routes = await GetData.fetchRoute();
    accounts = await GetData.fetchInfoAccount();
    cities = await GetData.fetchCities();

    tickets.forEach((elementTicket) {
      TicketRowData item = TicketRowData();
      routes.forEach((elementRoute) {
        if (elementTicket.idTransition == elementRoute.keyRoute) {
          if (elementRoute.departureDate == time) {
            item.idTicket = elementTicket.keyTicket;
            String idAccount = elementTicket.idAccount;
            if (idAccount.contains("KHVL") && idAccount.contains("PN")) {
              String name = idAccount.substring(
                  idAccount.indexOf('L') + 1, idAccount.indexOf('P'));
              String phoneNums =
                  idAccount.substring(idAccount.indexOf('N') + 1);
              item.name = name;
              item.phone = phoneNums;
              item.idAccount = elementTicket.idAccount;
            } else {
              item.name = elementTicket.idAccount;
            }

            //get prices + from + where + departure date + booked date
            //item.name = elementTicket.idAccount;
            item.idRoute = elementRoute.keyRoute;
            item.prices = elementTicket.priceTotal;
            item.from = elementRoute.from;
            item.where = elementRoute.where;
            item.departureDate = elementRoute.departureDate;
            item.departureTime = elementRoute.departureTime;
            item.statusPayment = elementTicket.statusPayment;
            item.statusTicket = elementTicket.statusTicket;
            item.methodPayment = elementTicket.methodPayment;

            cities.forEach((elementCity) {
              if (elementCity.idCity == item.from) {
                item.from = elementCity.nameCity;
              } else if (elementCity.idCity == item.where) {
                item.where = elementCity.nameCity;
              }
            });

            data.add(item);
          }
        }
      });
    });

    accounts.forEach((elementAccount) {
      data.forEach((elementData) {
        if (elementAccount.idAccount == elementData.name) {
          elementData.name = elementAccount.fullName;
          elementData.phone = elementAccount.phoneNums;
          elementData.idAccount = elementAccount.idAccount;
        }
      });
    });

    if (phone.isEmpty) {
      return data;
    } else {
      data.forEach((element) {
        if (element.phone.contains(phone)) {
          result.add(element);
        }
      });
      return result;
    }
  }

  Future setDashboardData(String time) async {
    List<Ticket> tickets = [];
    List<Vehicle> vehicles = [];
    List<Transitions> routes = [];
    List<City> cities = [];
    List<DetailTicket> details = [];
    List<DashboardRowData> data = [];

    tickets = await GetData.fetchTicket();
    vehicles = await GetData.fetchVehicle();
    routes = await GetData.fetchRoute();
    cities = await GetData.fetchCities();
    details = await GetData.fetchDetailTicket();

    routes.forEach((elementRoute) {
      DashboardRowData item = DashboardRowData();
      int indexStart = elementRoute.departureDate.indexOf('/') + 1;
      if (elementRoute.departureDate.substring(indexStart) == time) {
        //get
        item.departureDate = elementRoute.departureDate;
        item.departureTime = elementRoute.departureTime;
        item.idVehicle = elementRoute.idVehicle;
        item.from = elementRoute.from;
        item.where = elementRoute.where;
        item.prices = elementRoute.prices;

        int bookedSeat = 0;
        tickets.forEach((elementTicket) {
          if (elementRoute.keyRoute == elementTicket.idTransition) {
            details.forEach((elementDetail) {
              if (elementTicket.keyTicket == elementDetail.idTicket) {
                bookedSeat += 1;
              }
            });
          }
        });
        item.bookedSeat = bookedSeat.toString();

        data.add(item);
      }
    });

    if (data.isNotEmpty) {
      data.forEach((elementData) {
        vehicles.forEach((elementVehicle) {
          if (elementData.idVehicle == elementVehicle.idVehicle) {
            elementData.capacity = elementVehicle.capacity.toString();
          }
        });

        cities.forEach((elementCity) {
          if (elementData.from == elementCity.idCity) {
            elementData.from = elementCity.nameCity;
          } else if (elementData.where == elementCity.idCity) {
            elementData.where = elementCity.nameCity;
          }
        });
      });
    }
    return data;
  }

  Future setVehicleData() async {
    List<Vehicle> vehicles = [];
    List<Transitions> routes = [];
    List<VehicleRowData> data = [];
    vehicles = await GetData.fetchVehicle();
    routes = await GetData.fetchRoute();

    vehicles.forEach((elementVehicle) {
      VehicleRowData item = VehicleRowData();
      item.idVehicle = elementVehicle.idVehicle;
      item.capacity = elementVehicle.capacity.toString();
      item.name = elementVehicle.name;
      item.urlImage = elementVehicle.urlImage;

      int totalRoute = 0;
      routes.forEach((elementRoutes) {
        if (elementRoutes.idVehicle == elementVehicle.idVehicle) {
          totalRoute += 1;
        }
      });
      item.totalRoutes = totalRoute.toString();

      data.add(item);
    });
    return data;
  }

  Future setCityData() async {
    List<City> cities = [];
    List<CityRowData> data = [];

    cities = await GetData.fetchCities();

    cities.forEach((element) {
      CityRowData item = CityRowData();
      item.idCity = element.idCity;
      item.nameCity = element.nameCity;
      item.urlImage = element.urlImage;

      data.add(item);
    });
    print(data.length);
    return data;
  }

  Future setRouteData(String time) async {
    List<Ticket> tickets = [];
    List<Vehicle> vehicles = [];
    List<Transitions> routes = [];
    List<City> cities = [];
    List<DetailTicket> details = [];
    List<RouteRowData> data = [];

    tickets = await GetData.fetchTicket();
    vehicles = await GetData.fetchVehicle();
    routes = await GetData.fetchRoute();
    cities = await GetData.fetchCities();
    details = await GetData.fetchDetailTicket();

    routes.forEach((elementRoute) {
      RouteRowData item = RouteRowData();
      int indexStart = elementRoute.departureDate.indexOf('/') + 1;
      if (elementRoute.departureDate.substring(indexStart) == time) {
        item.idVehicle = elementRoute.idVehicle;
        item.idRoute = elementRoute.keyRoute;
        item.departureDate = elementRoute.departureDate;
        item.departureTime = elementRoute.departureTime;
        item.from.idCity = elementRoute.from;
        item.where.idCity = elementRoute.where;
        item.price = elementRoute.prices;
        item.featured = elementRoute.featured;

        int bookedSeat = 0;
        tickets.forEach((elementTicket) {
          if (elementRoute.keyRoute == elementTicket.idTransition) {
            details.forEach((elementDetail) {
              if (elementTicket.keyTicket == elementDetail.idTicket) {
                bookedSeat += 1;
              }
            });
          }
        });
        item.bookedSeat = bookedSeat.toString();

        data.add(item);
      }
    });

    if (data.isNotEmpty) {
      data.forEach((elementData) {
        // vehicles.forEach((elementVehicle) {
        //   if (elementData.idVehicle == elementVehicle.idVehicle) {
        //     elementData.capacity = elementVehicle.capacity.toString();
        //   }
        // });

        cities.forEach((elementCity) {
          if (elementData.from.idCity == elementCity.idCity) {
            elementData.from.nameCity = elementCity.nameCity;
          } else if (elementData.where.idCity == elementCity.idCity) {
            elementData.where.nameCity = elementCity.nameCity;
            //elementData.urlImage = elementCity.urlImage;
          }
        });
      });
    }
    return data;
  }

  // Future getBookedSeats(String idAccount) async {
  //   List<Ticket> tickets = [];
  //   List<DetailTicket> details = [];
  //   List<SeatItem> data = [];

  //   tickets = await GetData.fetchTicket();
  //   tickets.forEach((elementTicket) {
  //     if (elementTicket.idAccount == idAccount) {
  //       details.forEach((elementDetail) {
  //         if (elementDetail.idTicket == elementTicket.keyTicket) {
  //           SeatItem item = SeatItem(index: elementDetail.numberSeat);

  //           data.add(item);
  //         }
  //       });
  //     }
  //   });

  //   return data;
  // }

  Future searchRouteData(String from, String where, String date) async {
    List<Transitions> routes = [];
    List<Vehicle> vehicles = [];
    List<RouteRowData> data = [];
    routes = await GetData.fetchRoute();
    vehicles = await GetData.fetchVehicle();

    routes.forEach((elementRoute) {
      if (elementRoute.from == from &&
          elementRoute.where == where &&
          elementRoute.departureDate == date) {
        print(elementRoute.from);
        RouteRowData item = RouteRowData();
        item.idRoute = elementRoute.keyRoute;
        item.idVehicle = elementRoute.idVehicle;
        item.departureTime = elementRoute.departureTime;
        item.price = elementRoute.prices;

        vehicles.forEach((elementVehicle) {
          if (elementRoute.idVehicle == elementVehicle.idVehicle) {
            item.capacity = elementVehicle.capacity.toString();
          }
        });
        data.add(item);
      }
    });
    print(data.length);
    return data;
  }

  Future getBookedSeats(String idRoute) async {
    List<SeatItem> data = [];
    List<Transitions> routes = [];
    List<Ticket> tickets = [];
    List<DetailTicket> details = [];

    routes = await GetData.fetchRoute();
    tickets = await GetData.fetchTicket();
    details = await GetData.fetchDetailTicket();

    routes.forEach((elementRoute) {
      if (elementRoute.keyRoute == idRoute) {
        tickets.forEach((elementTicket) {
          if (elementRoute.keyRoute == elementTicket.idTransition) {
            details.forEach((elementDetail) {
              if (elementDetail.idTicket == elementTicket.keyTicket) {
                SeatItem item = SeatItem(index: elementDetail.numberSeat);
                data.add(item);
              }
            });
          }
        });
      }
    });
    return data;
  }

  Future getEditedSeat(String idTicket) async {
    List<DetailTicket> details = [];
    List<String> editedSeats = [];
    details = await GetData.fetchDetailTicket();

    details.forEach((element) {
      if (element.idTicket == idTicket) {
        editedSeats.add(element.numberSeat);
      }
    });
    return editedSeats;
  }

  Future getTheBookedRoute(String idRoute) async {
    late Transitions bookedRoute;
    List<Transitions> routes = [];

    routes = await GetData.fetchRoute();

    for (var element in routes) {
      if (element.keyRoute == idRoute) {
        bookedRoute = Transitions(
            keyRoute: element.keyRoute,
            prices: element.prices,
            idVehicle: element.idVehicle,
            departureDate: element.departureDate,
            departureTime: element.departureTime,
            from: element.from,
            where: element.where,
            featured: element.featured);
        break;
      }
    }
    return bookedRoute;
  }

  Future getTheBookedVehicle(String idVehicle) async {
    late Vehicle bookedVehicle;
    List<Vehicle> vehicles = [];

    vehicles = await GetData.fetchVehicle();
    for (var element in vehicles) {
      if (element.idVehicle == idVehicle) {
        bookedVehicle = Vehicle(
            idVehicle: element.idVehicle,
            name: element.name,
            capacity: element.capacity,
            urlImage: element.urlImage);
        break;
      }
    }
    return bookedVehicle;
  }

  Future getDetailId(String idTicket) async {
    List<DetailTicket> details = [];
    List<String> detailID = [];
    details = await GetData.fetchDetailTicket();

    details.forEach((element) {
      if (element.idTicket == idTicket) {
        detailID.add(element.keyDetail);
      }
    });
    return detailID;
  }
}
