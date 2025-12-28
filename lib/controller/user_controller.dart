import 'package:admin_app/controller/state_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserController{
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  final stateController = Get.put(StateController());


}