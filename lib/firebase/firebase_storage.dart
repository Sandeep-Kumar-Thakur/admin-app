import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../utility/helper_widgets.dart';

class FirebaseStoreFile{

  final firebaseStorage = FirebaseStorage.instance;

  Future<String> storeFile({required File file,required String path})async{
    showLoader();
   var raw = await firebaseStorage.ref(path).putFile(file);
   String url =await  raw.ref.getDownloadURL();
   hideLoader();
   return url;
  }
}