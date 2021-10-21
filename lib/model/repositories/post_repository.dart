import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/data_models/location.dart';
import 'package:insta_clone/model/db/database_manager.dart';
import 'package:insta_clone/model/location/location_manager.dart';
import 'package:insta_clone/utils/constants.dart';

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;

  PostRepository({required this.dbManager, required this.locationManager});
  
  Future<File?> pickImage(UploadType uploadType) async {
    final imagePicker = ImagePicker();

    if (uploadType == UploadType.GALLERY) {
      final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    } else {
      final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    }
  }

  Future<Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }
}
