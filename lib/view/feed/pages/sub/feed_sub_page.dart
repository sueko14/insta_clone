import 'package:flutter/material.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/feed/components/feed_post_tile.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:provider/provider.dart';

class FeedSubPage extends StatelessWidget {
  final FeedMode feedMode;

  FeedSubPage({required this.feedMode});

  @override
  Widget build(BuildContext context) {
    final feedViewModel = context.read<FeedViewModel>();

    // TODO プロフィール画面から来た場合はUserの設定をする。
    feedViewModel.setFeedUser(feedMode, null);
    Future(() => feedViewModel.getPosts(feedMode));

    return Consumer<FeedViewModel>(builder: (context, model, child) {
      if (model.isProcessing) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return RefreshIndicator(
          onRefresh: () => model.getPosts(feedMode),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: model.posts.length,
            itemBuilder: (context, index) {
              return FeedPostTile(
                feedMode: feedMode,
                post: model.posts[index],
              );
            },
          ),
        );
      }
    });
  }
}
