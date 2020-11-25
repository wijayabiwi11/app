import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:findes3/helper/enum.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:findes3/model/chatModel.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/appState.dart';

class ChatState extends AppState {
  bool setIsChatScreenOpen;

  List<ChatMessage> _messageList;
  List<ChatMessage> _chatUserList;
  User _chatUser;
  String serverToken = "<FCM SERVER KEY>";

  User get chatUser => _chatUser;
  set setChatUser(User model) {
    _chatUser = model;
  }

  String _channelName;
  Query messageQuery;

  List<ChatMessage> get messageList {
    if (_messageList == null) {
      return null;
    } else {
      _messageList.sort((x, y) => DateTime.parse(y.createdAt)
          .toLocal()
          .compareTo(DateTime.parse(x.createdAt).toLocal()));
      return _messageList;
    }
  }

  List<ChatMessage> get chatUserList {
    if (_chatUserList == null) {
      return null;
    } else {
      return List.from(_chatUserList);
    }
  }

  void databaseInit(String userId, String myId) async {
    _messageList = null;
    if (_channelName == null) {
      getChannelName(userId, myId);
    }
    kDatabase
        .child("chatUsers")
        .child(myId)
        .onChildAdded
        .listen(_onChatUserAdded);
    if (messageQuery == null || _channelName != getChannelName(userId, myId)) {
      messageQuery = kDatabase.child("chats").child(_channelName);
      messageQuery.onChildAdded.listen(_onMessageAdded);
      messageQuery.onChildChanged.listen(_onMessageChanged);
    }
  }

  void getFCMServerKey() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(days: 5));
    await remoteConfig.activateFetched();
    var data = remoteConfig.getString('FcmServerKey');
    if (data != null && data.isNotEmpty) {
      serverToken = jsonDecode(data)["key"];
    } else {
      cprint("Please configure Remote config in firebase",
          errorIn: "getFCMServerKey");
    }
  }

  void getUserchatList(String userId) {
    try {
      kDatabase
          .child('chatUsers')
          .child(userId)
          .once()
          .then((DataSnapshot snapshot) {
        _chatUserList = List<ChatMessage>();
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {});
          }
          _chatUserList.sort((x, y) {
            if (x.createdAt != null && y.createdAt != null) {
              return DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt));
            } else {
              if (x.createdAt != null) {
                return 0;
              } else {
                return 1;
              }
            }
          });
        } else {
          _chatUserList = null;
        }
        notifyListeners();
      });
    } catch (error) {
      cprint(error);
    }
  }

  void getchatDetailAsync() async {
    try {
      kDatabase
          .child('chats')
          .child(_channelName)
          .once()
          .then((DataSnapshot snapshot) {
        _messageList = List<ChatMessage>();
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {});
          }
        } else {
          _messageList = null;
        }
        notifyListeners();
      });
    } catch (error) {
      cprint(error);
    }
  }

  void onMessageSubmitted(ChatMessage message, {User myUser, User secondUser}) {
    print(chatUser.userId);
    try {
      // if (_messageList == null || _messageList.length < 1) {
      kDatabase
          .child('chatUsers')
          .child(message.pengirimId)
          .child(message.receiverId);

      kDatabase
          .child('chatUsers')
          .child(chatUser.userId)
          .child(message.pengirimId);

      kDatabase.child('chats').child(_channelName).push().set;
      sendAndRetrieveMessage(message);
      logEvent('send_message');
    } catch (error) {
      cprint(error);
    }
  }

  String getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';

    return _channelName;
  }

  void _onMessageAdded(Event event) {
    if (_messageList == null) {
      _messageList = List<ChatMessage>();
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {}
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void _onMessageChanged(Event event) {
    if (_messageList == null) {
      _messageList = List<ChatMessage>();
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {}
    } else {
      _messageList = null;
    }
    notifyListeners();
  }

  void _onChatUserAdded(Event event) {
    if (_chatUserList == null) {
      _chatUserList = List<ChatMessage>();
    }
    if (event.snapshot.value != null) {
      var map = event.snapshot.value;
      if (map != null) {}
    } else {
      _chatUserList = null;
    }
    notifyListeners();
  }

  void dispose() {
    var user = _chatUserList.firstWhere((x) => x.key == chatUser.userId);
    if (_messageList != null) {
      user.pesan = _messageList.first.pesan;
      user.createdAt = _messageList.first.createdAt; //;
      _messageList = null;
      notifyListeners();
    }
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  void sendAndRetrieveMessage(ChatMessage model) async {
    /// on noti
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );
    if (chatUser.fcmToken == null) {
      return;
    }

    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': model.pesan,
        'title': "Message from ${model.namaPengirim}"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": TipeNotif.Message.toString(),
        "senderId": model.pengirimId,
        "receiverId": model.receiverId,
        "title": "title",
        "body": model.pesan,
        "portoId": ""
      },
      'to': chatUser.fcmToken
    });
    var response = await http.post('https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: body);
    print(response.body.toString());
  }
}
