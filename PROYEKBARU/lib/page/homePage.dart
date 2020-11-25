import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/page/feed/portofolioPage.dart';
import 'package:findes3/page/message/listPesanPage.dart';
import 'package:findes3/page/profile/profileImageView.dart';
import 'package:findes3/page/profile/profilePage.dart';
import 'package:findes3/state/appState.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/chats/chatState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/state/notifState.dart';
import 'package:findes3/state/cariState.dart';
import 'package:findes3/state/cariState2.dart';
import 'package:findes3/widgets/bottomMenuBar/bottomMenuBar.dart';
import 'package:provider/provider.dart';
import 'common/sidebar.dart';
import 'notification/notifikasiPage.dart';
import 'search/SearchPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<AppState>(context, listen: false);
      state.setpageIndex = 0;
      initPortos();
      initProfile();
      initSearch();
      initSearchFeed();
      initNotificaiton();
      initChat();
    });

    super.initState();
  }

  void initPortos() {
    var state = Provider.of<FeedState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initSearchFeed() {
    var searchFeedState = Provider.of<SearchFeedState>(context, listen: false);
    searchFeedState.getDataFromDatabase();
  }

  void initNotificaiton() {
    var state = Provider.of<NotificationState>(context, listen: false);
    var authstate = Provider.of<AuthState>(context, listen: false);
    state.databaseInit(authstate.userId);
    state.initfirebaseService();
  }

  void initChat() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.databaseInit(state.userId, state.userId);

    state.updateFCMToken();

    chatState.getFCMServerKey();
  }

  void _checkNotification() {
    final authstate = Provider.of<AuthState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<NotificationState>(context);

      if (state.notificationType == TipeNotif.Message &&
          state.notificationReciverId == authstate.userModel.userId) {
        state.setNotificationType = null;
        state.getuserDetail(state.notificationSenderId).then((user) {
          cprint("Opening user chat screen");
          final chatState = Provider.of<ChatState>(context, listen: false);
          chatState.setChatUser = user;
          Navigator.pushNamed(context, '/ChatScreenPage');
        });
      }
    });
  }

  Widget _body() {
    _checkNotification();

    return Container(
      child: _getPage(Provider.of<AppState>(context).pageIndex),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return PortofolioPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );

        break;
      case 1:
        return SearchPage(
          scaffoldKey: _scaffoldKey,
          refreshIndicatorKey: refreshIndicatorKey,
        );
        break;
      case 2:
        return ChatListPage(scaffoldKey: _scaffoldKey);

        break;
      case 3:
        return NotificationPage(scaffoldKey: _scaffoldKey);
        break;

      default:
        return PortofolioPage(
            scaffoldKey: _scaffoldKey,
            refreshIndicatorKey: refreshIndicatorKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      key: _scaffoldKey,
      bottomNavigationBar: BottomMenubar(),
      floatingActionButton: _floatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: SidebarMenu(),
      body: _body(),
    );
  }
}

Widget _floatingActionButton(BuildContext context) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.of(context).pushNamed('/TambahPortoPage/');
    },
    child: Icon(
      Icons.iconplus1,
      size: 25,
    ),
  );
}
