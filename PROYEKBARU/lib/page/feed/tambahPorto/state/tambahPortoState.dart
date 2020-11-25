import 'dart:convert';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/cariState2.dart';

class TambahPortoState extends ChangeNotifier {
  bool showUserList = false;
  bool enableSubmitButton = false;
  bool hideUserList = false;
  String description = "";
  String description2 = "";
  String description3 = "";
  String serverToken;
  final usernameRegex = r'(@\w*[a-zA-Z1-9]$)';

  bool _isScrollingDown = false;
  bool get isScrollingDown => _isScrollingDown;
  set setIsScrolllingDown(bool value) {
    _isScrollingDown = value;
    notifyListeners();
  }

  bool get displayUserList {
    RegExp regExp = new RegExp(usernameRegex);
    var status = regExp.hasMatch(description);
    if (status && !hideUserList) {
      return true;
    } else {
      return false;
    }
  }

  void onUserSelected() {
    hideUserList = true;
    notifyListeners();
  }

  void onDescriptionChanged(String text, SearchState searchState) {
    description = text;
    hideUserList = false;
    if (text.isEmpty || text.length > 50) {
      enableSubmitButton = false;
      notifyListeners();
      return;
    }

    enableSubmitButton = true;
    var last = text.substring(text.length - 1, text.length);

    RegExp regExp = new RegExp(usernameRegex);
    var status = regExp.hasMatch(text);
    if (status) {
      Iterable<Match> _matches = regExp.allMatches(text);
      var name = text.substring(_matches.last.start, _matches.last.end);

      if (last == "@") {
        searchState.filterByUsername("");
      } else {
        searchState.filterByUsername(name);
      }
    } else {
      hideUserList = false;
      notifyListeners();
    }
  }

  void onDescriptionChanged2(String text2, SearchState searchState) {
    description2 = text2;
    hideUserList = false;
    if (text2.isEmpty || text2.length > 500) {
      enableSubmitButton = false;
      notifyListeners();
      return;
    }

    enableSubmitButton = true;
    var last = text2.substring(text2.length - 1, text2.length);

    RegExp regExp = new RegExp(usernameRegex);
    var status = regExp.hasMatch(text2);
    if (status) {
      Iterable<Match> _matches = regExp.allMatches(text2);
      var name = text2.substring(_matches.last.start, _matches.last.end);

      if (last == "@") {
        searchState.filterByUsername("");
      } else {
        searchState.filterByUsername(name);
      }
    } else {
      hideUserList = false;
      notifyListeners();
    }
  }

  void onDescriptionChanged3(String text3, SearchState searchState) {
    description2 = text3;
    hideUserList = false;
    if (text3.isEmpty || text3.length > 100) {
      enableSubmitButton = false;
      notifyListeners();
      return;
    }

    enableSubmitButton = true;
    var last = text3.substring(text3.length - 1, text3.length);

    RegExp regExp = new RegExp(usernameRegex);
    var status = regExp.hasMatch(text3);
    if (status) {
      Iterable<Match> _matches = regExp.allMatches(text3);
      var name = text3.substring(_matches.last.start, _matches.last.end);

      if (last == "@") {
        /// Reset user list
        searchState.filterByUsername("");
      } else {
        searchState.filterByUsername(name);
      }
    } else {
      hideUserList = false;
      notifyListeners();
    }
  }

  String getDescription(String username) {
    RegExp regExp = new RegExp(usernameRegex);
    Iterable<Match> _matches = regExp.allMatches(description);
    var name = description.substring(0, _matches.last.start);
    description = '$name $username';
    return description;
  }

  Future<Null> getFCMServerKey() async {
    if (serverToken != null && serverToken.isNotEmpty) {
      return Future.value(null);
    }
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    var data = remoteConfig.getString('FcmServerKey');
    if (data != null) {
      serverToken = jsonDecode(data)["key"];
    }
  }

  Future<void> sendNotification(FeedModel model, SearchState state) async {
    final usernameRegex = r"(@\w*[a-zA-Z1-9])";
    RegExp regExp = new RegExp(usernameRegex);
    var status = regExp.hasMatch(description);

    if (status) {
      getFCMServerKey().then((val) async {
        state.filterByUsername("");

        Iterable<Match> _matches = regExp.allMatches(description);
        print("${_matches.length} name found in description");

        await Future.forEach(_matches, (Match match) async {
          var name = description.substring(match.start, match.end);
          if (state.userlist.any((x) => x.userName == name)) {
            final user = state.userlist.firstWhere((x) => x.userName == name);
            await sendNotificationToUser(model, user);
          } else {
            cprint("Name: $name ,", errorIn: "UserNot found");
          }
        });
      });
    }
  }

  Future<void> sendNotificationToUser(FeedModel model, User user) async {
    print("Send notification to: ${user.userName}");

    if (user.fcmToken == null) {
      return;
    }

    /// Create notification payload
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': model.description,
        'body2': model.description2,
        'body3': model.description3,
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": TipeNotif.Message2.toString(),
        "senderId": model.user.userId,
        "receiverId": user.userId,
        "title": "title",
        "body": "",
        "portoId": ""
      },
      'to': user.fcmToken
    });

    var response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: body,
    );
    cprint(response.body.toString());
  }
}
