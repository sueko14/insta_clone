import 'package:flutter/material.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier{
  final UserRepository userRepository;
  LoginViewModel({required this.userRepository});

  bool isLoading = false;
  bool isSuccessful = false;

  Future<bool> isSignedIn() async{
    return await userRepository.isSignedIn();
}

  Future<void> signin() async {
    isLoading = true;
    notifyListeners();

    isSuccessful = await userRepository.signIn();

    isLoading = false;
    notifyListeners();
  }
}
