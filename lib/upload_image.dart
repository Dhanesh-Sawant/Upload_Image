import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';



final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> uploadImageToStorage(Uint8List file) async {

  String imageId = Uuid().v1();

  Reference ref = _storage.ref().child('Images_Uploaded').child(imageId);


  UploadTask uploadtask = ref.putData(file);

  TaskSnapshot snap = await uploadtask;
  String downloadUrl = await snap.ref.getDownloadURL();

  print('doing..');

  print("done");

  return downloadUrl;
}

