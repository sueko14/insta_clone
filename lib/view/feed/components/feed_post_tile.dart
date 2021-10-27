import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/feed/components/sub/feed_post_comments_part.dart';
import 'package:insta_clone/view/feed/components/sub/feed_post_header_part.dart';
import 'package:insta_clone/view/feed/components/sub/feed_post_likes_part.dart';
import 'package:insta_clone/view/feed/components/sub/image_from_url.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostTile extends StatelessWidget {
  final FeedMode feedMode;
  final Post post;

  FeedPostTile({required this.feedMode, required this.post});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder(
        future: feedViewModel.getPostUserInfo(post.userId),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final postUser = snapshot.data!;
            final currentUser = feedViewModel.currentUser;
            //print("postUser:$postUser");
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FeedPostHeaderPart(
                  postUser: postUser,
                  post: post,
                  currentUser: currentUser,
                ),
                ImageFromUrl(
                  imageUrl: post.imageUrl,
                ),
                FeedPostLikesPart(),
                FeedPostCommentsPart(
                  post: post,
                  postUser: postUser,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
