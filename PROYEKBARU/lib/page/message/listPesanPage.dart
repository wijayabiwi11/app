import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/chatModel.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/chats/chatState.dart';
import 'package:findes3/state/cariState2.dart';
import 'package:findes3/widgets/AppBar.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/emptyList.dart';
import 'package:findes3/widgets/Widgetbarubaru2/rippleButton.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';

class ChatListPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  const ChatListPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  void initState() {
    final chatState = Provider.of<ChatState>(context, listen: false);
    final state = Provider.of<AuthState>(context, listen: false);
    chatState.setIsChatScreenOpen = true;

    chatState.getUserchatList(state.user.uid);
    super.initState();
  }

  Widget _body() {
    final state = Provider.of<ChatState>(context);
    final searchState = Provider.of<SearchState>(context, listen: false);
    if (state.chatUserList == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'Coming Soon ',
          subTitle: '',
        ),
      );
    } else {
      if (searchState.userList.isEmpty) {
        searchState.resetFilterList();
      }
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemCount: state.chatUserList.length,
        itemBuilder: (context, index) => _userCard(
            searchState.userlist.firstWhere(
              (x) => x.userId == state.chatUserList[index].key,
              orElse: () => User(userName: "Unknown"),
            ),
            state.chatUserList[index]),
        separatorBuilder: (context, index) {
          return Divider(
            height: 0,
          );
        },
      );
    }
  }

  Widget _userCard(User model, ChatMessage lastMessage) {
    return Container(
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        onTap: () {
          final chatState = Provider.of<ChatState>(context, listen: false);
          final searchState = Provider.of<SearchState>(context, listen: false);
          chatState.setChatUser = model;
          if (searchState.userlist.any((x) => x.userId == model.userId)) {
            chatState.setChatUser = searchState.userlist
                .where((x) => x.userId == model.userId)
                .first;
          }
          Navigator.pushNamed(context, '/ChatScreenPage');
        },
        leading: RippleButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/ProfilePage/${model.userId}');
          },
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(28),
              image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    model.profilePic ?? dummyProfilePic,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        title: TitleText(
          model.displayName ?? "NA",
          fontSize: 16,
          fontWeight: FontWeight.w800,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: customText(
          getLastMessage(lastMessage.pesan) ?? '@${model.displayName}',
          style: onPrimarySubTitleText.copyWith(color: Colors.black54),
        ),
        trailing: lastMessage == null
            ? SizedBox.shrink()
            : Text(
                getChatTime(lastMessage.createdAt).toString(),
              ),
      ),
    );
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/DirectMessagesPage');
  }

  String getLastMessage(String message) {
    if (message != null && message.isNotEmpty) {
      if (message.length > 100) {
        message = message.substring(0, 80) + '...';
        return message;
      } else {
        return message;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        title: customTitleText(
          'Chats',
        ),
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
      ),
      backgroundColor: AplikasiColor.mystic,
      body: _body(),
    );
  }
}
