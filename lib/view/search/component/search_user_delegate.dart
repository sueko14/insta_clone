import 'package:flutter/material.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/view/common/components/user_card.dart';
import 'package:insta_clone/view_model/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchUserDelegate extends SearchDelegate<User?> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      brightness: Brightness.dark,
    );
  }

  // AppBarのleadingと同じ
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        print("no result");
        close(context, null);
      },
    );
  }

  // AppBarのアクション属性と同じ
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          // 検索候補を消すということをやりたい。
          // SearchDelegateのqueryはqueryTextController.textにアクセスできるので
          // 以下の文で検索文字を消す
          query = "";
        },
      ),
    ];
  }

  // ユーザーが検索ワードを売っている途中で候補を表示させる
  @override
  Widget buildSuggestions(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();
    searchViewModel.searchUsers(query);
    return _buildResults(context);
  }

  // 検索ワードの入力を完了した上で検索結果を表示
  @override
  Widget buildResults(BuildContext context) {
    final searchViewModel = context.read<SearchViewModel>();
    searchViewModel.searchUsers(query);
    return _buildResults(context);
  }

  //ユーザー検索処理
  Widget _buildResults(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (context, model, child) {
        return ListView.builder(
          itemCount: model.searchedUsers.length,
          itemBuilder: (context, int index) {
            final user = model.searchedUsers[index];
            return UserCard(
              photoUrl: user.photoUrl,
              title: user.inAppUserName,
              subTitle: user.bio,
              onTap: (){
                close(context, user);
              },
            );
          },
        );
      },
    );
  }
}
