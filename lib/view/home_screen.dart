import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/utils/constants.dart';
import 'package:insta_clone/view/activities/pages/activity_page.dart';
import 'package:insta_clone/view/feed/pages/feed_page.dart';
import 'package:insta_clone/view/post/pages/post_page.dart';
import 'package:insta_clone/view/profile/page/profile_page.dart';
import 'package:insta_clone/view/search/pages/search_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pages = [];
  int _currentIndex = 0;

  @override
  void initState() {
    _pages = [
      const FeedPage(),
      const SearchPage(),
      const PostPage(),
      const ActivityPage(),
      ProfilePage(
        profileMode: ProfileMode.MYSELF,
        isOpenFromProfileScreen: false,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedFontSize: 0.0, //issue回避 https://github.com/flutter/flutter/issues/86545
        selectedFontSize: 0.0,
        //selectedItemColor: Colors.cyanAccent,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.home),
            label: S.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.search),
            label: S.of(context).search,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.plusSquare),
            label: S.of(context).post,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.heart),
            label: S.of(context).activities,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.user),
            label: S.of(context).profile,
          ),
        ],
      ),
    );
  }
}
