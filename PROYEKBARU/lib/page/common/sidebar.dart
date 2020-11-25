import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:provider/provider.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({Key key, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  Widget _menuHeader() {
    final state = Provider.of<AuthState>(context);
    if (state.userModel == null) {
      return customInkWell(
        context: context,
        onPressed: () {
          //  Navigator.of(context).pushNamed('/signIn');
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 200, minHeight: 100),
          child: Center(
            child: Text(
              'Login untuk melanjutkan',
              style: onPrimaryTitleText,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(left: 17, top: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: customAdvanceNetworkImage(
                      state.userModel.profilePic ?? dummyProfilePic,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                  onTap: () {
                    _navigateTo("ProfilePage");
                  },
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: UrlText(
                          text: state.userModel.displayName ?? "",
                          style: onPrimaryTitleText.copyWith(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: customText(
                      state.userModel.dob,
                      style: onPrimarySubTitleText.copyWith(
                          color: Colors.black54, fontSize: 15),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: Colors.amber,
                  )),
            ],
          ),
        ),
      );
    }
  }

  Widget _tappbleText(
      BuildContext context, String count, String text, String navigateTo) {
    return InkWell(
      onTap: () {
        var authstate = Provider.of<AuthState>(context, listen: false);
        // authstate.profileFollowingList = [];
        authstate.getProfileUser();
        _navigateTo(navigateTo);
      },
      child: Row(
        children: <Widget>[
          customText(
            '$count ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          customText(
            '$text',
            style: TextStyle(color: AppColor.darkGrey, fontSize: 17),
          ),
        ],
      ),
    );
  }

  ListTile _menuListRowButton(String title,
      {Function onPressed, int icon, bool isEnable = false}) {
    return ListTile(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: 10, right: 0, left: 17),
              child: customIcon(
                context,
                icon: icon,
                size: 17,
                iconColor: isEnable ? AppColor.primary : AppColor.lightGrey,
              ),
            ),
      title: customText(
        title,
        style: TextStyle(
          fontSize: 17,
          color: isEnable ? AppColor.primary : AppColor.lightGrey,
        ),
      ),
    );
  }

  /*Positioned _footer() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          Divider(height: 0),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 45,
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  istwitterIcon: true,
                  size: 25,
                  iconColor: ),
              Spacer(),
              Image.asset(
                "assets/images/qr.png",
                height: 25,
              ),
              SizedBox(
                width: 10,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }*/

  void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 45),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    child: _menuHeader(),
                  ),
                  Divider(),
                  _menuListRowButton('Profile',
                      icon: AppIcon.iconuser, isEnable: true, onPressed: () {
                    _navigateTo(
                      'ProfilePage',
                    );
                  }),

                  //_menuListRowButton('', isEnable: true,
                  //  onPressed: () {
                  // _navigateTo('');
                  //  }),
                  _menuListRowButton('Bantuan', icon: AppIcon.iconinfocircled),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _menuListRowButton('Keluar',
                          icon: AppIcon.iconcancelcircle,
                          onPressed: _logOut,
                          isEnable: true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
