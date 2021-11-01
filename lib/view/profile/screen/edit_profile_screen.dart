import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/view/common/components/circle_photo.dart';
import 'package:insta_clone/view/common/dialog/confirm_dialog.dart';
import 'package:insta_clone/view_model/profile_view_model.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _photoUrl = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isImageFromFile = false;

  @override
  void initState() {
    final profileViewModel = context.read<ProfileViewModel>();
    final profileUser = profileViewModel.profileUser;

    _isImageFromFile = false;
    _photoUrl = profileUser.photoUrl;

    _nameController.text = profileUser.inAppUserName;
    _bioController.text = profileUser.bio;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(S.of(context).editProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => showConfirmDialog(
              context: context,
              title: S.of(context).editProfile,
              content: S.of(context).editProfileConfirm,
              onConfirmed: (isConfirmed) {
                if (isConfirmed) {
                  _updateProfile(context);
                }
              },
            ),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (_, model, child) {
          return model.isProcessing
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 16.0),
                        Center(
                          child: (_photoUrl == "")
                              ? Container()
                              : CirclePhoto(
                                  radius: 60.0,
                                  photoUrl: _photoUrl,
                                  isImageFromFile: _isImageFromFile,
                                ),
                        ),
                        const SizedBox(height: 12.0),
                        Center(
                          child: InkWell(
                            onTap: () => _pickNewProfileImage(),
                            child: Text(
                              S.of(context).changeProfilePhoto,
                              style: changeProfilePhotoTextStyle,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text("Name", style: editProfileTitleTextStyle),
                        TextField(
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16.0),
                        const Text("Bio", style: editProfileTitleTextStyle),
                        TextField(
                          controller: _bioController,
                        )
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Future<void> _pickNewProfileImage() async {
    _isImageFromFile = false;
    final profileViewModel = context.read<ProfileViewModel>();
    _photoUrl = await profileViewModel.pickProfileImage();
    setState(() {
      _isImageFromFile = true;
    });
  }

  void _updateProfile(BuildContext context) async {
    final profileViewModel = context.read<ProfileViewModel>();
    await profileViewModel.updateProfile(
      _nameController.text,
      _bioController.text,
      _photoUrl,
      _isImageFromFile,
    );
    Navigator.pop(context);
  }
}
