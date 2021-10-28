import 'package:insta_clone/model/db/database_manager.dart';
import 'package:insta_clone/model/location/location_manager.dart';
import 'package:insta_clone/model/repositories/post_repository.dart';
import 'package:insta_clone/model/repositories/user_repository.dart';
import 'package:insta_clone/view_model/comment_view_model.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:insta_clone/view_model/login_view_model.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

List<SingleChildWidget> independentModels = [
  Provider<DatabaseManager>(
    create: (_) => DatabaseManager(),
  ),
  Provider<LocationManager>(
    create: (_) => LocationManager(),
  )
];

List<SingleChildWidget> dependentModels = [
  ProxyProvider<DatabaseManager, UserRepository>(
    update: (_, dbManager, repo) => UserRepository(dbManager: dbManager),
  ),
  ProxyProvider2<DatabaseManager, LocationManager, PostRepository>(
    update: (_, dbManager, locationManager, repo) => PostRepository(
      dbManager: dbManager,
      locationManager: locationManager,
    ),
  ),
];

List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider<LoginViewModel>(
    create: (context) => LoginViewModel(
      userRepository: context.read<UserRepository>(),
    ),
  ),
  ChangeNotifierProvider<PostViewModel>(
    create: (context) => PostViewModel(
      userRepository: context.read<UserRepository>(),
      postRepository: context.read<PostRepository>(),
    ),
  ),
  ChangeNotifierProvider<FeedViewModel>(
    create: (context) => FeedViewModel(
      userRepository: context.read<UserRepository>(),
      postRepository: context.read<PostRepository>(),
    ),
  ),
  ChangeNotifierProvider<CommentViewModel>(
    create: (context) => CommentViewModel(
      userRepository: context.read<UserRepository>(),
      postRepository: context.read<PostRepository>(),
    ),
  ),
];
