import 'package:admin_app/constants/key_contants.dart';
import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:flutter/material.dart';
import '../model/store_cart_model.dart';
import '../utility/common_decoration.dart';

class SingleOrderDetails extends StatelessWidget {
  StoreCartModel storeCartModel;
   SingleOrderDetails({Key? key,required this.storeCartModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: myPadding(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: myShadow
              ),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User Details:"),
                  Text("UserName : ${storeCartModel.userModel!.name}"),
                  Text("Address : ${storeCartModel.userModel!.location}"),
                  Text("Contact No. : ${storeCartModel.userModel!.number}")
                ],
              ),
            ),
            smallSpace(),
            Expanded(child: ListView.builder(
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                itemCount: storeCartModel.cartItem?.length??0,
                itemBuilder: (context,i){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: myShadow
                      ),
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(10),
                      child: Text("${i + 1}"),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),

                        decoration: BoxDecoration(
                            boxShadow: myShadow
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Item Name : ${storeCartModel.cartItem![i].itemName}-${storeCartModel.cartItem![i].itemGrade}"??""),
                            Text("Item Quantity : ${storeCartModel.cartItem![i].itemQuantity} x ${storeCartModel.cartItem![i].itemCount}"),
                            Text("Item Total Price : ₹ ${storeCartModel.cartItem![i].itemTotal}"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                      onTap: () {
                        storeCartModel.confirm = KeyConstants.cancelOrder;
                        FirebaseRealTimeStorage().changeOrderStatus(storeCartModel: storeCartModel);
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: Text(
                          "Cancel",
                          style: CommonDecoration.listItem
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )),
                Expanded(
                    child: InkWell(
                      onTap: (){
                        storeCartModel.confirm = KeyConstants.confirmOrder;
                        FirebaseRealTimeStorage().changeOrderStatus(storeCartModel: storeCartModel);
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        color: Colors.blue,
                        child: Text(
                          "Confirm",
                          style: CommonDecoration.listItem
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
