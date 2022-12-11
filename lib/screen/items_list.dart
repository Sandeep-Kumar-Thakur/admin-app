import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/screen/add_product.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/user_controller.dart';
import '../utility/common_decoration.dart';

class ItemsListScreen extends StatelessWidget {
  String categoryName;
  int index;

  ItemsListScreen({Key? key, required this.categoryName, required this.index})
      : super(key: key);

  Widget optionButton(Icon icon) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.blue),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goTo(
              className: AddProductScreen(
                  categoryName: UserController()
                      .stateController
                      .categoryList[index]
                      .name));
        },
        child: Icon(Icons.add),
      ),
      body: myPadding(
          child: SingleChildScrollView(
        child: Column(
          children: [
            commonHeader("$categoryName Items List"),
            Obx(() {
              CategoryModel data =
                  UserController().stateController.categoryList[index];
              return data.productList!.length.isEqual(0)
                  ? Text("No Data Found")
                  : ListView.builder(
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.productList!.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.symmetric(horizontal: 10),
                            collapsedBackgroundColor: Colors.blue,
                            collapsedIconColor: Colors.white,
                            collapsedTextColor: Colors.white,
                            title: Row(
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: myImage(
                                            source: data.productList![i]
                                                    .productImage ??
                                                "",
                                            fromUrl: true))),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("${data.productList![i].productName}- ${data.productList![i].productGrade}"),
                              ],
                            ),
                            children: [
                              ListView.builder(
                                  addAutomaticKeepAlives: false,
                                  addRepaintBoundaries: false,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: data
                                      .productList![i].quantityAndPrice!.length,
                                  itemBuilder: (context, j) => Container(
                                        padding: EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.blue
                                                        .withOpacity(.3),
                                                    width: 1))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data
                                                      .productList![i]
                                                      .quantityAndPrice![j]
                                                      .quantity ??
                                                  "",
                                              style: CommonDecoration.listItem,
                                            ),
                                            Text(
                                              data
                                                      .productList![i]
                                                      .quantityAndPrice![j]
                                                      .price ??
                                                  "",
                                              style: CommonDecoration.listItem,
                                            ),
                                          ],
                                        ),
                                      )),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          goTo(
                                              className: AddProductScreen(
                                                  filled: true,
                                                  productDetailsModel:
                                                      data.productList![i],
                                                  categoryName: UserController()
                                                      .stateController
                                                      .categoryList[index]
                                                      .name));
                                        },
                                        child: optionButton(Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ))),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            FirebaseRealTimeStorage()
                                                .deleteProduct(
                                                    categoryId: categoryName,
                                                    productId: data
                                                            .productList![i]
                                                            .productName.toString()+data
                                                        .productList![i]
                                                        .productGrade.toString());
                                          },
                                          child: optionButton(Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          )))),
                                ],
                              )
                            ],
                          ),
                        );
                      });
            }),
          ],
        ),
      )),
    );
  }
}
