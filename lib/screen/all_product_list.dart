import 'package:admin_app/utility/common_decoration.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:flutter/material.dart';

import '../model/category_model.dart';

class AllProductList extends StatefulWidget {
  List<ProductDetailsModel> productListAll;
   AllProductList({Key? key,required this.productListAll}) : super(key: key);

  @override
  State<AllProductList> createState() => _AllProductListState();
}

class _AllProductListState extends State<AllProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          List<ProductDetailsModel> selected = [];
          for (var element in widget.productListAll) {
            if(element.selected==true)selected.add(element);
          }
          Navigator.pop(context,selected);
          },
        child: Text("ADD",style: CommonDecoration.listItem.copyWith(color: Colors.white),),
      ),
      body:myPadding(
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100),
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: widget.productListAll.length,
            itemBuilder: (context,i){
          return  InkWell(
            onTap: (){
            if(widget.productListAll[i].selected==null) {
              widget.productListAll[i].selected = true;
            }else{
              widget.productListAll[i].selected = !widget.productListAll[i].selected! ;
            }
              setState(() {

              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color:widget.productListAll[i].selected==true?Colors.blue.withOpacity(.2): Colors.white,
                  boxShadow: myShadow
              ),
              child:Row(
                children: [
                  SizedBox(
                      width: 80,
                      height: 80,
                      child: myImage(source:widget.productListAll[i].productImage??"" , fromUrl: true)),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.productListAll[i].productName??"",style: CommonDecoration.listItem,),
                      Text("Grade : ${widget.productListAll[i].productGrade}"??"",style: CommonDecoration.listItem,),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ) ,
    );
  }
}
