import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

Future<String> convertImageToJPEG(XFile imageFile) async {
  final Directory appDir = await getApplicationDocumentsDirectory();
  final String targetPath = path.join(appDir.path, 'converted_image.jpg');
  final File targetFile = File(targetPath);

  await FlutterImageCompress.compressAndGetFile(
    imageFile.path,
    targetFile.path,
    format: CompressFormat.jpeg,
    quality: 90,
  );

  print(targetPath);

  return targetPath;
}


