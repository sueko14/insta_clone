import 'package:flutter/material.dart';

class HeroImage extends StatelessWidget {
  final Image image;
  final VoidCallback? onTap;

  HeroImage({required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "postImage",
      // InkWellは押されたときにMaterial widgetに描画情報を渡すため、
      // Material widgetを親に持たないといけない。
      child: Material(
        color: Colors.white30,
        child: InkWell(
          onTap: onTap,
          child: image,
        ),
      ),
    );
  }
}
