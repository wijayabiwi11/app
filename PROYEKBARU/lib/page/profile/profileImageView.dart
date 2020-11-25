import 'package:flutter/material.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/page/profile/profilePage.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:provider/provider.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Choice> choices = const <Choice>[
      const Choice(title: 'Share image link', icon: Icons.share),
      const Choice(title: 'Open in browser', icon: Icons.open_in_browser),
      const Choice(title: 'Save', icon: Icons.save),
    ];
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      backgroundColor: AplikasiColor.white,
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: (d) {
              switch (d.title) {
                case "Share image link":
                  share(authstate.profileUserModel.profilePic);
                  break;
                case "Open in browser":
                  launchURL(authstate.profileUserModel.profilePic);
                  break;
                case "Save":
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: fullWidth(context),
          // height: fullWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: customAdvanceNetworkImage(
                  authstate.profileUserModel.profilePic),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
