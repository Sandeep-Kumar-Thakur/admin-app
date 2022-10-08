import 'package:admin_app/model/product_model.dart';

class CategoryModel {
   String? id;
   String? name;
   String? image;
   var tempList;
   List<ProductDetailsModel>? productList=[];

   CategoryModel({this.id, this.name, this.image, this.productList,this.tempList});

   CategoryModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      image = json['image'];
      tempList = json['categoryItems'];
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['name'] = this.name;
      data['image'] = this.image;
      data['categoryItems'] = this.tempList;
      return data;
   }
}

class ProductDetailsModel {
   String? productImage;
   String? productImage2;
   List<QuantityAndPrice>? quantityAndPrice;
   String? productGrade;
   bool? selected;
   String? productDescription;
   String? productName;

   ProductDetailsModel(
       {this.productImage,
          this.quantityAndPrice,
          this.productImage2,
          this.productGrade,
          this.productDescription,
          this.productName});

   ProductDetailsModel.fromJson(Map<String, dynamic> json) {
      productImage = json['productImage'];
      productImage2 = json['productImage2'];
      if (json['quantityAndPrice'] != null) {
         quantityAndPrice = <QuantityAndPrice>[];
         json['quantityAndPrice'].forEach((v) {
            quantityAndPrice!.add(new QuantityAndPrice.fromJson(v));
         });
      }
      productGrade = json['productGrade'];
      productDescription = json['productDescription'];
      productName = json['productName'];
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['productImage'] = this.productImage;
      data['productImage2'] = this.productImage2;
      if (this.quantityAndPrice != null) {
         data['quantityAndPrice'] =
             this.quantityAndPrice!.map((v) => v.toJson()).toList();
      }
      data['productGrade'] = this.productGrade;
      data['productDescription'] = this.productDescription;
      data['productName'] = this.productName;
      return data;
   }
}

class QuantityAndPrice {
   String? quantity;
   String? price;

   QuantityAndPrice({this.quantity, this.price});

   QuantityAndPrice.fromJson(Map<String, dynamic> json) {
      quantity = json['quantity'];
      price = json['price'];
   }

   Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['quantity'] = this.quantity;
      data['price'] = this.price;
      return data;
   }
}
