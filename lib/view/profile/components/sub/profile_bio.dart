import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/profile/screen/edit_profile_screen.dart';
import 'package:insta_clone/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileBio extends StatelessWidget {
  final ProfileMode mode;

  ProfileBio({required this.mode});

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(profileUser.inAppUserName),
          Text(profileUser.bio, style: profileBioTextStyle),
          const SizedBox(height: 16.0),
          SizedBox(
            //横幅いっぱいのボタン作るのに使う
            width: double.infinity,
            child: _button(context, profileUser),
          )
        ],
      ),
    );
  }

  _button(BuildContext context, User profileUser) {
    final profileViewModel = context.read<ProfileViewModel>();
    final isFollowing = profileViewModel.isFollowingProfileUser;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      )),
      child: _getBioButtonText(context, mode, isFollowing),
      onPressed: () {
        if (mode == ProfileMode.MYSELF) {
          _openEditProfileScreen(context);
        } else {
          if (isFollowing) {
            _unFollow(context);
          } else {
            _follow(context);
          }
        }
      },
    );
  }

  _openEditProfileScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(),
      ),
    );
  }

  void _unFollow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.unfollow();
  }

  void _follow(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();
    profileViewModel.follow();
  }

  Text _getBioButtonText(BuildContext context, ProfileMode mode, bool isFollowing) {
    if (mode == ProfileMode.MYSELF) {
      return Text(S.of(context).editProfile);
    }
    if (isFollowing) {
      return Text(S.of(context).unFollow);
    }
    return Text(S.of(context).follow);
  }
}
