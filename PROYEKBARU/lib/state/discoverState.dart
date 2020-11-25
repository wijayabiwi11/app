import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/appState.dart';
import 'package:path/path.dart' as Path;
// import 'authState.dart';

class FeedState extends AppState {
  bool isBusy = false;
  Map<String, List<FeedModel>> portoReplyMap = {};
  FeedModel _portoportoModel;
  FeedModel get portoportoModel => _portoportoModel;
  set setPorto(FeedModel model) {
    _portoportoModel = model;
  }

  List<FeedModel> _feedlist;
  dabase.Query _feedQuery;
  List<FeedModel> _portoDetailModelList;

  List<FeedModel> get portoDetailModel => _portoDetailModelList;

  List<FeedModel> get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist.reversed);
    }
  }

  List<FeedModel> getPortoList(User userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel> list;

    if (!isBusy && feedlist != null && feedlist.isNotEmpty) {
      list = feedlist.where((x) {
        if (x.parentkey != null &&
            x.childRetwetkey == null &&
            x.user.userId != userModel.userId) {
          return false;
        }

        if (x.user.userId == userModel.userId) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  set setFeedModel(FeedModel model) {
    if (_portoDetailModelList == null) {
      _portoDetailModelList = [];
    }

    if (_portoDetailModelList.length >= 0) {
      _portoDetailModelList.add(model);
      cprint("Portoditambah. Total porto: ${_portoDetailModelList.length}");
      notifyListeners();
    }
  }

  void removeLastPortoDetail(String portoKey) {
    if (_portoDetailModelList != null && _portoDetailModelList.length > 0) {
      FeedModel removePorto =
          _portoDetailModelList.lastWhere((x) => x.key == portoKey);
      _portoDetailModelList.remove(removePorto);
      portoReplyMap.removeWhere((key, value) => key == portoKey);
      cprint("remov. Remaining : ${_portoDetailModelList.length}");
    }
  }

  void clearAllDetailAndReplyPortoStack() {
    if (_portoDetailModelList != null) {
      _portoDetailModelList.clear();
    }
    if (portoReplyMap != null) {
      portoReplyMap.clear();
    }
    cprint('Empty');
  }

  Future<bool> databaseInit() {
    try {
      if (_feedQuery == null) {
        _feedQuery = kDatabase.child("porto");
        _feedQuery.onChildAdded.listen(_onPortoAdded);
        _feedQuery.onValue.listen(_onPortoChanged);
        _feedQuery.onChildRemoved.listen(_onPortoRemoved);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
      kDatabase.child('porto').once().then((DataSnapshot snapshot) {
        _feedlist = List<FeedModel>();
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            map.forEach((key, value) {
              var model = FeedModel.fromJson(value);
              model.key = key;
              if (model.isValidPorto) {
                _feedlist.add(model);
              }
            });

            _feedlist.sort((x, y) => DateTime.parse(x.createdAt)
                .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _feedlist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  void getpostDetailFromDatabase(String postID, {FeedModel model}) async {
    try {
      FeedModel _portoDetail;
      if (model != null) {
        _portoDetail = model;
        setFeedModel = _portoDetail;
        postID = model.key;
      } else {
        kDatabase
            .child('porto')
            .child(postID)
            .once()
            .then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            var map = snapshot.value;
            _portoDetail = FeedModel.fromJson(map);
            _portoDetail.key = snapshot.key;
            setFeedModel = _portoDetail;
          }
        });
      }
    } catch (error) {
      cprint(error, errorIn: 'getpostDetailFromDatabase');
    }
  }

  Future<FeedModel> fetchPorto(String postID) async {
    FeedModel _portoDetail;

    if (feedlist.any((x) => x.key == postID)) {
      _portoDetail = feedlist.firstWhere((x) => x.key == postID);
    } else {
      cprint("Fetched from DB: " + postID);
      var model = await kDatabase.child('porto').child(postID).once().then(
        (DataSnapshot snapshot) {
          if (snapshot.value != null) {
            var map = snapshot.value;
            _portoDetail = FeedModel.fromJson(map);
            _portoDetail.key = snapshot.key;
            print(_portoDetail.description);
          }
        },
      );
      if (model != null) {
        _portoDetail = model;
      } else {
        cprint("Fetched null value from  DB");
      }
    }
    return _portoDetail;
  }

  createPorto(FeedModel model) {
    isBusy = true;
    notifyListeners();
    try {
      kDatabase.child('porto').push().set(model.toJson());
    } catch (error) {
      cprint(error, errorIn: 'buatporto');
    }
    isBusy = false;
    notifyListeners();
  }

  deletePorto(String portoId, TipePorto type, {String parentkey}) {
    try {
      kDatabase.child('porto').child(portoId).remove().then((_) {
        if (type == TipePorto.Detail &&
            _portoDetailModelList != null &&
            _portoDetailModelList.length > 0) {
          _portoDetailModelList.remove(_portoDetailModelList);
          if (_portoDetailModelList.length == 0) {
            _portoDetailModelList = null;
          }

          cprint('terhapus');
        }
      });
    } catch (error) {
      cprint(error, errorIn: 'hapusporto');
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('portoImage${Path.basename(file.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(file);
      var snapshot = await uploadTask.onComplete;
      if (snapshot != null) {
        var url = await storageReference.getDownloadURL();
        if (url != null) {
          return url;
        }
      }
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  Future<void> deleteFile(String url, String baseUrl) async {
    try {
      String filePath = url.replaceAll(
          new RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/twitter-clone-4fce9.appspot.com/o/'),
          '');
      filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

      StorageReference storageReference = FirebaseStorage.instance.ref();
      await storageReference.child(filePath).delete().catchError((val) {
        cprint('[Error]' + val);
      }).then((_) {
        cprint('[Sucess] Image deleted');
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  updatePorto(FeedModel model) async {
    await kDatabase.child('porto').child(model.key).set(model.toJson());
  }

  addLikeToPorto(FeedModel porto, String userId) {
    try {
      if (porto.likeList != null &&
          porto.likeList.length > 0 &&
          porto.likeList.any((id) => id == userId)) {
        porto.likeList.removeWhere((id) => id == userId);
        porto.likeCount -= 1;
      } else {
        if (porto.likeList == null) {
          porto.likeList = [];
        }
        porto.likeList.add(userId);
        porto.likeCount += 1;
      }

      kDatabase
          .child('porto')
          .child(porto.key)
          .child('likeList')
          .set(porto.likeList);

      kDatabase.child('notification').child(porto.userId).child(porto.key).set({
        'type': porto.likeList.length == 0 ? null : TipeNotif.Like.toString(),
        'updatedAt': porto.likeList.length == 0
            ? null
            : DateTime.now().toUtc().toString(),
      });
    } catch (error) {
      cprint(error, errorIn: 'porto error');
    }
  }

  _onPortoChanged(Event event) {
    var model = FeedModel.fromJson(event.snapshot.value);
    model.key = event.snapshot.key;
    if (_feedlist.any((x) => x.key == model.key)) {
      var oldEntry = _feedlist.lastWhere((entry) {
        return entry.key == event.snapshot.key;
      });
      _feedlist[_feedlist.indexOf(oldEntry)] = model;
    }

    if (_portoDetailModelList != null && _portoDetailModelList.length > 0) {
      if (_portoDetailModelList.any((x) => x.key == model.key)) {
        var oldEntry = _portoDetailModelList.lastWhere((entry) {
          return entry.key == event.snapshot.key;
        });
        _portoDetailModelList[_portoDetailModelList.indexOf(oldEntry)] = model;
      }
      if (portoReplyMap != null && portoReplyMap.length > 0) {
        if (true) {
          var list = portoReplyMap[model.parentkey];

          if (list != null && list.length > 0) {
            var index =
                list.indexOf(list.firstWhere((x) => x.key == model.key));
            list[index] = model;
          } else {
            list = [];
            list.add(model);
          }
        }
      }
    }
    if (event.snapshot != null) {
      cprint('porto terupdate');
      isBusy = false;
      notifyListeners();
    }
  }

  _onPortoAdded(Event event) {
    FeedModel porto = FeedModel.fromJson(event.snapshot.value);
    porto.key = event.snapshot.key;

    porto.key = event.snapshot.key;
    if (_feedlist == null) {
      _feedlist = List<FeedModel>();
    }
    if ((_feedlist.length == 0 || _feedlist.any((x) => x.key != porto.key)) &&
        porto.isValidPorto) {
      _feedlist.add(porto);
      cprint('porto nambah');
    }
    isBusy = false;
    notifyListeners();
  }

  _onPortoRemoved(Event event) async {
    FeedModel porto = FeedModel.fromJson(event.snapshot.value);
    porto.key = event.snapshot.key;
    var portoId = porto.key;
    var parentkey = porto.parentkey;

    try {
      FeedModel deletedPorto;
      if (_feedlist.any((x) => x.key == portoId)) {
        deletedPorto = _feedlist.firstWhere((x) => x.key == portoId);
        _feedlist.remove(deletedPorto);

        if (deletedPorto.parentkey != null &&
            _feedlist.isNotEmpty &&
            _feedlist.any((x) => x.key == deletedPorto.parentkey)) {
          var parentModel =
              _feedlist.firstWhere((x) => x.key == deletedPorto.parentkey);

          updatePorto(parentModel);
        }
        if (_feedlist.length == 0) {
          _feedlist = null;
        }
        cprint('terhapus');
      }

      if (parentkey != null &&
          parentkey.isNotEmpty &&
          portoReplyMap != null &&
          portoReplyMap.length > 0 &&
          portoReplyMap.keys.any((x) => x == parentkey)) {
        deletedPorto =
            portoReplyMap[parentkey].firstWhere((x) => x.key == portoId);
        portoReplyMap[parentkey].remove(deletedPorto);
        if (portoReplyMap[parentkey].length == 0) {
          portoReplyMap[parentkey] = null;
        }

        if (_portoDetailModelList != null &&
            _portoDetailModelList.isNotEmpty &&
            _portoDetailModelList.any((x) => x.key == parentkey)) {
          var parentModel =
              _portoDetailModelList.firstWhere((x) => x.key == parentkey);

          cprint('oke');
          updatePorto(parentModel);
        }

        cprint('oke');
      }

      if (deletedPorto.imagePath != null && deletedPorto.imagePath.length > 0) {
        deleteFile(deletedPorto.imagePath, 'portoImage');
      }

      if (deletedPorto.childRetwetkey != null) {
        await fetchPorto(deletedPorto.childRetwetkey).then((reportoModel) {
          if (reportoModel == null) {
            return;
          }

          updatePorto(reportoModel);
        });
      }

      if (deletedPorto.likeCount > 0) {
        kDatabase
            .child('notification')
            .child(porto.userId)
            .child(porto.key)
            .remove();
      }
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: '_onPortoRemoved');
    }
  }
}
