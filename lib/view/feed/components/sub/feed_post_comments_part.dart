import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/comment.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/functions.dart';
import 'package:insta_clone/view/comments/screens/comment_screen.dart';
import 'package:insta_clone/view/common/components/common_rich_text.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedPostCommentsPart extends StatelessWidget {
  final Post post;
  final User postUser;

  FeedPostCommentsPart({required this.post, required this.postUser});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //投稿者名とキャプション
          CommonRichText(
            name: postUser.inAppUserName,
            text: post.caption,
          ),
          InkWell(
            onTap: () => _openCommentScreen(
              context,
              post,
              postUser,
            ),
            child: FutureBuilder(
              future: feedViewModel.getComments(post.postId),
              builder: (context, AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final comments = snapshot.data!;
                  return Text(
                    comments.length.toString() + " " + S.of(context).comments,
                    style: numberOfCommentsTextStyle,
                  );
                } else {
                  return Text(
                    "0 ${S.of(context).comments}",
                    style: numberOfCommentsTextStyle,
                  );
                }
              },
            ),
          ),
          Text(
            createTimeAgoString(post.postDateTime),
            style: timeAgoTextStyle,
          ),
        ],
      ),
    );
  }

  _openCommentScreen(BuildContext context, Post post, User postUser) {
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
