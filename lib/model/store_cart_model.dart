

import 'package:admin_app/model/user_model.dart';

class StoreCartModel {
  UserModel? userModel;
  int? totalAmount = 0;
  int? totalItem = 0;
  String? confirm;
  int? deliveryCharge=0;
  String? dateTime;
  List<CartItem>? cartItem;

  StoreCartModel(
      { this.totalAmount,  this.totalItem,  this.deliveryCharge, this.cartItem,this.userModel,this.dateTime,this.confirm});

  StoreCartModel.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalItem = json['totalItem'];
    dateTime = json['dateTime'];
    confirm = json['confrim'];
    if(json['userModel']!=null){
      userModel = UserModel.fromJson(json['userModel']);
    }
    deliveryCharge = json['deliveryCharge'];
    if (json['cartItem'] != null) {
      cartItem = <CartItem>[];
      json['cartItem'].forEach((v) {
        cartItem!.add(new CartItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalAmount'] = this.totalAmount;
    data['totalItem'] = this.totalItem;
    data['confrim'] = this.confirm;
    data['dateTime'] = this.dateTime;
    data['userModel'] = this.userModel!.toJson();
    data['deliveryCharge'] = this.deliveryCharge;
    if (this.cartItem != null) {
      data['cartItem'] = this.cartItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItem {
  String? itemName;
  String? image;
  String? itemGrade;
  String? itemPrice;
  String? itemQuantity;
  String? itemCount;
  String? itemTotal;

  CartItem(
      {this.itemName,
        this.itemGrade,
        this.image,
        this.itemPrice,
        this.itemQuantity,
        this.itemCount,
        this.itemTotal});

  CartItem.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemGrade = json['itemGrade'];
    itemPrice = json['itemPrice'];
    itemQuantity = json['itemQuantity'];
    itemCount = json['itemCount'];
    image = json['image'];
    itemTotal = json['itemTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemGrade'] = this.itemGrade;
    data['itemPrice'] = this.itemPrice;
    data['itemQuantity'] = this.itemQuantity;
    data['itemCount'] = this.itemCount;
    data['image'] = this.image;
    data['itemTotal'] = this.itemTotal;
    return data;
  }
}
