import 'package:admin_app/model/store_cart_model.dart';
import 'package:admin_app/screen/single_order_details.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/user_model.dart';

class OrderDetails extends StatelessWidget {
  List<StoreCartModel> storeList;

  OrderDetails({Key? key, required this.storeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order List"),
      ),
      body: ListView.builder(
          itemCount: storeList.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: (){
                goTo(className: SingleOrderDetails(storeCartModel:storeList[i]));
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  boxShadow: myShadow
                ),
                child: Row(
                  children: [
                    Icon(Icons.list_alt_sharp),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${storeList[i].userModel?.name.toString()}",
                          style: CommonDecoration.subHeaderDecoration,
                        ),
                        Text(
                          "Rs. ${storeList[i].totalAmount}" ?? "",
                          style: CommonDecoration.listItem,
                        ),

                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Item Count : ${storeList[i].cartItem?.length}" ?? "",
                          style: CommonDecoration.descriptionDecoration,
                        ),
                        Text(
                          "${DateFormat("dd, MMM yyyy ").add_jm().format(DateTime.parse(storeList[i].dateTime??""))}" ?? "",
                          style: CommonDecoration.descriptionDecoration,
                        ),
                        Text(
                          "Status : ${storeList[i].confirm}" ?? "",
                          style: CommonDecoration.descriptionDecoration,
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_right_sharp)
                  ],
                ),
              ),
            );
          }),
    );
  }
}
