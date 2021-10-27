import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> searchUserInDb(auth.User firebaseUser) async {
    final query = await _db
        .collection("users")
        .where("userId", isEqualTo: firebaseUser.uid)
        .get();
    if (query.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> insertUser(User user) async {
    await _db.collection("users").doc(user.userId).set(user.toMap());
  }

  Future<User> getUserInfoFromDbById(String uid) async {
    final query =
        await _db.collection("users").where("userId", isEqualTo: uid).get();
    return User.fromMap(query.docs[0].data());
  }

  Future<String> uploadImageToStorage(File imageFile, String storageId) async {
    final storageRef = FirebaseStorage.instance.ref().child(storageId);
    final uploadTask = storageRef.putFile(imageFile);
    return await uploadTask
        .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
  }

  Future<void> insertPost(Post post) async {
    await _db.collection("posts").doc(post.postId).set(post.toMap());
  }

  Future<List<Post>> getPostsMineAndFollowing(String userId) async {
    //データの有無を判定。（投稿データがないとアプリが落ちるissue対応)
    final query = await _db.collection("posts").get();
    if (query.docs.isEmpty) {
      return [];
    }

    var userIds = await getFollowingUserIds(userId);
    userIds.add(userId); //自分自身も追加

    // whereInは10個までしか結合できないため削除
    // await _db
    //     .collection("posts")
    //     .where("userId", whereIn: userIds)
    //     .orderBy("postDateTime", descending: true)
    //     .get()
    //     .then((value) {
    //   //value=DocumentSnapShot
    //   for (var element in value.docs) {
    //     //elementはmap型
    //     results.add(Post.fromMap(element.data())); //fromMapでPostに変換
    //   }
    // });

    // whereInは10個までしか結合できないため、10個ごとにリスト化。
    // quiotient:商 remainder:あまり
    final quotient = userIds.length ~/ 10;
    final remainder = userIds.length % 10;
    final numberOfChunks = (remainder == 0) ? quotient : quotient + 1;

    var userIdChunks = <List<String>>[];
    if (quotient == 0) {
      userIdChunks.add(userIds);
    } else if (quotient == 1) {
      userIdChunks.add(userIds.sublist(0, 10));
      userIdChunks.add(userIds.sublist(10, 10 + remainder));
    } else {
      for (int i = 0; i <= numberOfChunks - 1; i++) {
        userIdChunks.add(userIds.sublist(i * 10, i * 10 + 10));
      }
      userIdChunks.add(userIds.sublist(
          (numberOfChunks - 1) * 10, (numberOfChunks - 1) * 10 + remainder));
    }

    var results = <Post>[];
    await Future.forEach(userIdChunks, (List<String> userIdList) async {
      final tempPosts = await getPostsOfChunkedUsers(userIdList);
      for (var post in tempPosts) {
        results.add(post);
      }
    });
    //print("post:$results");
    return results;
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    return [];
  }

  Future<List<String>> getFollowingUserIds(String userId) async {
    final query = await _db
        .collection("users")
        .doc(userId)
        .collection("followings")
        .get();
    if (query.docs.isEmpty) {
      return [];
    }
    var userIds = <String>[];
    for (var id in query.docs) {
      userIds.add(id.data()["userId"]);
    }
    return userIds;
  }

  Future<List<Post>> getPostsOfChunkedUsers(List<String> userIds) async {
    var results = <Post>[];
    await _db
        .collection("posts")
        .where("userId", whereIn: userIds)
        .orderBy("postDateTime", descending: true)
        .get()
        .then((value) {
      //value=DocumentSnapShot
      for (var element in value.docs) {
        //elementはmap型
        results.add(Post.fromMap(element.data())); //fromMapでPostに変換
      }
    });
    return results;
  }
}
