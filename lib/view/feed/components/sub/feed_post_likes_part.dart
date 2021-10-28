import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/view/comments/screens/comment_screen.dart';

class FeedPostLikesPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostLikesPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: null, //TODO
                icon: FaIcon(FontAwesomeIcons.solidHeart),
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
}
