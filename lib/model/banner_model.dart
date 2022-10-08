import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/product_model.dart';

class BannerModel {
  String? name;
  String? image;
  List<ProductDetailsModel>? productList;

  BannerModel({this.name, this.image,this.productList});

  BannerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    if(json['productList']!=null){
      productList = [];
      List temp = json['productList'];
      for(int i=0;i<temp.length;i++){
        ProductDetailsModel productModel = ProductDetailsModel.fromJson(temp[i]);
        productList!.add(productModel);
      }
    }else{
      productList = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['productList'] = this.productList!.map((e) => e.toJson()).toList();
    return data;
  }
}
