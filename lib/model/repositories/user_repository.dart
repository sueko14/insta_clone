import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/db/database_manager.dart';
import 'package:uuid/uuid.dart';

class UserRepository {
  final DatabaseManager dbManager;

  UserRepository({required this.dbManager});

  static User? currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignedIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<bool> signIn() async {
    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) {
        return false;
      }
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null) {
        return false;
      }
      //  DBに登録
      final isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);
      if (!isUserExistedInDb) {
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    } catch (error) {
      print("[ERROR!]sign in error : $error");
      // エラー処理
      return false;
    }
  }

  _convertToUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? "",
      inAppUserName: firebaseUser.displayName ?? "",
      photoUrl: firebaseUser.photoURL ?? "",
      email: firebaseUser.email ?? "",
      bio: "",
    );
  }

  Future<User> getUserById(String userId) async {
    return await dbManager.getUserInfoFromDbById(userId);
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    //_googleSignIn.signOut()だと、アプリ再起動時にログイン状態に戻ってしまうケースがある

    //firebaseからもサインアウトする。
    await _auth.signOut();
    currentUser = null;
  }

  Future<int> getNumberOfFollowers(User profileUser) async {
    return (await dbManager.getFollowerUserIds(profileUser.userId)).length;
  }

  Future<int> getNumberOfFollowings(User profileUser) async {
    return (await dbManager.getFollowingUserIds(profileUser.userId)).length;
  }

  Future<void> updateProfile(
    User profileUser,
    String nameUpdated,
    String bioUpdated,
    String photoUrlUpdated,
    bool isImageFromFile,
  ) async {
    String updatePhotoUrl = "";
    if (isImageFromFile) {
      // ファイルをアップデートしている場合は、まず先にアップロードしてそのパスを取得する
      final updatePhotoFile = File(photoUrlUpdated);
      final storagePath = const Uuid().v1();
      updatePhotoUrl =
          await dbManager.uploadImageToStorage(updatePhotoFile, storagePath);
    }
    final userBeforeUpdate =
        await dbManager.getUserInfoFromDbById(profileUser.userId);
    final updateUser = userBeforeUpdate.copyWith(
      inAppUserName: nameUpdated,
      photoUrl: isImageFromFile ? updatePhotoUrl : userBeforeUpdate.photoUrl,
      bio: bioUpdated,
    );

    await dbManager.updateProfile(updateUser);
  }

  Future<void> getCurrentUserById(String userId) async {
    currentUser = await dbManager.getUserInfoFromDbById(userId);
  }

  Future<List<User>> searchUsers(String query) async {
    return dbManager.searchUsers(query);
  }

  Future<void> follow(User profileUser) async {
    if (currentUser != null) {
      await dbManager.follow(profileUser, currentUser!);
    }
  }

  Future<bool> checkIsFollowing(User profileUser) async {
    if (currentUser != null) {
      return await dbManager.checkIsFollowing(profileUser, currentUser!);
    }
    return false;
  }

  Future<void> unFollow(User profileUser)async {
    if (currentUser != null) {
      return await dbManager.unFollow(profileUser, currentUser!);
    }
  }
}
