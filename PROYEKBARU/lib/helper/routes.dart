import 'package:flutter/material.dart';
import 'package:findes3/page/Auth/selectAuthMethod.dart';
import 'package:findes3/page/common/usersudahlogin.dart';
import 'package:findes3/page/feed/tambahPorto/tambahPortoPage.dart';
import 'package:findes3/page/feed/tambahPorto/state/tambahPortoState.dart';
import 'package:findes3/page/message/conversationInformation/conversationInformation.dart';
import 'package:findes3/page/profile/profileImageView.dart';
import 'package:findes3/page/search/SearchPage.dart';
import 'package:provider/provider.dart';
import '../page/Auth/signin.dart';
import '../helper/customRoute.dart';
import '../page/Auth/signup.dart';
import '../page/feed/detailPortofolioPage.dart';
import '../page/profile/EditProfilePage.dart';
import '../page/profile/profilePage.dart';
import '../widgets/icondll.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }

  static void sendNavigationEventToFirebase(String path) {
    if (path != null && path.isNotEmpty) {}
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "TambahPortoPage":
        bool isPorto = false;
        if (pathElements.length == 3 && pathElements[2].contains('Porto')) {
          isPorto = true;
        }

        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<TambahPortoState>(
                  create: (_) => TambahPortoState(),
                  child: TambahPortoPage(isPorto: isPorto),
                ));
      case "FeedPostDetail":
        var postId = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => FeedPostDetail(
                  postId: postId,
                ),
            settings: RouteSettings(name: 'FeedPostDetail'));
      case "ProfilePage":
        String profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2];
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) => ProfilePage(
                  profileId: profileId,
                ));
      case "TambahPortoPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<TambahPortoState>(
                  create: (_) => TambahPortoState(),
                  child: TambahPortoPage(isPorto2: false, isPorto: true),
                ));
      case "WelcomePage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => WelcomePage());
      case "SignIn":
        return CustomRoute<bool>(builder: (BuildContext context) => SignIn());
      case "SignUp":
        return CustomRoute<bool>(builder: (BuildContext context) => Signup());
      /*case "ForgetPasswordPage":*/
      /*return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ForgetPasswordPage()); //BELON FIX*/
      case "SearchPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => SearchPage());
      case "EditProfile":
        return CustomRoute<bool>(
            builder: (BuildContext context) => EditProfilePage());
      case "ProfileImageView":
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => ProfileImageView());

      /*case "ConversationInformation":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ChatInformation(),
        );*/

      default:
        return onUnknownRoute(RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: customTitleText(settings.name.split('/')[1]),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}
