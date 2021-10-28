import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';
import 'package:insta_clone/utils/constants.dart';

class FeedViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  final PostRepository postRepository;

  String caption = ""; //FEEDの編集から来たときのキャプションの変更
  FeedViewModel({required this.userRepository, required this.postRepository});

  bool isProcessing = false;
  List<Post> posts = [];

  late User feedUser;
  User get currentUser => UserRepository.currentUser!; //ログインしてないとFeed画面に来ないから

  void setFeedUser(FeedMode feedMode, User? user){
    if(feedMode == FeedMode.FROM_FEED || user == null){
      feedUser = currentUser;
    }else{
      feedUser = user;
    }
  }

  Future<void> getPosts(FeedMode feedMode) async{
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(feedMode,feedUser);

    isProcessing = false;
    notifyListeners();
  }

  Future<User> getPostUserInfo(String userId) async{
    return await userRepository.getUserById(userId);
  }

  Future<void> updatePost(Post post, FeedMode feedMode) async{
    isProcessing = true;
    await postRepository.updatePost(
      post.copyWith(caption:caption)
    );
    await getPosts(feedMode);
    isProcessing = false;
    notifyListeners();
  }
}