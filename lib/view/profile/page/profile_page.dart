import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/profile/components/profile_detail_part.dart';
import 'package:insta_clone/view/profile/components/profile_post_grid_part.dart';
import 'package:insta_clone/view/profile/components/profile_setting_part.dart';
import 'package:insta_clone/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final ProfileMode profileMode;
  final User? selectedUser;
  ProfilePage({required this.profileMode, this.selectedUser});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.setProfileUser(profileMode, selectedUser);

    Future(()=> profileViewModel.getPost());

    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context,model,child){
          final profileUser = model.profileUser;
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text(profileUser.inAppUserName),
                pinned: true, // スクロールしてもAppBar最上部を残すか？
                floating: true, //スクロールして戻るとき、一番上まで戻らなくてもflexible spaceを再表示させるか？
                actions: <Widget>[
                  ProfileSettingPart(
                    mode: profileMode,
                  ),
                ],
                expandedHeight: 280.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileDetailPart(
                    mode: profileMode,
                  ),
                ),
              ),
              ProfilePostGridPart(
                posts: model.posts
              ),
            ],
          );
        },
      ),
    );
  }
}
