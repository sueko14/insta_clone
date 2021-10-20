import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_clone/data_models/user.dart';
import 'package:insta_clone/model/db/database_manager.dart';

class UserRepository {
  final DatabaseManager dbManager;

  UserRepository({required this.dbManager});

  static User? currentUser;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isSignedIn() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    }
    return false;
  }

  Future<bool> signIn() async {
    try {
      GoogleSignInAccount? signInAccount = await _googleSignIn.signIn();
      if (signInAccount == null) {
        return false;
      }
      GoogleSignInAuthentication signInAuthentication =
          await signInAccount.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken,
      );

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      if (firebaseUser == null){
        return false;
      }
      //  DBに登録
      final isUserExistedInDb = await dbManager.searchUserInDb(firebaseUser);
      if(!isUserExistedInDb){
        await dbManager.insertUser(_convertToUser(firebaseUser));
      }
      currentUser = await dbManager.getUserInfoFromDbById(firebaseUser.uid);
      return true;
    } catch (error) {
      print("[ERROR!]sign in error : $error");
      // エラー処理
      return false;
    }
  }

  _convertToUser(auth.User firebaseUser) {
    return User(
      userId: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? "",
      inAppUserName: firebaseUser.displayName ?? "",
      photoUrl: firebaseUser.photoURL ?? "",
      email: firebaseUser.email ?? "",
      bio: "",
    );
  }
}
