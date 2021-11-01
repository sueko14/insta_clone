import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';

class SearchViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  SearchViewModel({required this.userRepository});

  List<User> searchedUsers = [];

  Future<void> searchUsers(String query) async{
    searchedUsers = await userRepository.searchUsers(query);
    notifyListeners();
  }
}
