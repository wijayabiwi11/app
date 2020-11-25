import 'package:findes3/model/user.dart';

class FeedModel {
  String key;
  String parentkey;
  String childRetwetkey;
  String description;
  String description2;
  String description3;
  String userId;
  String bio;
  int likeCount;
  String childPortokey;
  List<String> likeList;
  String createdAt;
  String imagePath;
  List<String> tags;
  User user;
  FeedModel(
      {this.key,
      this.description,
      this.description2,
      this.description3,
      this.userId,
      this.likeCount,
      this.createdAt,
      this.imagePath,
      this.likeList,
      this.user,
      this.parentkey,
      this.bio,
      this.childPortokey});

  toJson() {
    return {
      "userId": userId,
      "description": description,
      "description2": description2,
      "description3": description3,
      "likeCount": likeCount,
      "createdAt": createdAt,
      "imagePath": imagePath,
      "likeList": likeList,
      "user": user == null ? null : user.toJson(),
      "parentkey": parentkey,
      "childRetwetkey": childPortokey
    };
  }

  FeedModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    description = map['description'];
    description2 = map['description2'];
    description3 = map['description3'];
    userId = map['userId'];
    //  name = map['name'];
    //  profilePic = map['profilePic'];
    likeCount = map['likeCount'] ?? 0;

    imagePath = map['imagePath'];
    createdAt = map['createdAt'];
    imagePath = map['imagePath'];
    //  username = map['username'];
    user = User.fromJson(map['user']);
    parentkey = map['parentkey'];
    childPortokey = map['childRetwetkey'];
    if (map['tags'] != null) {
      likeList = List<String>();

      final list = map['likeList'];
    }
    if (map["likeList"] != null) {
      likeList = List<String>();

      final list = map['likeList'];

      ///
      if (list is List) {
        map['likeList'].forEach((value) {
          if (value is String) {
            likeList.add(value);
          }
        });
        likeCount = likeList.length ?? 0;
      } else if (list is Map) {
        list.forEach((key, value) {
          likeList.add(value["userId"]);
        });
        likeCount = list.length;
      }
    } else {
      likeList = [];
      likeCount = 0;
    }
  }

  bool get isValidPorto {
    bool isValid = false;
    if (description != null &&
        description.isNotEmpty &&
        description2 != null &&
        description2.isNotEmpty &&
        this.user != null &&
        this.user.userName != null &&
        this.user.userName.isNotEmpty) {
      isValid = true;
    } else {
      print("Invalid bro. Id:- $key");
    }
    return isValid;
  }
}
