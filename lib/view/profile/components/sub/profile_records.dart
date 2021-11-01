import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/who_cares_me/screen/who_cares_me_screen.dart';
import 'package:insta_clone/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileRecords extends StatelessWidget {
  const ProfileRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();

    return Row(
      children: <Widget>[
        FutureBuilder(
          future: profileViewModel.getNumberOfPosts(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S.of(context).post,
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowers(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S.of(context).followers,
              mode: WhoCaresMeMode.FOLLOWERS,
            );
          },
        ),
        FutureBuilder(
          future: profileViewModel.getNumberOfFollowings(),
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _userRecordWidget(
              context: context,
              score: snapshot.hasData ? snapshot.data! : 0,
              title: S.of(context).followers,
              mode: WhoCaresMeMode.FOLLOWINGS,
            );
          },
        ),
      ],
    );
  }

  _userRecordWidget({
    required BuildContext context,
    required int score,
    required String title,
    WhoCaresMeMode? mode,
  }) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: mode == null ? null : () => _checkFollowUsers(context, mode),
        child: Column(
          children: <Widget>[
            Text(
              score.toString(),
              style: profileRecordScoreTextStyle,
            ),
            Text(
              title,
              style: profileRecordTitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  _checkFollowUsers(BuildContext context, WhoCaresMeMode mode) {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WhoCaresMeScreen(
          mode: mode,
          id: profileUser.userId,
        ),
      ),
    );
  }
}
