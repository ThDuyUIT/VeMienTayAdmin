import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/mycupertinodialog.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/remove_controller.dart';

import 'package:booking_transition_admin/feature/controller/upload_controller.dart';
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
  bool imageFromFile = false;
  late Uint8List imageFile;
  final _appSnackbar = AppSnackbar();

  final _cupertinoDialog = MyCupertinoDialog();
  final _removeController = RemoveController();

  @override
  void initState() {
    if (widget.isAddNew == false) {
      _idVehicleEditingController =
          TextEditingController(text: widget.vehicle.idVehicle);
      _nameVehicleEditingController =
          TextEditingController(text: widget.vehicle.name);
      _capcityVehicleEditingController =
          TextEditingController(text: widget.vehicle.capacity);
    } else {
      _nameVehicleEditingController = TextEditingController();
      _capcityVehicleEditingController = TextEditingController();
      _idVehicleEditingController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                            widget.vehicle.urlImage))),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
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
                                  child: TextField(
                                    controller: _nameVehicleEditingController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter vehicle\'s name',
                                      hintStyle:
                                          TextStyle(color: AppColor.mainColor),
                                      //icon: const Icon(Icons.account_circle_outlined),
                                      label: Text(
                                        'Name',
                                        style: TextStyle(
                                            color: AppColor.mainColor),
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
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        _capcityVehicleEditingController,
                                    //style: ,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'Enter capacity',
                                      hintStyle:
                                          TextStyle(color: AppColor.mainColor),
                                      //icon: const Icon(Icons.account_circle_outlined),
                                      label: Text(
                                        'Capacity',
                                        style: TextStyle(
                                            color: AppColor.mainColor),
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
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    print(_idVehicleEditingController!.text);
                                    final _uploadController =
                                        UploadController();
                                    late String urlImage;
                                    final _appCircleprogressbar =
                                        AppCircleprogressbar();
                                    // ignore: use_build_context_synchronously
                                    _appCircleprogressbar
                                        .buildCirclerprogessbar(context);
                                    if (imageFromFile) {
                                      urlImage =
                                          await _uploadController.uploadImage(
                                              imageFile,
                                              // 1600,
                                              // 900,
                                              'XE',
                                              widget.isAddNew == true
                                                  ? _idVehicleEditingController!
                                                      .text
                                                  : widget.vehicle.idVehicle);
                                    }

                                    if (_nameVehicleEditingController!
                                        .text.isEmpty) {
                                      // ignore: use_build_context_synchronously
                                      _appSnackbar.buildSnackbar(context,
                                          'Please fill in vehicle\'s name field!');
                                      return;
                                    }

                                    if (_capcityVehicleEditingController!
                                        .text.isEmpty) {
                                      // ignore: use_build_context_synchronously
                                      _appSnackbar.buildSnackbar(context,
                                          'Please fill in vehicle\'s capacity field!');
                                      return;
                                    }

                                    Vehicle newVehicle = Vehicle(
                                        idVehicle: widget.isAddNew == true
                                            ? _idVehicleEditingController!.text
                                            : widget.vehicle.idVehicle,
                                        name:
                                            _nameVehicleEditingController!.text,
                                        capacity: int.parse(
                                            _capcityVehicleEditingController!
                                                .text),
                                        urlImage: widget.isAddNew == true
                                            ? urlImage
                                            : widget.vehicle.urlImage);

                                    late bool isSuccessed;
                                    isSuccessed = await _uploadController
                                        .updateVehicle(newVehicle);
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
                                      Get.offAll(ScaffoldWithNavigationRail(
                                        selectedIndex: 1,
                                      ));
                                      _appSnackbar.buildSnackbar(
                                          context, 'Successfully!');
                                    } else {
                                      _appSnackbar.buildSnackbar(
                                          context, 'Update fail');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent,
                                      foregroundColor: Colors.white),
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
                                                    AppColor.mainColor,
                                                    'Delete',
                                                    'Delete this city?',
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
                                                        .vehicle.idVehicle);

                                            Navigator.of(context).pop();

                                            if (isRemove) {
                                              _appSnackbar.buildSnackbar(
                                                  context,
                                                  'Delete Successfully!');

                                              Get.offAll(
                                                  ScaffoldWithNavigationRail(
                                                      selectedIndex: 1));
                                            } else {
                                              _appSnackbar.buildSnackbar(
                                                  context,
                                                  'Delete fail! Exist active route.');
                                            }
                                          } catch (e) {
                                            _appSnackbar.buildSnackbar(context,
                                                'Delete fail! Exist active route.');
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white),
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 25,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            fontFamily: 'Roboto bold',
                                            fontSize: 18),
                                      )),
                            ],
                          ),
                        )
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
