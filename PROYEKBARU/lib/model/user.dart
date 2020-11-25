class User {
  String key;
  String email;
  String userId;
  String displayName;
  String userName;
  String webSite;
  String profilePic;
  String contact;
  String bio;
  String location;
  String dob;
  String createdAt;
  String fcmToken;

  User({
    this.email,
    this.userId,
    this.displayName,
    this.profilePic,
    this.key,
    this.contact,
    this.bio,
    this.dob,
    this.location,
    this.createdAt,
    this.userName,
    this.webSite,
    this.fcmToken,
  });

  User.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];
    key = map['key'];
    dob = map['dob'];
    bio = map['bio'];
    location = map['location'];
    contact = map['contact'];
    createdAt = map['createdAt'];
    userName = map['userName'];
    webSite = map['webSite'];
    fcmToken = map['fcmToken'];
  }
  toJson() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'userId': userId,
      'profilePic': profilePic,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'location': location,
      'createdAt': createdAt,
      'userName': userName,
      'webSite': webSite,
      'fcmToken': fcmToken,
    };
  }

  User copyWith({
    String email,
    String userId,
    String displayName,
    String profilePic,
    String key,
    String contact,
    bio,
    String dob,
    String location,
    String createdAt,
    String userName,
    String webSite,
    bool isVerified,
    String fcmToken,
  }) {
    return User(
      email: email ?? this.email,
      bio: bio ?? this.bio,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      dob: dob ?? this.dob,
      key: key ?? this.key,
      location: location ?? this.location,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      webSite: webSite ?? this.webSite,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
