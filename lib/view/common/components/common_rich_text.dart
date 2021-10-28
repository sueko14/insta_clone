import 'package:flutter/material.dart';
import 'package:insta_clone/style.dart';

class CommonRichText extends StatefulWidget {
  final String name;
  final String text;

  CommonRichText({required this.name, required this.text});

  @override
  _CommonRichTextState createState() => _CommonRichTextState();
}

class _CommonRichTextState extends State<CommonRichText> {
  int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          (_maxLines == 2) ? _maxLines = 1000 : _maxLines = 2;
        });
      },
      child: RichText(
        overflow: TextOverflow.ellipsis,
        maxLines: _maxLines,
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: widget.name, style: commentNameTextStyle),
              const TextSpan(
                text: " ",
              ),
              TextSpan(text: widget.text, style: commentContentTextStyle),
            ]),
      ),
    );
  }
}
