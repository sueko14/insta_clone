import 'package:flutter/material.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/post/components/hero_image.dart';
import 'package:insta_clone/view/post/components/post_caption_input_text_field.dart';
import 'package:insta_clone/view/post/screens/enlarge_image_screen.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class PostCaptionPart extends StatelessWidget {
  final PostCaptionOpenMode from;

  PostCaptionPart({required this.from});

  @override
  Widget build(BuildContext context) {
    final postViewModel = context.read<PostViewModel>();
    final image = (postViewModel.imageFile != null)
        ? Image.file(postViewModel.imageFile!)
        : Image.asset("assets/images/no_image.png");

    if (from == PostCaptionOpenMode.FROM_POST) {
      return ListTile(
        leading: HeroImage(
          image: image,
          onTap: () => _displayLargeImage(context, image),
        ),
        title: PostCaptionInputTextField(),
      );
    } else {
      // TODO
      return Container();
    }
  }

  _displayLargeImage(BuildContext context, Image image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnlargeImageScreen(image: image),
      ),
    );
  }
}
