import 'dart:async';
import 'dart:convert';

import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/notification_service.dart';
import 'package:admin_app/controller/user_controller.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/screen/add_banner.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/my_button.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService().setupInteractedMessage();
  runApp(const MyApp());
  // runZonedGuarded(()async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
  //   runApp(const MyApp());
  // }, (error, stack) {
  //   print(error);
  //   showMessage(msg: error.toString()=="type 'Null' is not a subtype of type 'Map<String, dynamic>'"?"List is Empty":"$error");
  // });

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: UserController.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    FirebaseRealTimeStorage().adminToken();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Admin Panel"),
      ),
      body: myPadding(
        child: Column(
          children: [
            smallSpace(),
              InkWell(
                  onTap: (){
                    FirebaseRealTimeStorage().getAllCategoryList();
                  },
                  child: MyRoundButton(text: "Category List", bgColor: Colors.blue)),
            smallSpace(),
            InkWell(
                onTap: (){
                  FirebaseRealTimeStorage().userDetails();
                },
                child: MyRoundButton(text: "User List", bgColor: Colors.blue)),
            smallSpace(),
            InkWell(
                onTap: (){
                  FirebaseRealTimeStorage().getOrder();
                },
                child: MyRoundButton(text: "Order Details", bgColor: Colors.blue)),
            smallSpace(),

            InkWell(
                onTap: (){
                  FirebaseRealTimeStorage().getAllBanner();
                // FirebaseRealTimeStorage().getAllCategoryList(navigate: false).then((value) {
                //   goTo(className: AddBanner());
                // });
                },
                child: MyRoundButton(text: "Banner", bgColor: Colors.blue)),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
