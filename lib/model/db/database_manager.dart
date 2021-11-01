import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:insta_clone/data_models/comment.dart';
import 'package:insta_clone/data_models/like.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';

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
    final query = await _db.collection("posts").get();
    if (query.docs.isEmpty) {
      return [];
    }
    var results = <Post>[];
    await _db
        .collection("posts")
        .where("userId", isEqualTo: userId)
        .orderBy("postDateTime", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        results.add(Post.fromMap(element.data()));
      }
    });
    return results;
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

  Future<void> updatePost(Post updatePost) async {
    final reference = _db.collection("posts").doc(updatePost.postId);
    await reference.update(updatePost.toMap());
  }

  Future<void> postComment(Comment comment) async {
    await _db
        .collection("comments")
        .doc(comment.commentId)
        .set(comment.toMap());
  }

  Future<List<Comment>> getComments(String postId) async {
    final query = await _db.collection("comments").get();
    if (query.docs.isEmpty) {
      return [];
    }
    var results = <Comment>[];
    await _db
        .collection("comments")
        .where("postId", isEqualTo: postId)
        .orderBy("commentDateTime")
        .get()
        .then((value) {
      for (var element in value.docs) {
        results.add(Comment.fromMap(element.data()));
      }
    });
    return results;
  }

  Future<void> deleteComment(String deleteCommentId) async {
    final reference = _db.collection("comments").doc(deleteCommentId);
    await reference.delete();
  }

  Future<void> likeIt(Like like) async {
    await _db.collection("likes").doc(like.likeId).set(like.toMap());
  }

  Future<List<Like>> getLikes(String postId) async {
    final query = await _db.collection("likes").get();
    if (query.docs.isEmpty) {
      return [];
    }
    var results = <Like>[];
    await _db
        .collection("likes")
        .where("postId", isEqualTo: postId)
        .orderBy("likeDateTIme")
        .get()
        .then((value) {
      for (var element in value.docs) {
        results.add(Like.fromMap(element.data()));
      }
    });
    return results;
  }

  Future<void> unLikeIt(Post post, User currentUser) async {
    final likeRef = await _db
        .collection("likes")
        .where("postId", isEqualTo: post.postId)
        .where("likeUserId", isEqualTo: currentUser.userId)
        .get();
    for (var element in likeRef.docs) {
      final ref = _db.collection("likes").doc(element.id);
      await ref.delete();
    }
  }

  Future<void> deletePost(String postId, String imageStoragePath) async {
    //POST
    final postRef = _db.collection("posts").doc(postId);
    await postRef.delete();

    //COMMENT
    final commentRef = await _db
        .collection("comments")
        .where("postId", isEqualTo: postId)
        .get();
    for (var element in commentRef.docs) {
      final ref = _db.collection("comments").doc(element.id);
      await ref.delete();
    }
    //LIKE
    final likeRef =
        await _db.collection("likes").where("postId", isEqualTo: postId).get();
    for (var element in likeRef.docs) {
      final ref = _db.collection("likes").doc(element.id);
      await ref.delete();
    }
    //STORAGEから画像削除
    final storageRef = FirebaseStorage.instance.ref().child(imageStoragePath);
    storageRef.delete();
  }

  Future<List<String>> getFollowerUserIds(String userId) async {
    final query =
        await _db.collection("users").doc(userId).collection("followers").get();
    if (query.docs.isEmpty) {
      return [];
    }
    var userIds = <String>[];
    for (var element in query.docs) {
      userIds.add(element.data()["userId"]);
    }
    return userIds;
  }

  Future<void> updateProfile(User updateUser) async {
    final reference = _db.collection("users").doc(updateUser.userId);
    await reference.update(updateUser.toMap());
  }

  Future<List<User>> searchUsers(String queryString) async {
    final query = await _db
        .collection("users")
        .orderBy("inAppUserName")
        .startAt([queryString]).endAt(
            [queryString + "\uf8ff"]) //queryStringで始まる奴を
        .get();
    if (query.docs.isEmpty) {
      return [];
    }

    var searchedUsers = <User>[];
    for (var element in query.docs) {
      final selectedUser = User.fromMap(element.data());
      if (selectedUser.userId != UserRepository.currentUser?.userId) {
        searchedUsers.add(selectedUser);
      }
    }
    return searchedUsers;
  }

  Future<void> follow(User profileUser, User currentUser) async {
    //currentUserにとってのfollowing
    await _db
        .collection("users")
        .doc(currentUser.userId)
        .collection("followings")
        .doc(profileUser.userId)
        .set({"userId": profileUser.userId});

    //profileUserにとってのfollower
    await _db
        .collection("users")
        .doc(profileUser.userId)
        .collection("followers")
        .doc(currentUser.userId)
        .set({"userId": currentUser.userId});
  }

  Future<bool> checkIsFollowing(User profileUser, User currentUser) async {
    final query = await _db
        .collection("users")
        .doc(currentUser.userId)
        .collection("followings")
        .where("userId", isEqualTo: profileUser.userId)
        .get();
    if (query.docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> unFollow(User profileUser, User currentUser) async{
    //CurrentUserのfollowingからの削除
    await _db.collection("users").doc(currentUser.userId)
        .collection("followings").doc(profileUser.userId)
        .delete();

    //profileUserのfollowersからの削除
    await _db.collection("users").doc(profileUser.userId)
        .collection("followers").doc(currentUser.userId)
        .delete();
  }
}
