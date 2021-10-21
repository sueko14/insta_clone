import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/location.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';
import 'package:insta_clone/utils/constants.dart';

class PostViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final UserRepository userRepository;

  PostViewModel({required this.userRepository, required this.postRepository});

  bool isProcessing = false;
  bool isImagePicked = false;
  File? imageFile;
  Location? location;
  String locationString = "";

  Future<void> pickImage(UploadType uploadType) async {
    isImagePicked = false;
    isProcessing = true;
    notifyListeners();

    imageFile = await postRepository.pickImage(uploadType);
    print("pickedImage: ${imageFile?.path}");

    location = await postRepository.getCurrentLocation();
    locationString = (location != null) ? _toLocationString(location!) : "";
    print("location: $locationString");

    if (imageFile != null) {
      isImagePicked = true;
    }
    isProcessing = false;
    notifyListeners();
  }

  String _toLocationString(Location location) {
    return location.country + " " + location.state + " " + location.city;
  }

  void cancelPost() {
    isProcessing = false;
    isImagePicked = false;
    notifyListeners();
  }
}
