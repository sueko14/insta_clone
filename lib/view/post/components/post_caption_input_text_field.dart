import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionInputTextField extends StatefulWidget {
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
    });
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

  _onCaptionUpdated(BuildContext context) {
    final viewModel = context.read<PostViewModel>();
    viewModel.caption = _captionController.text;
    //print("caption: ${viewModel.caption}");
  }
}
