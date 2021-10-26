import 'package:flutter/material.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/common/dialog/confirm_dialog.dart';
import 'package:insta_clone/view/post/components/post_caption_part.dart';
import 'package:insta_clone/view/post/components/post_location_part.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class PostUploadScreen extends StatelessWidget {
  final UploadType uploadType;

  PostUploadScreen({required this.uploadType});

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();

    if (!postViewModel.isImagePicked && !postViewModel.isProcessing) {
      Future(() => postViewModel.pickImage(uploadType));
    }

    return Consumer<PostViewModel>(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              leading: model.isProcessing
                  ? Container()
                  : IconButton(
                      onPressed: () => _cancelPost(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
              title: model.isProcessing
                  ? Text(S.of(context).underProcessing)
                  : Text(S.of(context).post),
              actions: <Widget>[
                (model.isProcessing || !model.isImagePicked)
                    ? IconButton(
                        onPressed: () => _cancelPost(context),
                        icon: const Icon(Icons.close),
                      )
                    : IconButton(
                        onPressed: () => showConfirmDialog(
                          context: context,
                          title: S.of(context).post,
                          content: S.of(context).postConfirm,
                          onConfirmed: (isConfirmed){
                            if(isConfirmed){
                              _post(context);
                            }
                          },
                        ),
                        icon: const Icon(Icons.done),
                      ),
              ],
            ),
            body: model.isProcessing
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : model.isImagePicked
                    ? Column(
                        children: <Widget>[
                          const Divider(),
                          PostCaptionPart(from: PostCaptionOpenMode.FROM_POST),
                          const Divider(),
                          PostLocationPart(),
                          const Divider(),
                        ],
                      )
                    : Container());
      },
    );
  }

  _cancelPost(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();
    postViewModel.cancelPost();
    Navigator.pop(context);
  }

  void _post(BuildContext context) async {
    final postViewModel = context.read<PostViewModel>();
    await postViewModel.post();
    Navigator.pop(context);
  }
}
