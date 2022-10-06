import 'dart:developer';
import 'dart:io';

import 'package:admin_app/controller/user_controller.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget myPadding({required Widget child}) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: child,
    ),
  );
}

myLog({required String label, required String value}) {
  log("$label------$value");
}


showMessage({required String msg}){
  Get.showSnackbar(GetSnackBar(
    margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    borderRadius: 10,
    title: "Bala Ji",
    icon: Icon(Icons.check),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 3),
    message: msg,
  ));
}

commonHeader(String title){
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Align(
        alignment: Alignment.center,
        child: Text(title,style: CommonDecoration.headerDecoration,)),
  );
}

List<BoxShadow> myShadow =  [
  BoxShadow(
    color: Colors.blue.withOpacity(0.2),
    spreadRadius: 2.0,
    blurRadius: 2.0,
    offset: Offset(1.0, 4.0), // changes position of shadow
  ),
];

Widget myImage({required String source, required bool fromUrl}){
  return fromUrl?Image.network(source,fit: BoxFit.cover,):Image.file(File(source),fit: BoxFit.cover);
}

showLoader() {
  showDialog(
      context: UserController.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          ));
}

hideLoader(){
  Navigator.pop(UserController.navigatorKey.currentContext!);
}

smallSpace() {
  return SizedBox(
    height: 10,
  );
}

mediumSpcae() {
  return SizedBox(
    height: 20,
  );
}

largeSpace() {
  return SizedBox(
    height: 30,
  );
}
