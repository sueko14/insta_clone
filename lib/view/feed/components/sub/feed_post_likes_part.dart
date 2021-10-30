import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/data_models/like.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/view/comments/screens/comment_screen.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikesPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: FutureBuilder(
        future: feedViewModel.getLikeResult(post.postId),
        builder: (context, AsyncSnapshot<LikeResult> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final likeResult = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    likeResult.isLikedToThisPost ?
                    IconButton(
                      onPressed: () => _unLikeIt(context),
                      icon: const FaIcon(FontAwesomeIcons.solidHeart),
                    ) :
                    IconButton(
                      onPressed: () => _likeIt(context),
                      icon: const FaIcon(FontAwesomeIcons.heart),
                    ),
                    IconButton(
                      onPressed: () => _openCommentScreen(context),
                      icon: const FaIcon(FontAwesomeIcons.comment),
                    ),
                  ],
                ),
                Text(
                  likeResult.likes.length.toString() +
                      " " +
                      S.of(context).likes,
                  style: numberOfLikesTextStyle,
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => _likeIt(context),
                      icon: const FaIcon(FontAwesomeIcons.solidHeart),
                    ),
                    IconButton(
                      onPressed: () => _openCommentScreen(context),
                      icon: const FaIcon(FontAwesomeIcons.comment),
                    ),
                  ],
                ),
                Text(
                  "0 ${S.of(context).likes}",
                  style: numberOfLikesTextStyle,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  _openCommentScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreen(
          post: post,
          postUser: postUser,
        ),
      ),
    );
  }

  _likeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.likeIt(post);
  }

  _unLikeIt(BuildContext context) async {
    final feedViewModel = context.read<FeedViewModel>();
    await feedViewModel.unLikeIt(post);
  }
}
