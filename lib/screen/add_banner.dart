import 'dart:io';

import 'package:admin_app/model/banner_model.dart';
import 'package:admin_app/model/category_model.dart' as categoryModel;
import 'package:admin_app/model/product_model.dart';
import 'package:admin_app/screen/all_product_list.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/my_button.dart';
import 'package:admin_app/utility/my_text_field.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/user_controller.dart';
import '../firebase/firebase_realtime.dart';
import '../firebase/firebase_storage.dart';
import '../model/category_model.dart';

class AddBanner extends StatefulWidget {
  bool? filled;
  BannerModel? bannerModel;

  AddBanner(
      {Key? key,
        this.filled,this.bannerModel})
      : super(key: key);

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  TextEditingController productNameController = TextEditingController();

  TextEditingController productGrade = TextEditingController();

  TextEditingController description = TextEditingController();

  ProductModel productModel = ProductModel();

  File? image;
  File? image2;

  bool imageFromUrl = false;
  bool imageFromUrl2 = false;

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 30);
      if (image == null) return;
      final imageTemp = File(image.path);
      imageFromUrl = false;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  List<ProductDetailsModel> productListAll = [];
  List<ProductDetailsModel> selectedProduct = [];

  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    categoryList = UserController().stateController.categoryList.value
    as List<CategoryModel>;
    productListAll = [];
    for (int i = 0; i < categoryList.length; i++) {
      for (int j = 0; j < categoryList[i].productList!.length; j++) {
        productListAll.add(categoryList[i].productList![j]);
      }
      // TODO: implement initState
    }
    if(widget.filled==true){
      imageFromUrl = true;
      productNameController.text = widget.bannerModel?.name??"";
      selectedProduct = widget.bannerModel?.productList??[];
    }

    super.initState();
  }

  final _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPadding(
        child: SingleChildScrollView(
          child: Form(
            key: _globalKey,
            child: Column(
              children: [
                commonHeader("Banner Details"),
                InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageFromUrl
                          ? myImage(
                          source:
                          widget.bannerModel?.image ??
                              "",
                          fromUrl: true)
                          : image?.path == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("Add"),
                        ],
                      )
                          : myImage(
                          source: image?.path ?? "", fromUrl: false),
                      height: 150,
                      width: double.infinity,
                    )),
                smallSpace(),


                MyTextFieldWithPreFix(
                    textEditController: productNameController,
                    filled: widget.filled == true ? true : false,
                    textInputType: TextInputType.name,
                    label: "Banner Title",
                    validate: true),
                smallSpace(),
                ListView.builder(
                    itemCount: selectedProduct.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,i){
                      return  Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: myShadow
                        ),
                        child:Row(
                          children: [
                            SizedBox(
                                width: 80,
                                height: 80,
                                child: myImage(source:selectedProduct[i].productImage??"" , fromUrl: true)),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(selectedProduct[i].productName??"",style: CommonDecoration.listItem,),
                                Text("Grade : ${selectedProduct[i].productGrade}"??"",style: CommonDecoration.listItem,),
                              ],
                            )
                          ],
                        ),
                      );
                    }),
               smallSpace(),
               InkWell(
                 onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AllProductList(productListAll: productListAll))).then((value) {
                    selectedProduct = value;
                    setState(() {

                    });
                  });
                 },
                 child: InkWell(

                     child: MyRoundButton(text: "Add Product", bgColor: Colors.blue)),
               ),
               smallSpace(),
                InkWell(
                    onTap: () {


                      if (image?.path == null && imageFromUrl == false) {
                        showMessage(msg: "Please Select Image");
                      }

                      if (_globalKey.currentState!.validate()) {
                        if(imageFromUrl){
                          widget.bannerModel!.productList = selectedProduct;
                          FirebaseRealTimeStorage().addBanner(bannerModel: widget.bannerModel!);
                        }

                        FirebaseStoreFile()
                            .storeFile(
                            file: image!,
                            path:
                            "${"Banner"}/${productNameController.value.text}")
                            .then((value) {
                              BannerModel bannerModel = BannerModel(image: value,name: productNameController.value.text,productList: selectedProduct);
                                  FirebaseRealTimeStorage().addBanner(bannerModel: bannerModel);
                          });

                      }
                    },
                    child:
                    MyRoundButton(text: "Add Banner", bgColor: Colors.green)),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
