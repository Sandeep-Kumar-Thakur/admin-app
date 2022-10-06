import 'package:admin_app/constants/key_contants.dart';
import 'package:admin_app/controller/user_controller.dart';
import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/screen/add_category_screen.dart';
import 'package:admin_app/screen/add_product.dart';
import 'package:admin_app/screen/items_list.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryList extends StatelessWidget {
  CategoryList({Key? key}) : super(key: key);

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
          goTo(className: AddCategoryScreen());
        },
        child: Icon(Icons.add),
      ),
      body: myPadding(
        child: Column(
          children: [
            commonHeader("Category List"),
            Obx(() {
              return UserController()
                      .stateController
                      .categoryList
                      .length
                      .isEqual(0)
                  ? Text("No Data Found")
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          UserController().stateController.categoryList.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: myShadow),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: myImage(

                                              source: UserController()
                                                  .stateController
                                                  .categoryList[i]
                                                  .image,
                                             fromUrl: true
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      UserController()
                                              .stateController
                                              .categoryList[i]
                                              .name ??
                                          "",
                                      style: CommonDecoration.listItem,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              FirebaseRealTimeStorage()
                                                  .deleteCategory(
                                                      id: UserController()
                                                          .stateController
                                                          .categoryList[i]
                                                          .name);
                                            },
                                            child: optionButton(Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            )))),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            goTo(
                                                className: AddCategoryScreen(
                                              filled: true,
                                              categoryModel: UserController()
                                                  .stateController
                                                  .categoryList[i],
                                            ));
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
                                              goTo(
                                                  className: ItemsListScreen(
                                                    index: i,
                                                categoryName: UserController()
                                                    .stateController
                                                    .categoryList[i]
                                                    .name,
                                              ));
                                              // goTo(
                                              //     className: AddProductScreen(
                                              //         categoryName:
                                              //             UserController()
                                              //                 .stateController
                                              //                 .categoryList[i]
                                              //                 .name));
                                            },
                                            child: optionButton(Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            )))),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
            }),
          ],
        ),
      ),
    );
  }
}
