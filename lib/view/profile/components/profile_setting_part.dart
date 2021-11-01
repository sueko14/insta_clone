import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/login/screens/login_screen.dart';
import 'package:insta_clone/view_model/profile_view_model.dart';
import 'package:insta_clone/view_model/theme_change_view_model.dart';
import 'package:provider/provider.dart';

class ProfileSettingPart extends StatelessWidget {
  final ProfileMode mode;

  ProfileSettingPart({required this.mode});

  @override
  Widget build(BuildContext context) {
    final themeChangeViewModel = context.read<ThemeChangeViewModel>();
    final isDarkOn = themeChangeViewModel.isDarkOn;
    return PopupMenuButton(
      icon: const Icon(Icons.settings),
      onSelected: (ProfileSettingMenu value) =>
          _onPopupMenuSelected(context, value, isDarkOn),
      itemBuilder: (context) {
        if (mode == ProfileMode.MYSELF) {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: isDarkOn
                  ? Text(S.of(context).changeToLightTheme)
                  : Text(S.of(context).changeToDarkTheme),
            ),
            PopupMenuItem(
              value: ProfileSettingMenu.SIGN_OUT,
              child: Text(S.of(context).signOut),
            ),
          ];
        } else {
          return [
            PopupMenuItem(
              value: ProfileSettingMenu.THEME_CHANGE,
              child: isDarkOn
                  ? Text(S.of(context).changeToLightTheme)
                  : Text(S.of(context).changeToDarkTheme),
            ),
          ];
        }
      },
    );
  }

  _onPopupMenuSelected(BuildContext context, ProfileSettingMenu selectedMenu, bool isDarkOn) {
    switch (selectedMenu) {
      case ProfileSettingMenu.THEME_CHANGE:
        final themeChangeViewModel = context.read<ThemeChangeViewModel>();
        themeChangeViewModel.setTheme(!isDarkOn);
        break;
      case ProfileSettingMenu.SIGN_OUT:
        _signOut(context);
        break;
    }
  }

  void _signOut(BuildContext context) async {
    final profileViewModel = context.read<ProfileViewModel>();
    await profileViewModel.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
