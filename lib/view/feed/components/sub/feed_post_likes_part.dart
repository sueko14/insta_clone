import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';

class FeedPostLikesPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              IconButton(
                onPressed: null, //TODO
                icon: FaIcon(FontAwesomeIcons.solidHeart),
              ),
              IconButton(
                onPressed: null, //TODO
                icon: FaIcon(FontAwesomeIcons.comment),
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
}
