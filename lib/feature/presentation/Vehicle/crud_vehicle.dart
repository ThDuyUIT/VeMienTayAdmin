import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/mycupertinodialog.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/remove_controller.dart';
import 'package:booking_transition_admin/feature/controller/trigger_controller.dart';

import 'package:booking_transition_admin/feature/controller/upload_controller.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/model/vehicle.dart';
import 'package:booking_transition_admin/feature/presentation/Vehicle/item_vehicle_data.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CrudVehicle extends StatefulWidget {
  bool isAddNew = false;
  late VehicleRowData vehicle;

  CrudVehicle.update({super.key, required this.vehicle});
  CrudVehicle.create({super.key, required this.isAddNew});

  @override
  State<StatefulWidget> createState() {
    return StateEditVehicle();
  }
}

class StateEditVehicle extends State<CrudVehicle> {
  TextEditingController? _idVehicleEditingController;
  TextEditingController? _nameVehicleEditingController;
  TextEditingController? _capcityVehicleEditingController;
  late String totalSeats;
  bool imageFromFile = false;
  late Uint8List imageFile;
  final _appSnackbar = AppSnackbar();
  static late bool isActive;
  static TriggerController triggerController = TriggerController();

  final _cupertinoDialog = MyCupertinoDialog();
  final _removeController = RemoveController();
  List<String> typesOfVehicle = ['16', '29'];
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  static List<City> location = [];
  late String currentLocation;

  static List<String> upcomingRouteVehicles = [];

  @override
  void initState() {
    if (widget.isAddNew == false) {
      totalSeats = widget.vehicle.capacity;
      currentLocation = widget.vehicle.currentLocation;
      _idVehicleEditingController =
          TextEditingController(text: widget.vehicle.idVehicle);
      _nameVehicleEditingController =
          TextEditingController(text: widget.vehicle.name);
      _capcityVehicleEditingController =
          TextEditingController(text: widget.vehicle.capacity);
    } else {
      totalSeats = '16';
      currentLocation = location[0].idCity;
      _nameVehicleEditingController = TextEditingController();
      _capcityVehicleEditingController = TextEditingController();
      _idVehicleEditingController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(location.length);
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              foregroundColor: AppColor.mainColor,
              title: const Text(
                'Go back',
                style: TextStyle(fontFamily: 'Roboto bold', fontSize: 20),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.isAddNew == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Add new vehicle',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  color: AppColor.mainColor,
                                  fontSize: 25),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 300,
                              //flex: 1,
                              child: TextField(
                                controller: _idVehicleEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Enter vehicle\'s ID',
                                  hintStyle:
                                      TextStyle(color: AppColor.mainColor),
                                  //icon: const Icon(Icons.account_circle_outlined),
                                  label: Text(
                                    'ID',
                                    style: TextStyle(color: AppColor.mainColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // Change the default border color
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: AppColor.mainColor,
                                        width: 2), // Change color and width
                                  ),
                                ),
                              ),
                            ),
                            //Expanded(flex: 4, child: SizedBox())
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Edit vehicle - ID: ${widget.vehicle.idVehicle}',
                              style: TextStyle(
                                  fontFamily: 'Roboto bold',
                                  color: AppColor.mainColor,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor.mainColor),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: widget.isAddNew == true
                                ? imageFromFile == true
                                    ? Image.memory(
                                        imageFile,
                                        width: 500,
                                        height: 300,
                                      )
                                    : Icon(
                                        Icons.directions_car_filled_rounded,
                                        size: 50,
                                        color: AppColor.mainColor,
                                      )
                                : imageFromFile
                                    ? Image.memory(
                                        imageFile,
                                        width: 500,
                                        height: 300,
                                      )
                                    : Image(
                                        width: 500,
                                        height: 300,
                                        image: NetworkImage(
                                            '${widget.vehicle.urlImage}&timestamp=$timestamp'))),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          //padding: EdgeInsets.only(bottom: 20),
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainColor,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                final pickedFile =
                                    await ImagePickerWeb.getImageAsBytes();
                                setState(() {
                                  if (pickedFile != null) {
                                    imageFile = pickedFile;
                                    imageFromFile = true;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.upgrade_outlined,
                                size: 25,
                              ),
                              label: const Text(
                                'Upload image',
                                style: TextStyle(
                                    fontFamily: 'Roboto bold', fontSize: 18),
                              )),
                        ),
                        Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                    child: widget.isAddNew || !isActive
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto bold',
                                                    fontSize: 18,
                                                    color: Colors.grey),
                                              ),
                                              TextField(
                                                controller:
                                                    _nameVehicleEditingController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter vehicle\'s name',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          AppColor.mainColor),
                                                  //icon: const Icon(Icons.account_circle_outlined),
                                                  // label: Text(
                                                  //   'Name',
                                                  //   style: TextStyle(
                                                  //       color:
                                                  //           AppColor.mainColor),
                                                  // ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    // Change the default border color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color:
                                                            AppColor.mainColor,
                                                        width:
                                                            2), // Change color and width
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    fontFamily: 'Roboto bold',
                                                    fontSize: 18,
                                                    color: Colors.grey),
                                              ),
                                              TextField(
                                                readOnly: true,
                                                controller:
                                                    _nameVehicleEditingController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter vehicle\'s name',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          AppColor.mainColor),
                                                  //icon: const Icon(Icons.account_circle_outlined),
                                                  // label: Text(
                                                  //   'Name',
                                                  //   style: TextStyle(
                                                  //       color:
                                                  //           AppColor.mainColor),
                                                  // ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    // Change the default border color
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color:
                                                            AppColor.mainColor,
                                                        width:
                                                            2), // Change color and width
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Capacity',
                                        style: TextStyle(
                                            fontFamily: 'Roboto bold',
                                            fontSize: 18,
                                            color: Colors.grey),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 4, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.mainColor)),
                                        child: DropdownButton(
                                            dropdownColor: Colors.white,
                                            isExpanded: true,
                                            value: totalSeats,
                                            items: typesOfVehicle
                                                .map((e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(e),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (widget.isAddNew) {
                                                setState(() {
                                                  totalSeats = value!;
                                                });
                                              } else {
                                                if (isActive) {
                                                  _appSnackbar.buildSnackbar(
                                                      context,
                                                      "Exist active route. Can\'t update!");
                                                } else {
                                                  setState(() {
                                                    totalSeats = value!;
                                                  });
                                                }
                                              }
                                            }),
                                      ),
                                    ],
                                  ),
                                  // TextField(
                                  //   controller:
                                  //       _capcityVehicleEditingController,
                                  //   //style: ,
                                  //   keyboardType: TextInputType.number,
                                  //   decoration: InputDecoration(
                                  //     hintText: 'Enter capacity',
                                  //     hintStyle:
                                  //         TextStyle(color: AppColor.mainColor),
                                  //     //icon: const Icon(Icons.account_circle_outlined),
                                  //     label: Text(
                                  //       'Capacity',
                                  //       style: TextStyle(
                                  //           color: AppColor.mainColor),
                                  //     ),
                                  //     border: OutlineInputBorder(
                                  //       borderRadius: BorderRadius.circular(5),
                                  //     ),
                                  //     enabledBorder: OutlineInputBorder(
                                  //       // Change the default border color
                                  //       borderRadius: BorderRadius.circular(5),
                                  //       borderSide: BorderSide(
                                  //           color: AppColor.mainColor,
                                  //           width: 2), // Change color and width
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                          fontFamily: 'Roboto bold',
                                          fontSize: 18,
                                          color: Colors.grey),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 15),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          border: Border.all(
                                              width: 2,
                                              color: AppColor.mainColor)),
                                      child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          isExpanded: true,
                                          value: currentLocation,
                                          items: location
                                              .map((e) => DropdownMenuItem(
                                                    value: e.idCity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: Text(e.nameCity),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            if (widget.isAddNew) {
                                              setState(() {
                                                currentLocation = value!;
                                              });
                                            } else {
                                              if (upcomingRouteVehicles
                                                  .contains(widget
                                                      .vehicle.idVehicle)) {
                                                _appSnackbar.buildSnackbar(
                                                    context,
                                                    "The vehicle is being used. Can\'t update!");
                                              } else {
                                                setState(() {
                                                  currentLocation = value!;
                                                });
                                              }
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 20),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                                onPressed: () async {
                                                  print(
                                                      _idVehicleEditingController!
                                                          .text);
                                                  final _uploadController =
                                                      UploadController();
                                                  late String urlImage;

                                                  if (imageFromFile) {
                                                    urlImage = await _uploadController
                                                        .uploadImageVehicle(
                                                            imageFile,
                                                            1600,
                                                            900,
                                                            'XE',
                                                            widget.isAddNew ==
                                                                    true
                                                                ? _idVehicleEditingController!
                                                                    .text
                                                                : widget.vehicle
                                                                    .idVehicle);
                                                  } else if (widget.isAddNew) {
                                                    _appSnackbar.buildSnackbar(
                                                        context,
                                                        'Please choose vehicle\'s image!');
                                                    //Navigator.of(context).pop();
                                                    return;
                                                  }

                                                  if (_nameVehicleEditingController!
                                                      .text.isEmpty) {
                                                    // ignore: use_build_context_synchronously
                                                    _appSnackbar.buildSnackbar(
                                                        context,
                                                        'Please fill in vehicle\'s name field!');
                                                    return;
                                                  }

                                                  // if (_capcityVehicleEditingController!
                                                  //     .text.isEmpty) {
                                                  //   // ignore: use_build_context_synchronously
                                                  //   _appSnackbar.buildSnackbar(context,
                                                  //       'Please fill in vehicle\'s capacity field!');
                                                  //   return;
                                                  // }

                                                  Vehicle newVehicle = Vehicle(
                                                      idVehicle:
                                                          widget.isAddNew ==
                                                                  true
                                                              ? _idVehicleEditingController!
                                                                  .text
                                                              : widget.vehicle
                                                                  .idVehicle,
                                                      name:
                                                          _nameVehicleEditingController!
                                                              .text,
                                                      capacity: int.parse(
                                                          totalSeats
                                                          // _capcityVehicleEditingController!
                                                          //     .text
                                                          ),
                                                      urlImage:
                                                          widget.isAddNew ==
                                                                  true
                                                              ? urlImage
                                                              : widget.vehicle
                                                                  .urlImage,
                                                      location:
                                                          currentLocation);

                                                  final _appCircleprogressbar =
                                                      AppCircleprogressbar();
                                                  // ignore: use_build_context_synchronously
                                                  _appCircleprogressbar
                                                      .buildCirclerprogessbar(
                                                          context);

                                                  late bool isSuccessed;
                                                  isSuccessed =
                                                      await _uploadController
                                                          .updateVehicle(
                                                              newVehicle);
                                                  //       .updateVehicle(newVehicle);
                                                  // if (widget.isAddNew == false) {
                                                  //   isSuccessed = await _uploadController
                                                  //       .updateVehicle(newVehicle);
                                                  // } else {
                                                  //   isSuccessed = await _uploadController
                                                  //       .updateVehicle(newVehicle);
                                                  // }

                                                  Navigator.of(context).pop();
                                                  if (isSuccessed == true) {
                                                    Get.offAll(
                                                        ScaffoldWithNavigationRail(
                                                      selectedIndex: 1,
                                                    ));
                                                    _appSnackbar.buildSnackbar(
                                                        context,
                                                        'Successfully!');
                                                  } else {
                                                    _appSnackbar.buildSnackbar(
                                                        context, 'Update fail');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.greenAccent,
                                                    foregroundColor:
                                                        Colors.white),
                                                icon: const Icon(
                                                  Icons.save,
                                                  size: 25,
                                                ),
                                                label: const Text(
                                                  'Save',
                                                  style: TextStyle(
                                                      fontFamily: 'Roboto bold',
                                                      fontSize: 18),
                                                )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            widget.isAddNew
                                                ? const SizedBox()
                                                : ElevatedButton.icon(
                                                    onPressed: () async {
                                                      bool shouldVerify =
                                                          await _cupertinoDialog
                                                              .createCupertinoDialog(
                                                                  AppColor
                                                                      .mainColor,
                                                                  'Delete',
                                                                  'Delete this vehicle?',
                                                                  context);

                                                      if (shouldVerify) {
                                                        try {
                                                          final _appCircleprogressbar =
                                                              AppCircleprogressbar();
                                                          _appCircleprogressbar
                                                              .buildCirclerprogessbar(
                                                                  context);

                                                          final isRemove =
                                                              await _removeController
                                                                  .removeAVehicle(widget
                                                                      .vehicle
                                                                      .idVehicle);

                                                          Navigator.of(context)
                                                              .pop();

                                                          if (isRemove) {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    'Delete Successfully!');

                                                            Get.offAll(
                                                                ScaffoldWithNavigationRail(
                                                                    selectedIndex:
                                                                        1));
                                                          } else {
                                                            _appSnackbar
                                                                .buildSnackbar(
                                                                    context,
                                                                    'Delete fail! Exist active route.');
                                                          }
                                                        } catch (e) {
                                                          _appSnackbar
                                                              .buildSnackbar(
                                                                  context,
                                                                  'Delete fail! Exist active route.');
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                            foregroundColor:
                                                                Colors.white),
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                    ),
                                                    label: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto bold',
                                                          fontSize: 18),
                                                    )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                  // Expanded(
                  //   child: Container(
                  //     padding: EdgeInsets.all(20),
                  //     decoration: BoxDecoration(
                  //         border:
                  //             Border.all(width: 1, color: AppColor.mainColor),
                  //         borderRadius: BorderRadius.circular(20)),
                  //     child: Column(children: [
                  //       Container(
                  //         child: GestureDetector(
                  //             onTap: () async {
                  //               final pickedFile =
                  //                   await ImagePickerWeb.getImageAsBytes();

                  //               setState(() {
                  //                 imageFile = pickedFile!;
                  //                 imageFromFile = true;
                  //               });
                  //             },
                  //             child: imageFromFile == false
                  //                 ? Image(
                  //                     width: 800,
                  //                     // height: 500,
                  //                     image:
                  //                         NetworkImage(widget.vehicle.urlImage))
                  //                 : Image.memory(
                  //                     imageFile,
                  //                     width: 500,
                  //                     height: 300,
                  //                   )),
                  //       ),
                  //       Container(
                  //         padding: EdgeInsets.all(20),
                  //         child: Row(
                  //           children: [
                  // Expanded(
                  //   child: TextField(
                  //     controller: _nameVehicleEditingController,
                  //     decoration: InputDecoration(
                  //       hintText: 'Enter vehicle\'s name',
                  //       hintStyle:
                  //           TextStyle(color: AppColor.mainColor),
                  //       //icon: const Icon(Icons.account_circle_outlined),
                  //       label: Text(
                  //         'Name',
                  //         style:
                  //             TextStyle(color: AppColor.mainColor),
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         // Change the default border color
                  //         borderRadius: BorderRadius.circular(5),
                  //         borderSide: BorderSide(
                  //             color: AppColor.mainColor,
                  //             width: 2), // Change color and width
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //),
                  //             SizedBox(
                  //               width: 20,
                  //             ),
                  // Expanded(
                  //   child: TextField(
                  //     controller: _capcityVehicleEditingController,
                  //     //style: ,
                  //     keyboardType: TextInputType.number,
                  //     decoration: InputDecoration(
                  //       hintText: 'Enter capacity',
                  //       hintStyle:
                  //           TextStyle(color: AppColor.mainColor),
                  //       //icon: const Icon(Icons.account_circle_outlined),
                  //       label: Text(
                  //         'Capacity',
                  //         style:
                  //             TextStyle(color: AppColor.mainColor),
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         // Change the default border color
                  //         borderRadius: BorderRadius.circular(5),
                  //         borderSide: BorderSide(
                  //             color: AppColor.mainColor,
                  //             width: 2), // Change color and width
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //)
                  //           ],
                  //         ),
                  //       ),
                  //     ]),
                  //   ),
                  // ),
                  // Container(
                  //   width: 500,
                  //   padding: EdgeInsets.only(bottom: 20),
                  //   child: Column(
                  //     children: [
                  //       TextField(
                  //         controller: _nameVehicleEditingController,
                  //         decoration: InputDecoration(
                  //           //hintText: 'Enter your full name',
                  //           hintStyle: TextStyle(color: AppColor.mainColor),
                  //           //icon: const Icon(Icons.account_circle_outlined),
                  //           label: Text(
                  //             'Name',
                  //             style: TextStyle(color: AppColor.mainColor),
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             // Change the default border color
                  //             borderRadius: BorderRadius.circular(5),
                  //             borderSide: BorderSide(
                  //                 color: AppColor.mainColor,
                  //                 width: 2), // Change color and width
                  //           ),
                  //         ),
                  //       ),
                  //       //),
                  //       SizedBox(
                  //         height: 20,
                  //       ),
                  //       TextField(
                  //         controller: _capcityVehicleEditingController,
                  //         //style: ,
                  //         keyboardType: TextInputType.number,
                  //         decoration: InputDecoration(
                  //           //hintText: 'Enter your full name',
                  //           hintStyle: TextStyle(color: AppColor.mainColor),
                  //           //icon: const Icon(Icons.account_circle_outlined),
                  //           label: Text(
                  //             'Capacity',
                  //             style: TextStyle(color: AppColor.mainColor),
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             // Change the default border color
                  //             borderRadius: BorderRadius.circular(5),
                  //             borderSide: BorderSide(
                  //                 color: AppColor.mainColor,
                  //                 width: 2), // Change color and width
                  //           ),
                  //         ),
                  //       ),
                  //       //)
                  //     ],
                  //   ),
                  // )
                ],
              ),
            )));
  }
}
