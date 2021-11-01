import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:insta_clone/di/providers.dart';
import 'package:insta_clone/generated/l10n.dart';
import 'package:insta_clone/model/repositories/theme_change_repository.dart';
import 'package:insta_clone/view/home_screen.dart';
import 'package:insta_clone/view/login/screens/login_screen.dart';
import 'package:insta_clone/view_model/login_view_model.dart';
import 'package:insta_clone/view_model/theme_change_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final themeChangeRepository = ThemeChangeRepository();
  await themeChangeRepository.getIsDarkOn();

  timeAgo.setLocaleMessages("ja", timeAgo.JaMessages());
  runApp(
    MultiProvider(
      providers: globalProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();
    final themeChangeViewModel = Provider.of<ThemeChangeViewModel>(context);

    return MaterialApp(
      title: "Insta Clone",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: themeChangeViewModel.selectedTheme,
      // Consumer使わない理由：
      // Consumerは非同期処理の結果を待たずに描画をしてChangeNotifierの変更通知を受け取り描画をしなおす。
      // そのため、Consumerで実装する場合は、初期値をfalseとして代入するようなイメージになるが、そうすると
      // Screenごと表示するものが変わってしまうのでよくない。
      // 一方、FutureBuilderは非同期処理の結果が終わるまで描画をしない。ログイン状態を判断し終わるまで
      // 画面描画はどうするか待ったほうが良いので、ここではFutureBuilderを使う。
      home: FutureBuilder(
        future: loginViewModel.isSignedIn(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
