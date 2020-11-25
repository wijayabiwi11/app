import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/rippleButton.dart';
import 'package:findes3/widgets/porto/Portofolio.dart';
import 'package:findes3/widgets/porto/widgets/actioniconporto.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:findes3/state/chats/chatState.dart';
import 'package:photo_view/photo_view.dart';
import 'package:full_screen_image/full_screen_image.dart';

import 'package:findes3/widgets/porto/widgets/iconporto.dart';

class FeedPostDetail extends StatefulWidget {
  FeedPostDetail(
      {Key key,
      this.postId,
      this.isDisplayOnProfile,
      this.model,
      this.trailing,
      this.type,
      this.isMyPorto,
      this.profileId})
      : super(key: key);
  final String postId;
  final FeedModel model;
  final Widget trailing;
  final TipePorto type;
  final String profileId;
  final bool isDisplayOnProfile;
  final bool isMyPorto;

  _FeedPostDetailState createState() => _FeedPostDetailState();
}

class _FeedPostDetailState extends State<FeedPostDetail> {
  String postId;
  bool isMyPorto = false;
  FeedModel model;
  @override
  void initState() {
    postId = widget.postId;
    var authstate = Provider.of<AuthState>(context, listen: false);
    authstate.getProfileUser(userProfileId: widget.profileId);

    // var state = Provider.of<FeedState>(context, listen: false);
    // state.getpostDetailFromDatabase(postId);
    super.initState();
  }

  Widget _commentRow(FeedModel model) {
    return Portofolio(
      model: model,
      type: TipePorto.Reply,
      trailing:
          PortoBottomSheet().portoOptionIcon(context, model, TipePorto.Reply),
    );
  }

  Widget _portoDetail(FeedModel model) {
    return PortoIconsRow(
      model: model,
      type: TipePorto.Detail,
      trailing:
          PortoBottomSheet().portoOptionIcon(context, model, TipePorto.Detail),
    );
  }

  void addLikeToComment(String commentId) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToPorto(state.portoDetailModel.last, authState.userId);
  }

  void openImage() async {
    Navigator.pushNamed(context, '/ImageViewPge');
  }

  void deletePorto(TipePorto type, String portoId, {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deletePorto(portoId, type, parentkey: parentkey);
    Navigator.of(context).pop();
    if (type == TipePorto.Detail) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FeedState>(context);

    Widget _topView() {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    state.portoDetailModel.last.description != null
                        ? state.portoDetailModel.last.description
                        : '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.portoDetailModel.last.description3 != null
                          ? state.portoDetailModel.last.description3
                          : '-',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget _cardInformationUser(BuildContext context, FeedModel model) {
      var authState = Provider.of<AuthState>(context, listen: false);
      bool isMyPorto =
          authState.userId == state.portoDetailModel.last.user.userId;

      return Card(
          elevation: 5.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: FullScreenWidget(
                  child: Center(
                    child: Hero(
                      tag: 'gambar',
                      child: Image(
                          image: new NetworkImage(
                              state.portoDetailModel.last.imagePath),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                )),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.portoDetailModel.last.description2 != null
                        ? state.portoDetailModel.last.description2
                        : '-',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/ProfilePage/' +
                        state.portoDetailModel.last.user.userId);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Center(
                      child: Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: new BoxDecoration(
                          border:
                              new Border.all(color: Colors.black12, width: 1),
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(
                              state.portoDetailModel.last.user.profilePic,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 2),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    state.portoDetailModel.last.user.displayName != null
                        ? state.portoDetailModel.last.user.displayName
                        : '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                        fontFamily: 'nunitosans',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 0, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    state.portoDetailModel.last.user.bio != null
                        ? state.portoDetailModel.last.user.bio
                        : '-',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black45,
                        fontFamily: 'nunitosans',
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: state.portoDetailModel == null ||
                              state.portoDetailModel.length == 0
                          ? Container()
                          : _portoDetail(
                              state.portoDetailModel?.last,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 0,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        // color: Color(0XFF33963E).withOpacity(0.2)),
                        // color: Colors.white,
                        // border: Border.all(color: Colors.black12)),
                        child: Material(
                            type: MaterialType.transparency,
                            color: Colors.transparent,
                            child: Row(
                              children: <Widget>[
                                isMyPorto
                                    ? Container()
                                    : RippleButton(
                                        splashColor: AplikasiColor.dodgetBlue_50
                                            .withAlpha(100),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        onPressed: () {
                                          if (!isMyPorto) {
                                            final chatState =
                                                Provider.of<ChatState>(context,
                                                    listen: false);
                                            chatState.setChatUser = state
                                                .portoDetailModel.last.user;
                                            Navigator.pushNamed(context,
                                                ''); //tambah /ChatScreenPage/
                                          }
                                        },
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            child: Icon(
                                              Icons.iconcommentinvalt2,
                                              color: Colors.black87,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            )),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      Container(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        // color: Color(0XFF33963E).withOpacity(0.2)),
                        // color: Colors.white,
                        // border: Border.all(color: Colors.black12)),
                        child: Material(
                          type: MaterialType.transparency,
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/ProfilePage/' +
                                  state.portoDetailModel.last.user.userId);
                            },
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Icon(
                                  FontAwesomeIcons.solidUser,
                                  color: Colors.black87,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // SizedBox(width: 16.0),
                      // Icon(
                      //   FontAwesomeIcons.calendar,
                      //   color: Color(0XFFEC2E33),
                      //   size: 17,
                      // ),
                      // SizedBox(width: 16.0),
                      // new Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: <Widget>[
                      //     new Container(
                      //       margin: EdgeInsets.only(left: 5, right: 5.0),
                      //       child: new Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Container(
                      //             width: MediaQuery.of(context).size.width / 1.8,
                      //             child: Text(
                      //               widget.itemData.data.waktu != null
                      //                   ? widget.itemData.data.waktu
                      //                   : '-',
                      //               style: TextStyle(
                      //                   fontSize: 14.0,
                      //                   color: Color(0XFF343434),
                      //                   fontFamily: 'nunitosans',
                      //                   fontWeight: FontWeight.w700),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {},
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: <Widget>[
                      //           Icon(
                      //             FontAwesomeIcons.copy,
                      //             color: Color(0XFFFFFFFF),
                      //             size: 16,
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ));
    }

    var authstate = Provider.of<AuthState>(context);
    return WillPopScope(
      onWillPop: () async {
        Provider.of<FeedState>(context, listen: false)
            .removeLastPortoDetail(postId);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              forceElevated: false,
              expandedHeight: 30,
              elevation: 0,
              stretch: true,
              pinned: true,
              title: customTitleText('Portfolio Detail'),
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              backgroundColor: Theme.of(context).appBarTheme.color,
              bottom: PreferredSize(
                child: Container(
                  color: Colors.grey.shade200,
                  height: 1.0,
                ),
                preferredSize: Size.fromHeight(0.0),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  state.portoDetailModel == null ||
                          state.portoDetailModel.length == 0
                      ? Container()
                      : _topView(),
                  _cardInformationUser(context, model),
                  // Container(
                  //   height: 9,
                  //   width: fullWidth(context),
                  //   color: TwitterColor.mystic,
                  // )
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                state.portoReplyMap == null ||
                        state.portoReplyMap.length == 0 ||
                        state.portoReplyMap[postId] == null
                    ? [
                        Container(
                          child: Center(
                              //  child: Text('No comments'),
                              ),
                        )
                      ]
                    : state.portoReplyMap[postId]
                        .map((x) => _commentRow(x))
                        .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final IconData icon;
  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Hapus Portfolio', icon: Icons.directions_car),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 10.0, color: Colors.black),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
