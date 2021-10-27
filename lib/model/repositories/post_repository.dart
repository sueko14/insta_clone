import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/data_models/location.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/db/database_manager.dart';
import 'package:insta_clone/model/location/location_manager.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final DatabaseManager dbManager;
  final LocationManager locationManager;

  PostRepository({required this.dbManager, required this.locationManager});

  Future<File?> pickImage(UploadType uploadType) async {
    final imagePicker = ImagePicker();

    if (uploadType == UploadType.GALLERY) {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    } else {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      return (pickedImage != null) ? File(pickedImage.path) : null;
    }
  }

  Future<Location> getCurrentLocation() async {
    return await locationManager.getCurrentLocation();
  }

  Future<Location> updateLocation(double latitude, double longitude) async {
    return await locationManager.updateLocation(latitude, longitude);
  }

  // 画像はcloud storageにアップロードする。
  // postsのドキュメントには、imageStoragePathをもたせるようにする。
  Future<void> post(User currentUser, File imageFile, String caption,
      Location? location, String locationString) async {
    final storageId = const Uuid().v1();
    final imageUrl = await dbManager.uploadImageToStorage(imageFile, storageId);
    final post = Post(
      postId: Uuid().v1(),
      userId: currentUser.userId,
      imageUrl: imageUrl,
      imageStoragePath: storageId,
      caption: caption,
      locationString: locationString,
      latitude: (location != null) ? location.latitude : 0.0,
      longitude: (location != null) ? location.longitude : 0.0,
      postDateTime: DateTime.now(),
    );
    await dbManager.insertPost(post);
  }

  Future<List<Post>> getPosts(FeedMode feedMode, User feedUser) async{
    if(feedMode == FeedMode.FROM_FEED){
      //TODO 自分＋フォローしてる人
      return dbManager.getPostsMineAndFollowing(feedUser.userId);
    }else{
      //TODO プロフィール画面に表示しているユーザーの投稿（必ずしも自分とは限らない）
      //return dbManager.getPostsByUser(feedUser.userId);
      return [];
    }
  }
}
