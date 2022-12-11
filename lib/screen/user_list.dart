import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class UserList extends StatelessWidget {
  List<UserModel> userList;

  UserList({Key? key, required this.userList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemCount: userList.length,
          itemBuilder: (context, i) {
            return Container(
              padding: EdgeInsets.all(5),
              child: ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userList[i].name ?? "",
                        style: CommonDecoration.subHeaderDecoration,
                      ),
                      Text(
                        userList[i].number ?? "",
                        style: CommonDecoration.descriptionDecoration,
                      ),
                    ],
                  ),
                ],
              ),
                children: [
                    Text("Location : ${userList[i].location}"??"",style: CommonDecoration.listItem,),
                    smallSpace(),
                    Text("Landmark : ${userList[i].landmark}"??"",style: CommonDecoration.listItem,),
                  smallSpace(),

                  Text("ZipCode : ${userList[i].pinCode}"??"",style: CommonDecoration.listItem,),
                  smallSpace(),

                  Text("Email : ${userList[i].gmail}"??"",style: CommonDecoration.listItem,),
                  smallSpace(),

                  Text("Alternative Number : ${userList[i].location}"??"",style: CommonDecoration.listItem,),
                  smallSpace(),

                ],
              ),
            );
          }),
    );
  }
}
