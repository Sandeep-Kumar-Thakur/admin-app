import 'dart:io';

import 'package:admin_app/firebase/firebase_realtime.dart';
import 'package:admin_app/firebase/firebase_storage.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/utility/helper_widgets.dart';
import 'package:admin_app/utility/my_button.dart';
import 'package:admin_app/utility/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/key_contants.dart';

class AddCategoryScreen extends StatefulWidget {
  bool? filled;
  CategoryModel? categoryModel;
   AddCategoryScreen({Key? key,this.filled, this.categoryModel}) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController nameController = TextEditingController();

  final _key  = GlobalKey<FormState>();

   File? image;
   bool imageFormUrl = false;
   Future pickImage() async {
     try {
       final image = await ImagePicker(
       ).pickImage(source: ImageSource.gallery,imageQuality: KeyConstants.imageQuality);
       if(image == null) return;
       final imageTemp = File(image.path);
       imageFormUrl = false;
       setState(() => this.image = imageTemp);
     } on PlatformException catch(e) {
       print('Failed to pick image: $e');
     }
   }

   @override
  void initState() {
     if(widget.filled==true){
       nameController.text = widget.categoryModel?.name??"";
      imageFormUrl = true;
     }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPadding(
        child: Form(
          key: _key,
          child: Column(

            children: [
              commonHeader("Add Category"),
              MyTextFieldWithPreFix(textEditController: nameController, textInputType: TextInputType.name, label: "Category Name", validate: false, filled: widget.filled==true?true:false,),
              smallSpace(),
              InkWell(
                onTap: (){
                  pickImage();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child:imageFormUrl?Image.network(widget.categoryModel?.image??""): image?.path==null?Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text("Add"),
                    ],
                  ):Image.file(image!),
                  height: 150,
                  width: double.infinity,
                ),
              ),
              largeSpace(),
              InkWell(
                  onTap: (){

                    if(imageFormUrl){
                      return;
                    }

                    if(_key.currentState!.validate()){
                      if(image?.path==null){
                        showMessage(msg: "Please Select Image");
                      }

                      FirebaseStoreFile().storeFile(file: image!, path: nameController.value.text+"/"+"sd").then((value){
                        CategoryModel categoryModel = CategoryModel();
                        categoryModel.name=nameController.value.text;
                        categoryModel.id=nameController.value.text;
                        categoryModel.image=value;
                        FirebaseRealTimeStorage().addCategory(categoryModel).then((value){
                          nameController.clear();
                          image = null;
                          setState(() {

                          });
                        });
                      });
                    }

                  },
                  child: MyRoundButton(text: "Add Category", bgColor:imageFormUrl?Colors.grey: Colors.blue))
            ],
          ),
        ),
      ),
    );
  }
}
