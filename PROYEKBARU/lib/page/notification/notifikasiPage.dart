import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/model/notificationModel.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/state/notifState.dart';
import 'package:findes3/widgets/AppBar.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/emptyList.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key, this.scaffoldKey}) : super(key: key);

  /// scaffoldKey used to open sidebaar drawer
  final GlobalKey<ScaffoldState> scaffoldKey;

  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = Provider.of<NotificationState>(context, listen: false);
      var authstate = Provider.of<AuthState>(context, listen: false);
      state.getDataFromDatabase(authstate.userId);
    });
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/NotificationPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        title: customTitleText(
          'Notifikasi',
        ),
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
      ),
      body: NotificationPageBody(),
    );
  }
}

class NotificationPageBody extends StatelessWidget {
  const NotificationPageBody({Key key}) : super(key: key);

  Widget _notificationRow(BuildContext context, NotificationModel model) {
    var state = Provider.of<NotificationState>(context);
    return FutureBuilder(
      future: state.getPortoDetail(model.portoKey),
      builder: (BuildContext context, AsyncSnapshot<FeedModel> snapshot) {
        if (snapshot.hasData) {
          return NotificationTile(
            model: snapshot.data,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return SizedBox(
            height: 4,
            child: LinearProgressIndicator(),
          );
        } else {
          var authstate = Provider.of<AuthState>(context);
          state.removeNotification(authstate.userId, model.portoKey);
          return SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<NotificationState>(context);
    var list = state.notificationList;
    if (state?.isbusy ?? true && (list == null || list.isEmpty)) {
      return SizedBox(
        height: 3,
        child: LinearProgressIndicator(),
      );
    } else if (list == null || list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 150),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 80,
              height: 200,
              child: Image.asset('assets/images/model5.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  'Notifikasi Kosong',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tambah portfolio dengan menekan  ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w100),
                        ),
                        Icon(
                          Icons.iconpluscircled,
                          size: 17,
                          color: Colors.amber,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'dan dapatkan like dari client',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => _notificationRow(context, list[index]),
      itemCount: list.length,
    );
  }
}

class NotificationTile extends StatelessWidget {
  final FeedModel model;
  const NotificationTile({Key key, this.model}) : super(key: key);
  Widget _userList(BuildContext context, List<String> list) {
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    var state = Provider.of<NotificationState>(context);
    if (list != null && list.length > 5) {
      list = list.take(5).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, state, (name) {});
    }).toList();
    if (noOfUser > 5) {
      avaterList.add(
        Text(
          " +${noOfUser - 5}",
          style: subtitleStyle.copyWith(fontSize: 16),
        ),
      );
    }

    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            customIcon(context,
                icon: AppIcon.iconstar,
                iconColor: AppColor.darkGrey,
                istwitterIcon: true,
                size: 25),
            SizedBox(width: 10),
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
        Padding(
          padding: EdgeInsets.only(left: 60, bottom: 5, top: 5),
          child: TitleText(
            '$length menyukai portfolio anda',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
    return col;
  }

  Widget _userAvater(
      String userId, NotificationState state, ValueChanged<String> name) {
    return FutureBuilder(
      future: state.getuserDetail(userId),
      //  initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          name(snapshot.data.displayName);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/ProfilePage/' + snapshot.data?.userId);
              },
              child: customImage(context, snapshot.data.profilePic, height: 30),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var description = model.description.length > 150
        ? model.description.substring(0, 150) + '...'
        : model.description;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: AppColor.white,
          child: ListTile(
            onTap: () {
              var state = Provider.of<FeedState>(context, listen: false);
              state.getpostDetailFromDatabase(null, model: model);
              Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
            },
            title: _userList(context, model.likeList),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 60),
              child: UrlText(
                text: description,
                style: TextStyle(
                  color: AppColor.darkGrey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        Divider(height: 0, thickness: .6)
      ],
    );
  }
}
