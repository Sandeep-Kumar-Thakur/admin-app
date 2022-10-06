import 'package:admin_app/controller/user_controller.dart';
import 'package:flutter/material.dart';

goTo({required Widget className}){
  Navigator.push(UserController.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>className));
}