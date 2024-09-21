import 'dart:io';

import 'package:admin_app/constants/key_contants.dart';
import 'package:admin_app/model/category_model.dart' as categoryModel;
import 'package:admin_app/model/product_model.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/my_button.dart';
import 'package:admin_app/utility/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../firebase/firebase_realtime.dart';
import '../firebase/firebase_storage.dart';

class AddProductScreen extends StatefulWidget {
  String categoryName;
  bool? filled;
  categoryModel.ProductDetailsModel? productDetailsModel;

  AddProductScreen(
      {Key? key,
      required this.categoryName,
      this.filled,
      this.productDetailsModel})
      : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
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
          .getImage(source: ImageSource.gallery, imageQuality: KeyConstants.imageQuality);
      if (image == null) return;
      final imageTemp = File(image.path);
      imageFromUrl = false;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImage2() async {
    try {
      final image = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: KeyConstants.imageQuality);
      if (image == null) return;
      final imageTemp = File(image.path);
      imageFromUrl2 = false;
      setState(() => this.image2 = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    productModel.quantityAndPrice = [QuantityAndPrice()];

    if (widget.filled == true) {
      imageFromUrl = true;
      imageFromUrl2 = true;
      productModel.quantityAndPrice = [];
      productNameController.text =
          widget.productDetailsModel?.productName ?? "";
      description.text = widget.productDetailsModel?.productDescription ?? "";
      productGrade.text = widget.productDetailsModel?.productGrade ?? "";
      for (int i = 0;
          i < widget.productDetailsModel!.quantityAndPrice!.length;
          i++) {
        productModel.quantityAndPrice!.add(QuantityAndPrice(
            quantity: widget.productDetailsModel!.quantityAndPrice![i].quantity,
            price: widget.productDetailsModel!.quantityAndPrice![i].price));
      }
    }
    // TODO: implement initState
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
                commonHeader("${widget.categoryName} Product Details"),
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
                                  widget.productDetailsModel?.productImage ??
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
                InkWell(
                    onTap: () {
                      pickImage2();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: imageFromUrl2
                          ? myImage(
                              source:
                                  widget.productDetailsModel?.productImage2 ??
                                      "",
                              fromUrl: true)
                          : image2?.path == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    Text("Add"),
                                  ],
                                )
                              : myImage(
                                  source: image2?.path ?? "", fromUrl: false),
                      height: 150,
                      width: double.infinity,
                    )),
                smallSpace(),
                MyTextFieldWithPreFix(
                    textEditController: productNameController,
                    filled: widget.filled == true ? true : false,
                    textInputType: TextInputType.name,
                    label: "Product Name",
                    validate: true),
                smallSpace(),
                MyTextFieldWithPreFix(
                    textEditController: description,
                    filled: false,
                    textInputType: TextInputType.name,
                    label: "Product description",
                    validate: true),
                smallSpace(),
                MyTextFieldWithPreFix(
                    textEditController: productGrade,
                    filled:  widget.filled == true ? true : false,
                    textInputType: TextInputType.name,
                    label: "Product Grade(Optional)",
                    validate: false),
                smallSpace(),
                slapList(),
                largeSpace(),
                InkWell(
                    onTap: () {
                      if (productModel.quantityAndPrice!.last.price == null ||
                          productModel.quantityAndPrice!.last.quantity ==
                              null) {
                        showMessage(msg: "Please delete fill all empty field");
                        return;
                      }

                      if (image?.path == null && imageFromUrl == false) {
                        showMessage(msg: "Please Select Image");
                      }

                      if (_globalKey.currentState!.validate()) {
                        ///---------------------------------both from url-------------------------------------
                        if (imageFromUrl && imageFromUrl2) {
                          productModel.productName =
                              productNameController.value.text;
                          productModel.productDescription =
                              description.value.text;
                          productModel.productGrade = productGrade.value.text;
                          productModel.productImage =
                              widget.productDetailsModel?.productImage ?? "";
                          FirebaseRealTimeStorage()
                              .addProduct(
                                  productModel: productModel,
                                  categoryName: widget.categoryName)
                              .then((value) {
                            image = null;
                            setState(() {});
                            Get.back();
                          });
                          return;
                        }

                        ///---------------------------------------------------------------------------------------------------------------------------------

                        if (imageFromUrl && !imageFromUrl2) {

                            FirebaseStoreFile()
                                .storeFile(
                                    file: image2!,
                                    path:
                                        "${widget.categoryName}/${productNameController.value.text + productModel.productGrade.toString()}-2")
                                .then((value2) {
                              productModel.productName =
                                  productNameController.value.text;
                              productModel.productDescription =
                                  description.value.text;
                              productModel.productGrade =
                                  productGrade.value.text;
                              productModel.productImage2 = value2;
                              productModel.productImage =
                                  widget.productDetailsModel?.productImage ?? "";
                              FirebaseRealTimeStorage()
                                  .addProduct(
                                      productModel: productModel,
                                      categoryName: widget.categoryName)
                                  .then((value) {
                                image = null;
                                setState(() {});
                                Get.back();
                              });
                            });
                            return;
                        }

                        ///----------------------------------------------------
                        if (!imageFromUrl && imageFromUrl2) {

                          FirebaseStoreFile()
                              .storeFile(
                              file: image!,
                              path:
                              "${widget.categoryName}/${productNameController.value.text + productModel.productGrade.toString()}")
                              .then((value) {
                            productModel.productName =
                                productNameController.value.text;
                            productModel.productDescription =
                                description.value.text;
                            productModel.productGrade =
                                productGrade.value.text;
                            productModel.productImage = value;
                            productModel.productImage2 =
                                widget.productDetailsModel?.productImage2 ?? "";
                            FirebaseRealTimeStorage()
                                .addProduct(
                                productModel: productModel,
                                categoryName: widget.categoryName)
                                .then((value) {
                              image = null;
                              setState(() {});
                              Get.back();
                            });
                          });
                          return;
                        }

                        ///--------------------------------------
                        FirebaseStoreFile()
                            .storeFile(
                                file: image!,
                                path:
                                    "${widget.categoryName}/${productNameController.value.text + productModel.productGrade.toString()}")
                            .then((value) {
                          FirebaseStoreFile()
                              .storeFile(
                                  file: image2!,
                                  path:
                                      "${widget.categoryName}/${productNameController.value.text + productModel.productGrade.toString()}-2")
                              .then((value2) {
                            productModel.productName =
                                productNameController.value.text;
                            productModel.productDescription =
                                description.value.text;
                            productModel.productGrade = productGrade.value.text;
                            productModel.productImage = value;
                            productModel.productImage2 = value2;
                            FirebaseRealTimeStorage()
                                .addProduct(
                                    productModel: productModel,
                                    categoryName: widget.categoryName)
                                .then((value) {
                              image = null;
                              setState(() {});
                              Get.back();
                            });
                          });
                        });
                      }
                    },
                    child:
                        MyRoundButton(text: "Add Item", bgColor: Colors.green)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  slapList() {
    return ListView.builder(
        shrinkWrap: true,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        physics: NeverScrollableScrollPhysics(),
        itemCount: productModel.quantityAndPrice!.length,
        itemBuilder: (context, i) {
          final _key = GlobalKey<FormState>();
          TextEditingController quantityController = TextEditingController();
          TextEditingController priceController = TextEditingController();
          quantityController.text =
              productModel.quantityAndPrice![i].quantity ?? "";
          priceController.text = productModel.quantityAndPrice![i].price ?? "";
          quantityController.addListener(() {
            productModel.quantityAndPrice![i].quantity =
                quantityController.value.text;
          });
          priceController.addListener(() {
            productModel.quantityAndPrice![i].price =
                priceController.value.text;
          });
          return Column(
            children: [
              smallSpace(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        boxShadow: myShadow,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      "Slab ${i + 1} : ",
                      style: CommonDecoration.listItem
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        MyTextFieldWithPreFix(
                            textEditController: quantityController,
                            filled: false,
                            textInputType: TextInputType.text,
                            label: "Quantity",
                            validate: true),
                        smallSpace(),
                        MyTextFieldWithPreFix(
                            textEditController: priceController,
                            filled: false,
                            textInputType: TextInputType.number,
                            label: "Price",
                            validate: true),
                        if (productModel.quantityAndPrice!.length - 1 == i)
                          smallSpace(),
                        if (productModel.quantityAndPrice!.length - 1 == i)
                          InkWell(
                              onTap: () {
                                if (_key.currentState!.validate()) {
                                  productModel.quantityAndPrice!
                                      .add(QuantityAndPrice());
                                  setState(() {});
                                }
                              },
                              child: MyRoundButton(
                                  text: "Add Slab", bgColor: Colors.blue)),
                        smallSpace(),
                        Container(
                          color: Colors.grey,
                          width: double.infinity,
                          height: 1,
                        )
                      ],
                    ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  i == 0
                      ? Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.transparent,
                          ))
                      : InkWell(
                          onTap: () {
                            productModel.quantityAndPrice!.removeAt(i);
                            setState(() {});
                          },
                          child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.white,
                              )),
                        )
                ],
              ),
            ],
          );
        });
  }
}
