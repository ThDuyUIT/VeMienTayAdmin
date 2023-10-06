import 'package:booking_transition_admin/feature/model/city.dart';

class RouteRowData {
  late String idRoute;
  late String idVehicle;
  // late String from;
  // late String where;
  late City from = City.non_para();
  late City where = City.non_para();
  late String departureDate;
  late String departureTime;
  late String price;
  late String urlImage;
  late String bookedSeat;
  late String featured;
  late String statusActive;
  late String capacity;
}
