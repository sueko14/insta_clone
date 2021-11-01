import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';
import 'package:insta_clone/utils/constants.dart';

class WhoCaresMeViewModel extends ChangeNotifier {
  UserRepository userRepository;

  WhoCaresMeViewModel({required this.userRepository});

  List<User> caresMeUsers = [];

  User get currentUser => UserRepository.currentUser!; //ログインしてないとFeed画面に来ないから

  WhoCaresMeMode whoCaresMeMode = WhoCaresMeMode.LIKE;

  Future<void> getCaresMeUsers(String id, WhoCaresMeMode mode) async {
    whoCaresMeMode = mode;
    caresMeUsers = await userRepository.getCaresMeUsers(id, mode);
    notifyListeners();
  }

  void rebuildAfterPop(String popUserId) {
    getCaresMeUsers(popUserId, whoCaresMeMode);
  }
}
