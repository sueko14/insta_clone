import 'package:flutter/material.dart';

const TitleFont = "Billabong";
const RegularFont = "NotoSansJP-Medium";
const BoldFont = "NotoSansJP-Bold";

// THEME
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  //buttonColor: Colors.white30,
  //ElevatedButtonの色はbuttonColor属性では変更できないのでelevatedButtonTheme属性を使用
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.white30,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  fontFamily: RegularFont,
);

final lightTheme = ThemeData(
  primaryColor: Colors.white,
  brightness: Brightness.light,
  //buttonColor: Colors.white,
  //ElevatedButtonの色はbuttonColor属性では変更できないのでelevatedButtonTheme属性を使用
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.white,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.black,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  fontFamily: RegularFont,
);


// LOGIN
const loginTitleTextStyle = TextStyle(
  fontFamily: TitleFont,
  fontSize: 48.0,
);

// POST
const postCaptionTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 14.0,
);
const postLocationTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 16.0,
);

// FEED
const userCardTitleTextStyle = TextStyle(
  fontFamily: BoldFont,
  fontSize: 14.0,
);
const userCardSubTitleTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 12.0,
);

const numberOfLikesTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 14.0,
);
const numberOfCommentsTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 12.0,
  color: Colors.grey,
);
const timeAgoTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 10.0,
  color: Colors.grey,
);
const commentNameTextStyle = TextStyle(
  fontFamily: BoldFont,
  fontSize: 13.0,
);
const commentContentTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 13.0,
);

// COMMENT
const commentInputTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 14.0,
);

// PROFILE
const profileRecordScoreTextStyle = TextStyle(
  fontFamily: BoldFont,
  fontSize: 20.0,
);

const profileRecordTitleTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 14.0,
);

const changeProfilePhotoTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 18.0,
  color: Colors.blueAccent,
);

const editProfileTitleTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 14.0,
  color: Colors.white54,
);

const profileBioTextStyle = TextStyle(
  fontFamily: RegularFont,
  fontSize: 13.0,
);

//SEARCH
const searchPageAppBarTitleTextStyle = TextStyle(
  fontFamily: RegularFont,
  color: Colors.grey,
);
