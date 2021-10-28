import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/post.dart';
import 'package:insta_clone/generated/l10n.dart';

class CommentScreen extends StatelessWidget {
  final Post post;
  CommentScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).comments),
      ),
      body: Container(
        child: Center(
          child: Text(post.caption),
        ),
      ),
    );
  }
}
