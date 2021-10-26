import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/data_models/location.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/style.dart';
import 'package:insta_clone/view/post/screens/map_screen.dart';
import 'package:insta_clone/view_model/post_view_model.dart';
import 'package:provider/provider.dart';

class PostLocationPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postViewModel = context.watch<PostViewModel>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          postViewModel.locationString,
          style: postLocationTextStyle,
        ),
        subtitle: _latLngPart(postViewModel.location, context),
        trailing: IconButton(
          icon: const FaIcon(FontAwesomeIcons.mapMarkerAlt),
          onPressed: () {
            _openMapScreen(context, postViewModel.location);
          },
        ),
      ),
    );
  }

  _latLngPart(Location? location, BuildContext context) {
    const spaceWidth = 8.0;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Chip(label: Text(S.of(context).latitude)),
        const SizedBox(width: spaceWidth),
        Text(
            (location != null) ? location.latitude.toStringAsFixed(2) : "0.00"),
        const SizedBox(width: spaceWidth),
        Chip(label: Text(S.of(context).longitude)),
        const SizedBox(width: spaceWidth),
        Text((location != null)
            ? location.longitude.toStringAsFixed(2)
            : "0.00"),
      ],
    );
  }

  void _openMapScreen(BuildContext context, Location? location) {
    if (location == null) {
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(location: location),
      ),
    );
  }
}
