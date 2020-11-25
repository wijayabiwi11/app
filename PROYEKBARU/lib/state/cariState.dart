import 'package:firebase_database/firebase_database.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import '../model/portoModel.dart';
import 'appState.dart';
import 'package:findes3/model/portoModel.dart';

class SearchFeedState extends AppState {
  bool isBusy = false;

  List<FeedModel> _feedFilterlist;
  List<FeedModel> _feedlist;

  List<FeedModel> get feedlist {
    print("Filtered");
    print(_feedFilterlist);
    if (_feedFilterlist == null) {
      return null;
    } else {
      return List.from(_feedFilterlist);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      kDatabase.child('porto').once().then(
        (DataSnapshot snapshot) {
          print("tambah");
          print(snapshot.value);
          _feedlist = List<FeedModel>();
          _feedFilterlist = List<FeedModel>();
          if (snapshot.value != null) {
            var map = snapshot.value;
            if (map != null) {
              map.forEach((key, value) {
                var model = FeedModel.fromJson(value);
                model.key = key;
                _feedlist.add(model);
                _feedFilterlist.add(model);
              });
              _feedFilterlist.sort((x, y) => DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt)));
            }
          } else {
            _feedlist = null;
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
    if (_feedlist != null && _feedlist.length != _feedFilterlist.length) {
      _feedFilterlist = List.from(_feedlist);
      _feedFilterlist.sort((y, x) =>
          DateTime.parse(y.createdAt).compareTo(DateTime.parse(x.createdAt)));
      notifyListeners();
    }
  }

  void filterByfeed(String name) {
    if (name.isEmpty &&
        _feedlist != null &&
        _feedlist.length != _feedFilterlist.length) {
      _feedFilterlist = List.from(_feedlist);
    }

    if (_feedlist == null && _feedlist.isEmpty) {
      print("Empty");
      return;
    } else if (name != null) {
      _feedFilterlist = _feedlist
          .where((x) =>
              x.description3 != null &&
              x.description3.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
