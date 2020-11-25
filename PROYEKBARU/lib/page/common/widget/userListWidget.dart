import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/rippleButton.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';

class UserListWidget extends StatelessWidget {
  final List<User> list;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  UserListWidget({
    Key key,
    this.list,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    String myId = state.userModel.key;
    return ListView.separated(
      itemBuilder: (context, index) {
        return UserTile(
          user: list[index],
          myId: myId,
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: 0,
        );
      },
      itemCount: list.length,
    );
    // : LinearProgressIndicator();
  }
}

class UserTile extends StatelessWidget {
  const UserTile({Key key, this.user, this.myId}) : super(key: key);
  final User user;
  final String myId;

  /// Return empty string for default bio
  /// Max length of bio is 100
  String getBio(String bio) {
    if (bio != null &&
        bio.isNotEmpty &&
        bio != "Edit profile untuk update bio") {
      if (bio.length > 100) {
        bio = bio.substring(0, 100) + '...';
        return bio;
      } else {
        return bio;
      }
    }
    return null;
  }

  /// Check if user followerlist contain your or not
  /// If your id exist in follower list it mean you are following him

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: AplikasiColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
            },
            leading: RippleButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
              },
              borderRadius: BorderRadius.all(Radius.circular(60)),
              child: customImage(context, user.profilePic, height: 55),
            ),
            title: Row(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 0, maxWidth: fullWidth(context) * .4),
                  child: TitleText(user.displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(width: 3),
              ],
            ),
            subtitle: Text(user.userName),
          ),
          getBio(user.bio) == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: Text(
                    getBio(user.bio),
                  ),
                )
        ],
      ),
    );
  }
}
