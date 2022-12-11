import 'dart:async';
import 'dart:convert';

import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/generated/assets.dart';
import 'package:admin_app/notification_service.dart';
import 'package:admin_app/controller/user_controller.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/screen/add_banner.dart';
import 'package:admin_app/screen/hot_items_screen.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/my_button.dart';
import 'package:admin_app/utility/my_text_field.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService().setupInteractedMessage();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
      home:  AdminPassword(),
    );
  }
}

class AdminPassword extends StatelessWidget {
    AdminPassword({Key? key}) : super(key: key);
 final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(60)
              ),
                child:Icon(Icons.person,size: 80,color: Colors.white,)),
            SizedBox(height: 10,),
            Text("BALA JI ADMIN",style: TextStyle(
              fontSize: 20
            ),),
            SizedBox(height: 20,),
            MyTextFieldWithPreFix(textEditController: password, filled: false, textInputType: TextInputType.number, label: "Admin PIN", validate: true),
           largeSpace(),
            InkWell(
                onTap: (){
                  FirebaseRealTimeStorage().passwordCheck().then((value) {
                    if(value==password.value.text){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "d")));
                    }else{
                      showMessage(msg: "Wrong Password");
                    }
                  });
                },
                child: MyRoundButton(text: "Login", bgColor: Colors.blue))
          ],
        ),
      ),
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

  List title = [
    "Order List",
    "Category List",
    "Banner Details",
    "Hot Items List",
    "User List"
  ];

  List myAssets=[
    Assets.imagesOrder,
    Assets.imagesMenu,
    Assets.imagesAdvertisement,
    Assets.imagesHotDeal,
    Assets.imagesContactList
  ];


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
              GridView.builder(
                shrinkWrap: true,
                itemCount: title.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5
              ),
                itemBuilder: (context,i)=>InkWell(
                  onTap: (){
                    switch(i){
                      case 0:
                        FirebaseRealTimeStorage().getOrder();
                        break;
                      case 1:
                        FirebaseRealTimeStorage().getAllCategoryList();
                        break;
                      case 2:
                        FirebaseRealTimeStorage().getAllBanner();
                        break;
                      case 3:
                        FirebaseRealTimeStorage().getHotItems().then((selected) {
                          FirebaseRealTimeStorage().getAllCategoryList(navigate: false).then((value){
                            goTo(className: HotItemsScreen(bannerModel: selected,));
                          });
                        });

                        break;
                      case 4:
                        FirebaseRealTimeStorage().userDetails();
                        break;
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(title[i],style: TextStyle(color:Colors.white,fontSize: 24),),
                      ),
                      Positioned(
                          bottom: 5,
                          right: 5,
                          child: Image.asset(myAssets[i],height: 60,))
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
