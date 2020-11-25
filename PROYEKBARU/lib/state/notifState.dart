import 'dart:async';
import 'package:findes3/helper/enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:findes3/helper/utility.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/model/notificationModel.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/appState.dart';

class NotificationState extends AppState {
  String fcmToken;
  TipeNotif _notificationType = TipeNotif.NOT_DETERMINED;
  String notificationReciverId, notificationPortoId;
  FeedModel notificationPortoModel;
  TipeNotif get notificationType => _notificationType;
  set setNotificationType(TipeNotif type) {
    _notificationType = type;
  }

  String notificationSenderId;
  dabase.Query query;
  List<User> userList = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<NotificationModel> _notificationList;

  List<NotificationModel> get notificationList => _notificationList;

  Future<bool> databaseInit(String userId) {
    try {
      if (query == null) {
        query = kDatabase.child("notification").child(userId);
        query.onChildAdded.listen(_onNotificationAdded);
        query.onChildChanged.listen(_onNotificationChanged);
        query.onChildRemoved.listen(_onNotificationRemoved);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  void getDataFromDatabase(String userId) {
    try {
      loading = true;
      _notificationList = [];
      kDatabase
          .child('notification')
          .child(userId)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((portoKey, value) {
              var model = NotificationModel.fromJson(
                  portoKey, value["updatedAt"], snapshot.value["type"]);
              _notificationList.add(model);
            });
            _notificationList.sort((x, y) {
              if (x.updatedAt != null && y.updatedAt != null) {
                return DateTime.parse(y.updatedAt)
                    .compareTo(DateTime.parse(x.updatedAt));
              } else if (x.updatedAt != null) {
                return 1;
              } else
                return 0;
            });
          }
        }
        loading = false;
      });
    } catch (error) {
      loading = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  Future<FeedModel> getPortoDetail(String portoKey) async {
    FeedModel _portoDetail;
    var snapshot = await kDatabase.child('porto').child(portoKey).once();
    if (snapshot.value != null) {
      var map = snapshot.value;
      _portoDetail = FeedModel.fromJson(map);
      _portoDetail.key = snapshot.key;
      return _portoDetail;
    } else {
      return null;
    }
  }

  Future<User> getuserDetail(String userId) async {
    User user;
    if (userList.length > 0 && userList.any((x) => x.userId == userId)) {
      return Future.value(userList.firstWhere((x) => x.userId == userId));
    }
    var snapshot = await kDatabase.child('profile').child(userId).once();
    if (snapshot.value != null) {
      var map = snapshot.value;
      user = User.fromJson(map);
      user.key = snapshot.key;
      userList.add(user);
      return user;
    } else {
      return null;
    }
  }

  void removeNotification(String userId, String portokey) async {
    kDatabase.child('notification').child(userId).child(portokey).remove();
  }

  void _onNotificationAdded(Event event) {
    if (event.snapshot.value != null) {
      var model = NotificationModel.fromJson(event.snapshot.key,
          event.snapshot.value["updatedAt"], event.snapshot.value["type"]);
      if (_notificationList == null) {
        _notificationList = List<NotificationModel>();
      }
      _notificationList.add(model);

      print("Notification added");
      notifyListeners();
    }
  }

  void _onNotificationChanged(Event event) {
    if (event.snapshot.value != null) {
      var model = NotificationModel.fromJson(event.snapshot.key,
          event.snapshot.value["updatedAt"], event.snapshot.value["type"]);

      _notificationList
          .firstWhere((x) => x.portoKey == model.portoKey)
          .portoKey = model.portoKey;
      notifyListeners();
      print("Notification changed");
    }
  }

  void _onNotificationRemoved(Event event) {
    if (event.snapshot.value != null) {
      var model = NotificationModel.fromJson(event.snapshot.key,
          event.snapshot.value["updatedAt"], event.snapshot.value["type"]);

      _notificationList.removeWhere((x) => x.portoKey == model.portoKey);
      notifyListeners();
      print("Notification Removed");
    }
  }

  void initfirebaseService() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message['data']);
        notifyListeners();
      },
      onLaunch: (Map<String, dynamic> message) async {
        cprint("Notification ", event: "onLaunch");
        var data = message['data'];

        notificationSenderId = data["senderId"];
        notificationReciverId = data["receiverId"];
        notificationReciverId = data["receiverId"];
        if (data["type"] == "NotificationType.Mention") {
          setNotificationType = TipeNotif.Message2;
        } else if (data["type"] == "NotificationType.Message") {
          setNotificationType = TipeNotif.Message;
        }
        notifyListeners();
      },
      onResume: (Map<String, dynamic> message) async {
        cprint("Notification ", event: "onResume");
        var data = message['data'];

        notificationSenderId = data["senderId"];
        notificationReciverId = data["receiverId"];
        if (data["type"] == "NotificationType.Mention") {
          setNotificationType = TipeNotif.Message2;
        } else if (data["type"] == "NotificationType.Message") {
          setNotificationType = TipeNotif.Message;
        }
        notifyListeners();
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      fcmToken = token;
      print(token);
    });
  }
}
