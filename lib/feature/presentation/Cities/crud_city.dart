import 'dart:typed_data';

import 'package:booking_transition_admin/basic_component/circleprogressbar.dart';
import 'package:booking_transition_admin/basic_component/mycupertinodialog.dart';
import 'package:booking_transition_admin/basic_component/snackbar.dart';
import 'package:booking_transition_admin/feature/controller/remove_controller.dart';
import 'package:booking_transition_admin/feature/controller/trigger_controller.dart';
import 'package:booking_transition_admin/feature/controller/upload_controller.dart';
import 'package:booking_transition_admin/feature/model/city.dart';
import 'package:booking_transition_admin/feature/presentation/Cities/item_city_data.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker_web/image_picker_web.dart';

class CrudCity extends StatefulWidget {
  bool isAddNew = false;

  late CityRowData city;

  CrudCity({super.key});
  CrudCity.create({super.key, required this.isAddNew});
  CrudCity.update({super.key, required this.city});
  @override
  State<StatefulWidget> createState() {
    return StateCrudCity();
  }
}

class StateCrudCity extends State<CrudCity> {
  static String idCity = '';
  TextEditingController? _idCityEditingController;
  TextEditingController? _nameCityEditingController;
  bool imageFromFile = false;
  static late bool isActive;
  late Uint8List imageFile;
  final _appSnackbar = AppSnackbar();
  static TriggerController triggerController = TriggerController();

  final _cupertinoDialog = MyCupertinoDialog();
  final _removeController = RemoveController();
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    if (widget.isAddNew == false) {
      _idCityEditingController =
          TextEditingController(text: widget.city.idCity);
      _nameCityEditingController =
          TextEditingController(text: widget.city.nameCity);
    } else {
      _nameCityEditingController = TextEditingController();
      _idCityEditingController = TextEditingController();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.city.urlImage);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        foregroundColor: AppColor.mainColor,
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
                        'Add new city - $idCity',
                        style: TextStyle(
                            fontFamily: 'Roboto bold',
                            color: AppColor.mainColor,
                            fontSize: 25),
                      ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      // SizedBox(
                      //   width: 300,
                      //   //flex: 1,
                      //   child: TextField(
                      //     controller: _idCityEditingController,
                      //     decoration: InputDecoration(
                      //       hintText: 'Enter city\'s ID',
                      //       hintStyle: TextStyle(color: AppColor.mainColor),
                      //       //icon: const Icon(Icons.account_circle_outlined),
                      //       label: Text(
                      //         'ID',
                      //         style: TextStyle(color: AppColor.mainColor),
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
                      //Expanded(flex: 4, child: SizedBox())
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Edit city - ID: ${widget.city.idCity}',
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
                              : const Icon(
                                  Icons.place_rounded,
                                  size: 50,
                                  color: Colors.redAccent,
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
                                      '${widget.city.urlImage}&timestamp=$timestamp'))),
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
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                              flex: 1,
                              child: widget.isAddNew || !isActive
                                  ? TextField(
                                      controller: _nameCityEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter city\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        label: Text(
                                          'Name',
                                          style: TextStyle(
                                              color: AppColor.mainColor),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    )
                                  : TextField(
                                      readOnly: true,
                                      controller: _nameCityEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter city\'s name',
                                        hintStyle: TextStyle(
                                            color: AppColor.mainColor),
                                        //icon: const Icon(Icons.account_circle_outlined),
                                        label: Text(
                                          'Name',
                                          style: TextStyle(
                                              color: AppColor.mainColor),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          // Change the default border color
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: AppColor.mainColor,
                                              width:
                                                  2), // Change color and width
                                        ),
                                      ),
                                    )),
                          Expanded(flex: 1, child: SizedBox()),
                          // const SizedBox(
                          //   width: 20,
                          // ),
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
                              final _uploadController = UploadController();
                              // final _addNewController = AddNewController();
                              late String urlImage;
                              final _appCircleprogressbar =
                                  AppCircleprogressbar();
                              _appCircleprogressbar
                                  .buildCirclerprogessbar(context);
                              if (imageFromFile) {
                                urlImage =
                                    await _uploadController.uploadImageCity(
                                        imageFile,
                                        // 150,
                                        // 300,
                                        'DIADIEM',
                                        widget.isAddNew == true
                                            ? _idCityEditingController!.text
                                            : widget.city.idCity);
                              } else if (widget.isAddNew) {
                                _appSnackbar.buildSnackbar(
                                    context, 'Please choose city\'s image!');
                                Navigator.of(context).pop();
                                return;
                              }

                              if (_nameCityEditingController!.text.isEmpty) {
                                // ignore: use_build_context_synchronously
                                _appSnackbar.buildSnackbar(context,
                                    'Please fill in city\'s name field!');
                                return;
                              }

                              // if (_idCityEditingController!.text.isEmpty) {
                              //   // ignore: use_build_context_synchronously
                              //   _appSnackbar.buildSnackbar(context,
                              //       'Please fill in city\'s ID field!');
                              //   return;
                              // }
                              // try {} catch (e) {
                              //   print('can not create new vehicle');
                              // }

                              City newCity = City(
                                  idCity: widget.isAddNew == true
                                      //? _idCityEditingController!.text
                                      ? idCity
                                      : widget.city.idCity,
                                  nameCity: _nameCityEditingController!.text,
                                  urlImage: widget.isAddNew == true
                                      ? urlImage
                                      : widget.city.urlImage);
                              late bool isSuccessed;

                              // if (widget.isAddNew == false) {
                              //   isSuccessed =
                              //       await _uploadController.updateCity(newCity);
                              // } else {
                              //   isSuccessed =
                              //       await _uploadController.updateCity(newCity);
                              // }

                              isSuccessed =
                                  await _uploadController.updateCity(newCity);

                              Navigator.of(context).pop();
                              if (isSuccessed == true) {
                                idCity = '';
                                Get.offAll(ScaffoldWithNavigationRail(
                                  selectedIndex: 2,
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
                                  fontFamily: 'Roboto bold', fontSize: 18),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        widget.isAddNew
                            ? const SizedBox()
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  bool shouldVerify = await _cupertinoDialog
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
                                          .buildCirclerprogessbar(context);

                                      final isRemove = await _removeController
                                          .removeACity(widget.city.idCity);

                                      Navigator.of(context).pop();

                                      if (isRemove) {
                                        _appSnackbar.buildSnackbar(
                                            context, 'Delete Successfully!');

                                        Get.offAll(ScaffoldWithNavigationRail(
                                            selectedIndex: 2));
                                      } else {
                                        _appSnackbar.buildSnackbar(context,
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
                                      fontFamily: 'Roboto bold', fontSize: 18),
                                )),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}
