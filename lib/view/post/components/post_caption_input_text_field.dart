import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view_model/feed_view_model.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionInputTextField extends StatefulWidget {
  final String? captionBeforeUpdated;
  final PostCaptionOpenMode? from;
  PostCaptionInputTextField({this.captionBeforeUpdated, this.from});

  @override
  _PostCaptionInputTextFieldState createState() =>
      _PostCaptionInputTextFieldState();
}

class _PostCaptionInputTextFieldState extends State<PostCaptionInputTextField> {
  final _captionController = TextEditingController();

  @override
  void initState() {
    _captionController.addListener(() {
      _onCaptionUpdated(context);
      //
    });
    if(widget.from == PostCaptionOpenMode.FROM_FEED){
      _captionController.text = widget.captionBeforeUpdated ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _captionController,
      style: postCaptionTextStyle,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      //複数行入力できるようにするために必要
      decoration: InputDecoration(
        hintText: S.of(context).inputCaption,
        border: InputBorder.none,
      ),
    );
  }

  // POSTから来た場合。PostViewModelで処理しないといけないからメソッドを切り出している。
  // FEEDから来た場合はFeedViewModelで処理するから別。
  _onCaptionUpdated(BuildContext context) {
    if(widget.from == PostCaptionOpenMode.FROM_FEED){
      final viewModel = context.read<FeedViewModel>();
      viewModel.caption = _captionController.text;
      //print("caption: ${viewModel.caption}");
    }else{
      final viewModel = context.read<PostViewModel>();
      viewModel.caption = _captionController.text;
      //print("caption: ${viewModel.caption}");
    }

  }
}
