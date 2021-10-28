import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';

class CommentViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;

  User get currentUser => UserRepository.currentUser!; //コメントできる人は必ずログイン済み
  String comment = "";

  CommentViewModel({required this.userRepository, required this.postRepository});


}
