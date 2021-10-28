import 'package:flutter/material.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/functions.dart';
import 'package:insta_clone/view/common/components/circle_photo.dart';
import 'package:insta_clone/view/common/components/common_rich_text.dart';

class CommentDisplayPart extends StatelessWidget {
  final String postUserPhotoUrl;
  final String name;
  final String text;
  final DateTime postDateTime;
  final GestureLongPressCallback? onLongPressed;

  CommentDisplayPart({
    required this.postUserPhotoUrl,
    required this.name,
    required this.text,
    required this.postDateTime,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CirclePhoto(
          photoUrl: postUserPhotoUrl,
          isImageFromFile: false,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonRichText(
                name: name,
                text: text,
              ),
              Text(
                createTimeAgoString(postDateTime),
                style: timeAgoTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
