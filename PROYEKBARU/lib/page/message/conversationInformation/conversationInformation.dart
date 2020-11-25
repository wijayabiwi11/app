import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/page/settings/widgets/headerWidget.dart';

import 'package:findes3/page/settings/widgets/settingsRowWidget.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/chats/chatState.dart';
import 'package:findes3/widgets/AppBar.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/rippleButton.dart';
import 'package:provider/provider.dart';

class ChatInformation extends StatelessWidget {
  const ChatInformation({Key key}) : super(key: key);

  Widget _header(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 80,
                width: 80,
                child: RippleButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/ProfilePage/' + user?.userId);
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: customImage(context, user.profilePic, height: 80),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: user.displayName,
                style: onPrimaryTitleText.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 3,
              ),
            ],
          ),
          customText(
            user.userName,
            style: onPrimarySubTitleText.copyWith(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ChatState>(context).chatUser ?? User();
    return Scaffold(
      backgroundColor: AplikasiColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Informasi Pesan',
        ),
      ),
      body: ListView(
        children: <Widget>[
          _header(context, user),
          HeaderWidget('Notif'),
          SettingRowWidget(
            "Konversasi",
            visibleSwitch: true,
          ),
          Container(
            height: 15,
            color: AplikasiColor.mystic,
          ),
          SettingRowWidget("Hapus Pesan",
              textColor: AplikasiColor.ceriseRed, showDivider: false),
        ],
      ),
    );
  }
}
