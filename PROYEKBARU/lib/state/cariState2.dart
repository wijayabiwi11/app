import 'package:firebase_database/firebase_database.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'appState.dart';
import 'package:findes3/model/portoModel.dart';

class SearchState extends AppState {
  bool isBusy = false;

  List<User> _userFilterlist;
  List<User> _userlist;

  List<User> get userlist {
    if (_userFilterlist == null) {
      return null;
    } else {
      return List.from(_userFilterlist);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      kDatabase.child('profile').once().then(
        (DataSnapshot snapshot) {
          _userlist = List<User>();
          _userFilterlist = List<User>();
          if (snapshot.value != null) {
            var map = snapshot.value;
            if (map != null) {
              map.forEach((key, value) {
                var model = User.fromJson(value);
                model.key = key;
                _userlist.add(model);
                _userFilterlist.add(model);
              });
            }
          } else {
            _userlist = null;
          }
          isBusy = false;
        },
      );
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  void resetFilterList() {
    if (_userlist != null && _userlist.length != _userFilterlist.length) {
      _userFilterlist = List.from(_userlist);
      notifyListeners();
    }
  }

  void filterByUsername(String name) {
    if (name.isEmpty &&
        _userlist != null &&
        _userlist.length != _userFilterlist.length) {
      _userFilterlist = List.from(_userlist);
    }

    if (_userlist == null && _userlist.isEmpty) {
      print("Empty userList");
      return;
    } else if (name != null) {
      _userFilterlist = _userlist
          .where((x) =>
              x.userName != null &&
              x.userName.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<User> userList = [];
  List<User> getuserDetail(List<String> userIds) {
    final list = _userlist.where((x) {
      if (userIds.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }
}
