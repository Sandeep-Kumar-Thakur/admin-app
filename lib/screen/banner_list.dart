import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/navigator_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/banner_model.dart';
import 'add_banner.dart';

class BannerList extends StatefulWidget {
  List<BannerModel> bannerList;

  BannerList({Key? key, required this.bannerList}) : super(key: key);

  @override
  State<BannerList> createState() => _BannerListState();
}

class _BannerListState extends State<BannerList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: (){
          FirebaseRealTimeStorage().getAllCategoryList(navigate: false).then((value){
            goTo(className: AddBanner());
          });
        },
      ),
      appBar: AppBar(
        title: Text("Banner List"),
      ),
      body: myPadding(
        child: ListView.builder(
            itemCount: widget.bannerList.length,
            itemBuilder: (context, i) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Colors.white, boxShadow: myShadow),
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: myImage(
                          source: widget.bannerList[i].image ?? "",
                          fromUrl: true),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.bannerList[i].name}",
                          style: CommonDecoration.listItem,
                        ),
                        Row(
                          children: [
                            IconButton(

                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                FirebaseRealTimeStorage().getAllCategoryList(navigate: false).then((value){
                                  goTo(className: AddBanner(filled: true,bannerModel: widget.bannerList[i],));

                                });
                              },
                            ),
                            IconButton(

                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                 FirebaseRealTimeStorage().deleteBanner(key: widget.bannerList[i].name??"");
                              },
                            ),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
