import 'dart:convert';
import 'dart:developer';

import 'package:admin_app/constants/key_contants.dart';
import 'package:admin_app/controller/state_controller.dart';
import 'package:admin_app/model/banner_model.dart';
import 'package:http/http.dart'as http;

import 'package:admin_app/controller/user_controller.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/product_model.dart';
import 'package:admin_app/model/store_cart_model.dart';
import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/screen/order_details.dart';
import 'package:admin_app/screen/user_list.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/banner_list.dart';
import '../screen/category_list_screen.dart';

class FirebaseRealTimeStorage {
  final fireBaseRealTime = FirebaseDatabase.instance;

  ///--------deleteBanner---------

  Future deleteBanner({required String key})async{
    showLoader();
    fireBaseRealTime.ref(KeyConstants.banner).child(key).remove();
    hideLoader();
    hideLoader();
  }

  ///-------------getBanner-------------------

  Future getAllBanner()async{
    showLoader();
    List<BannerModel> bannerList = [];
   var data = await fireBaseRealTime.ref(KeyConstants.banner).get();
   if(data.value==null){
     hideLoader();
     goTo(className: BannerList(bannerList: [],));
     return;
   }
   Map tempData = jsonDecode(jsonEncode(data.value));
   tempData.forEach((key, value) {
     BannerModel bannerModel = BannerModel.fromJson(value);
     bannerList.add(bannerModel);
   });
   hideLoader();
   goTo(className: BannerList(bannerList: bannerList,));
  }

///----------------------add Banner-------------------

  Future addBanner({required BannerModel bannerModel})async{
    showLoader();
    fireBaseRealTime.ref(KeyConstants.banner).child(bannerModel.name??"").update(bannerModel.toJson()).then((value) {
      hideLoader();
      hideLoader();
      hideLoader();
    }).onError((error, stackTrace) {
      hideLoader();
      showMessage(msg: "Something went wrong");
    });
  }


  ///--------------change order status-----------

  Future changeOrderStatus({required StoreCartModel storeCartModel})async{
    showLoader();
    fireBaseRealTime.ref(KeyConstants.orderReceived).child(storeCartModel.userModel?.uid??"").child(DateTime.parse(storeCartModel.dateTime ?? "")
        .millisecondsSinceEpoch
        .toString()).update(storeCartModel.toJson()).then((value)async {

          ///----------------notification-------------------
      var data =await fireBaseRealTime
          .ref(KeyConstants.userDetails).child(storeCartModel.userModel?.uid??"").get();
      UserModel userModel = UserModel.fromJson(jsonDecode(jsonEncode(data.value)));
      Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
      var header = {
        "Content-Type":"application/json",
        "Authorization":"key=AAAAWCdMLDs:APA91bHYSO-xZQMBS4d9aRQCgpLHd6QI6ebqr7AQqLDG338QniW_Uol_TL0WqjO5QdyQVOfDI9LGpFn1vTeWu4C5iO9qIOPGfnjsLnEONjEYfsAh_VNBZUIiBGUnCMhjF3VgiXlsrVDd"
      };
      
      var body = {
        "to": "${userModel.fcmToken}",
        "notification": {
          "title": "${storeCartModel.confirm}",
          "body": "Items : ${storeCartModel.cartItem!.length.toString()}",
          "mutable_content": false,
          "sound": "Tri-tone"
        },

        "data": {
          "url": "<url of media image>",
          "dl": "<deeplink action on tap of notification>",
          "notification_type":"12"
        }
      };
      http.post(uri,headers: header,body: jsonEncode(body));

      ///--------------------


      hideLoader();
      hideLoader();
      hideLoader();
    });
  }

  ///------------order details------------------

  Future getOrder()async{
    showLoader();
    List<StoreCartModel> orderList = [];
    var data =await fireBaseRealTime
        .ref(KeyConstants.orderReceived).get();
    Map tempData = jsonDecode(jsonEncode(data.value));
    myLog(label: "data", value: tempData.toString());
    tempData.forEach((key, value) {
      Map tempData2 = value;
      tempData2.forEach((key, v) {
        StoreCartModel tempModel = StoreCartModel.fromJson(v);
        orderList.add(tempModel);
      });

    });
    orderList.sort((a,b){
      return b.dateTime!.compareTo(a.dateTime!);
    });
    hideLoader();
    goTo(className: OrderDetails(storeList: orderList));
  }

  ///---------user details -------------------------------------

  Future userDetails() async {
    showLoader();
    List<UserModel> userList = [];
    var data =await fireBaseRealTime
        .ref(KeyConstants.userDetails).get();
    Map tempData = jsonDecode(jsonEncode(data.value));
    myLog(label: "data", value: tempData.toString());
    tempData.forEach((key, value) {
      UserModel tempModel = UserModel.fromJson(value);
      userList.add(tempModel);
    });
    hideLoader();
    goTo(className:UserList(userList: userList) );

  }


  ///-----------------admin token-------------------

  Future adminToken()async{
   String? token =await FirebaseMessaging.instance.getToken();
   myLog(label: "token", value: token.toString());
    fireBaseRealTime.ref(KeyConstants.adminToken).set({"token": token});
  }

  ///-------------------category--------------------------------------------------------
  Future addCategory(CategoryModel categoryModel) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryModel.name ?? "")
        .update(categoryModel.toJson())
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
      showMessage(msg: "${categoryModel.name} Added into Category");
    }).onError((error, stackTrace) {
      hideLoader();
      showMessage(msg: error.toString());
    });
  }

  Future getAllCategoryList({bool? navigate}) async {
    showLoader();
    List<CategoryModel> categoryList = [];
    final category = FirebaseDatabase.instance.ref(KeyConstants.category);
    var temp = await category.get();
    hideLoader();
    try {
      Map<String, dynamic> data = jsonDecode(jsonEncode(temp.value));
      data.forEach((key, value) {
        CategoryModel categoryModel = CategoryModel.fromJson(value);

        if (categoryModel.tempList != null) {
          Map<String, dynamic> tempList = jsonDecode(jsonEncode(categoryModel.tempList));
          tempList.forEach((key, value) {
            log(jsonEncode(value));
            ProductDetailsModel productDetailsModel = ProductDetailsModel.fromJson(value);
            categoryModel.productList!.add(productDetailsModel);
          });
        }
        categoryList.add(categoryModel);
      });
      log(categoryList.toList().toString());
      categoryList.sort((a, b) {
        return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
      });

      UserController().stateController.categoryList.value = categoryList;

      if (navigate != false) {
        goTo(className: CategoryList());
      }
    } catch (e) {
      UserController().stateController.categoryList.value = [];
      if (navigate != false) {
        goTo(className: CategoryList());
      }
    }
  }

  Future deleteCategory({required String id}) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(id)
        .remove()
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
    });
  }

  ///-------------------product------------------------------

  Future addProduct(
      {required ProductModel productModel,
      required String categoryName}) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryName)
        .child(KeyConstants.categoryItems)
        .child(productModel.productName.toString()+productModel.productGrade.toString())
        .update(productModel.toJson())
        .then((value) {
      hideLoader();
      showMessage(msg: "Add item into $categoryName");
      getAllCategoryList(navigate: false);
    }).onError((error, stackTrace) {
      hideLoader();
      showMessage(msg: error.toString());
    });;
  }

  Future deleteProduct({required String categoryId,required String productId})async{
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryId).child(KeyConstants.categoryItems).child(productId)
        .remove()
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
    });
  }
}
