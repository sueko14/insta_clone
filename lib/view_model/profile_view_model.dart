import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';
import 'package:insta_clone/utils/constants.dart';

class ProfileViewModel extends ChangeNotifier {
  final PostRepository postRepository;
  final UserRepository userRepository;

  ProfileViewModel({
    required this.userRepository,
    required this.postRepository,
  });

  late User profileUser;

  //ProfileViewModelを使うとき必ずsetProfileUserを実行するからlate
  User get currentUser => UserRepository.currentUser!; //ログインしているため
  bool isProcessing = false;
  List<Post> posts = [];
  List<String> popProfileUserIds = [];
  String popUserId = "";

  bool isFollowingProfileUser = false;

  void setProfileUser(
    ProfileMode profileMode,
    User? selectedUser,
    String? popProfileUserId,
  ) {
    if (popProfileUserId != null) {
      popProfileUserIds.add(popProfileUserId);
    }

    if (profileMode == ProfileMode.MYSELF) {
      profileUser = currentUser;
    } else {
      //TODO ProfileMode.OTHERのときは必要な形で実装。いつかリファクタしたい。
      profileUser = selectedUser!;
      checkIsFollowing();
    }
  }

  Future<void> getPost() async {
    isProcessing = true;
    notifyListeners();

    posts = await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser);

    isProcessing = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await userRepository.signOut();
    notifyListeners();
  }

  Future<int> getNumberOfPosts() async {
    return (await postRepository.getPosts(FeedMode.FROM_PROFILE, profileUser))
        .length;
  }

  Future<int> getNumberOfFollowers() async {
    return await userRepository.getNumberOfFollowers(profileUser);
  }

  Future<int> getNumberOfFollowings() async {
    return await userRepository.getNumberOfFollowings(profileUser);
  }

  Future<String> pickProfileImage() async {
    final pickedImage = await postRepository.pickImage(UploadType.GALLERY);
    return (pickedImage != null) ? pickedImage.path : "";
  }

  Future<void> updateProfile(
    String nameUpdated,
    String bioUpdated,
    String photoUrlUpdated,
    bool isImageFromFile,
  ) async {
    isProcessing = true;
    notifyListeners();

    await userRepository.updateProfile(
      profileUser,
      nameUpdated,
      bioUpdated,
      photoUrlUpdated,
      isImageFromFile,
    );

    // アプリで使っているユーザー情報はuserRepositoryのcurrentUser。
    // だからusersコレクションの更新後に、ユーザーデータを再取得する必要がある。
    await userRepository.getCurrentUserById(profileUser.userId);
    profileUser = currentUser;

    isProcessing = false;
    notifyListeners();
  }

  Future<void> follow() async {
    await userRepository.follow(profileUser);
    isFollowingProfileUser = true;
    notifyListeners();
  }

  Future<void> checkIsFollowing() async {
    isFollowingProfileUser = await userRepository.checkIsFollowing(profileUser);
    notifyListeners();
  }

  Future<void> unfollow() async {
    await userRepository.unFollow(profileUser);
    isFollowingProfileUser = false;
    notifyListeners();
  }

  void popProfileUser() async {
    if (popProfileUserIds.isNotEmpty) {
      popUserId = popProfileUserIds.last;
      popProfileUserIds.removeLast();
      profileUser = await userRepository.getUserById(popUserId);
    } else {
      profileUser = currentUser;
    }
    getPost();
  }
}
