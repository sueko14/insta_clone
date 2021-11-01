import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/profile/page/profile_page.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileMode profileMode;
  final User selectedUser;
  final String popProfileUserId;

  ProfileScreen(
      {required this.profileMode, required this.selectedUser, required this.popProfileUserId,});

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      profileMode: profileMode,
      selectedUser: selectedUser,
      isOpenFromProfileScreen: true,
      popProfileUserId: popProfileUserId,
    );
  }
}
