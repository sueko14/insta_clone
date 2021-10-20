import 'package:flutter/material.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';

class PostViewModel extends ChangeNotifier{
  final PostRepository postRepository;
  final UserRepository userRepository;

  PostViewModel({required this.userRepository, required this.postRepository});

  bool isProcessing = false;
  bool isImagePicked = false;
}
