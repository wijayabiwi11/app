import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/state/cariState.dart';
import 'package:findes3/state/cariState2.dart';
import 'helper/routes.dart';
import 'state/appState.dart';
import 'package:provider/provider.dart';
import 'state/authState.dart';
import 'state/chats/chatState.dart';
import 'state/discoverState.dart';
import 'package:google_fonts/google_fonts.dart';

import 'state/notifState.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<FeedState>(create: (_) => FeedState()),
        ChangeNotifierProvider<ChatState>(create: (_) => ChatState()),
        ChangeNotifierProvider<SearchState>(create: (_) => SearchState()),
        ChangeNotifierProvider<SearchFeedState>(
            create: (_) => SearchFeedState()),
        ChangeNotifierProvider<NotificationState>(
            create: (_) => NotificationState()),
      ],
      child: MaterialApp(
        title: 'Findes',
        theme: AppTheme.apptheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: "SplashPage",
      ),
    );
  }
}
