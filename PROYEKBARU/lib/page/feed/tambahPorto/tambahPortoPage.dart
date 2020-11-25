import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/page/feed/tambahPorto/state/tambahPortoState.dart';
import 'package:findes3/page/feed/tambahPorto/widget/WidgetBottomIkon.dart';
import 'package:findes3/page/feed/tambahPorto/widget/uploadGambar.dart';
import 'package:findes3/page/feed/tambahPorto/widget/widgetView.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/state/cariState2.dart';
import 'package:findes3/widgets/AppBar.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';

class TambahPortoPage extends StatefulWidget {
  TambahPortoPage({Key key, this.isPorto2, this.isPorto = true})
      : super(key: key);

  final bool isPorto2;
  final bool isPorto;
  _ComposePorto2PageState createState() => _ComposePorto2PageState();
}

class _ComposePorto2PageState extends State<TambahPortoPage> {
  bool isScrollingDown = false;
  FeedModel model;
  ScrollController scrollcontroller;

  File _image;
  TextEditingController _textEditingController;
  TextEditingController _textEditingController2;
  TextEditingController _textEditingController3;

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var feedState = Provider.of<FeedState>(context, listen: false);
    model = feedState.portoportoModel;
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    _textEditingController2 = TextEditingController();
    _textEditingController3 = TextEditingController();
    scrollcontroller..addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        Provider.of<TambahPortoState>(context, listen: false)
            .setIsScrolllingDown = true;
      }
    }
    if (scrollcontroller.position.userScrollDirection ==
        ScrollDirection.forward) {
      Provider.of<TambahPortoState>(context, listen: false)
          .setIsScrolllingDown = false;
    }
  }

  void _onCrossIconPressed() {
    setState(() {
      _image = null;
    });
  }

  void _onImageIconSelcted(File file) {
    setState(() {
      _image = file;
    });
  }

  void _submitButton() async {
    if (_textEditingController.text == null ||
        _textEditingController.text.isEmpty ||
        _textEditingController.text.length > 280) {
      return;
    }
    var state = Provider.of<FeedState>(context, listen: false);
    kScreenloader.showLoader(context);

    FeedModel portoModel = createPortoModel();

    if (_image != null) {
      await state.uploadFile(_image).then((imagePath) {
        if (imagePath != null) {
          portoModel.imagePath = imagePath;

          if (widget.isPorto) {
            state.createPorto(portoModel);
          }
        }
      });
    } else {
      if (widget.isPorto) {
        state.createPorto(portoModel);
      }
    }

    await Provider.of<TambahPortoState>(context, listen: false)
        .sendNotification(
            portoModel, Provider.of<SearchState>(context, listen: false))
        .then((_) {
      kScreenloader.hideLoader();

      Navigator.pop(context);
    });
  }

  FeedModel createPortoModel() {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel;
    var profilePic = myUser.profilePic ?? dummyProfilePic;
    var commentedUser = User(
        displayName: myUser.displayName ?? myUser.email.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        userName: authState.userModel.userName,
        bio: authState.userModel.bio);

    FeedModel reply = FeedModel(
        description: _textEditingController.text,
        description2: _textEditingController2.text,
        description3: _textEditingController3.text,
        user: commentedUser,
        createdAt: DateTime.now().toUtc().toString(),
        parentkey: widget.isPorto
            ? null
            : widget.isPorto2
                ? null
                : state.portoportoModel.key,
        childPortokey: widget.isPorto
            ? null
            : widget.isPorto2
                ? model.key
                : null,
        userId: myUser.userId);
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: customTitleText(''),
        onActionPressed: _submitButton,
        isCrossButton: true,
        submitButtonText: widget.isPorto
            ? 'Publish'
            : widget.isPorto2
                ? ''
                : '',
        isSubmitDisable:
            !Provider.of<TambahPortoState>(context).enableSubmitButton ||
                Provider.of<FeedState>(context).isBusy,
        isbootomLine: Provider.of<TambahPortoState>(context).isScrollingDown,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollcontroller,
              child:
                  widget.isPorto2 ? _ComposePorto2(this) : _ComposePorto(this),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ComposeBottomIconWidget(
                textEditingController: _textEditingController,
                onImageIconSelcted: _onImageIconSelcted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComposePorto2
    extends WidgetView<TambahPortoPage, _ComposePorto2PageState> {
  _ComposePorto2(this.viewState) : super(viewState);

  final _ComposePorto2PageState viewState;
  Widget _porto(BuildContext context, FeedModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(width: 10),

        SizedBox(width: 20),
        Container(
          width: fullWidth(context) - 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 0, maxWidth: fullWidth(context) * .5),
                    child: TitleText(model.user.displayName,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis),
                  ),
                  SizedBox(width: 3),
                  Flexible(
                    child: customText(
                      '${model.user.bio}',
                      style: userNameStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 4),
                  customText('· ${getChatTime(model.createdAt)}',
                      style: userNameStyle),
                  Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
        ),
        UrlText(
          text: model.description,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          urlStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Container(
      height: fullHeight(context),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child:
                    customImage(context, authState.user?.photoUrl, height: 40),
              ),*/
              Expanded(
                child: _TextField(
                  isPorto: false,
                  isPorto2: true,
                  textEditingController: viewState._textEditingController,
                ),
              ),
              SizedBox(
                width: 16,
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, left: 16, bottom: 8),
            child: TambahPortoImage(
              image: viewState._image,
              onCrossIconPressed: viewState._onCrossIconPressed,
            ),
          ),
          Flexible(
            child: Stack(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 75, right: 16, bottom: 16),
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColor.extraLightGrey, width: .5),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: _porto(context, viewState.model),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}

class _ComposePorto
    extends WidgetView<TambahPortoPage, _ComposePorto2PageState> {
  _ComposePorto(this.viewState) : super(viewState);

  final _ComposePorto2PageState viewState;

  Widget _tweerCard(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0),
              margin: EdgeInsets.only(left: 0, top: 20, bottom: 3),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: fullWidth(context) - 72,
                    child: Column(
                      children: [
                        UrlText(
                          text: viewState.model.description ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          urlStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        UrlText(
                          text: viewState.model.description2 ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          urlStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  UrlText(
                    text:
                        'Replying to ${viewState.model.user.userName ?? viewState.model.user.displayName}',
                    style: TextStyle(
                      color: AplikasiColor.paleSky,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*customImage(context, viewState.model.user.profilePic,
                    height: 40),*/
                SizedBox(width: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 0, maxWidth: fullWidth(context) * .5),
                  child: TitleText(viewState.model.user.displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(width: 3),
                customText('${viewState.model.user.userName}',
                    style: userNameStyle.copyWith(fontSize: 15)),
                SizedBox(width: 5),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: customText(
                      '- ${getChatTime(viewState.model.createdAt)}',
                      style: userNameStyle.copyWith(fontSize: 12)),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      height: fullHeight(context),
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          viewState.widget.isPorto ? SizedBox.shrink() : _tweerCard(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*customImage(context, authState.user?.photoUrl, height: 40),
              SizedBox(
                width: 10,
              ),*/
              Expanded(
                child: Column(
                  children: [
                    _TextField(
                      isPorto: widget.isPorto,
                      textEditingController: viewState._textEditingController,
                    ),
                    _TextField3(
                      isPorto: widget.isPorto,
                      textEditingController3: viewState._textEditingController3,
                    ),
                    _TextField2(
                      isPorto: widget.isPorto,
                      textEditingController2: viewState._textEditingController2,
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Flexible(
              child: Stack(
                children: <Widget>[
                  TambahPortoImage(
                    image: viewState._image,
                    onCrossIconPressed: viewState._onCrossIconPressed,
                  ),
                  // _UserList(
                  //   list: Provider.of<SearchState>(context).userlist,
                  //   textEditingController: viewState._textEditingController,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField(
      {Key key,
      this.textEditingController,
      this.textEditingController2,
      this.isPorto = false,
      this.isPorto2 = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final TextEditingController textEditingController2;
  final bool isPorto;
  final bool isPorto2;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 6, right: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              controller: textEditingController,
              onChanged: (text) {
                Provider.of<TambahPortoState>(context, listen: false)
                    .onDescriptionChanged(text, searchState);
              },
              decoration: InputDecoration(
                hintText: 'Judul',
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.amber),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextField2 extends StatelessWidget {
  const _TextField2(
      {Key key,
      this.textEditingController,
      this.textEditingController2,
      this.isPorto = false,
      this.isPorto2 = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final TextEditingController textEditingController2;
  final bool isPorto;
  final bool isPorto2;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 6, right: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              maxLines: 10,
              controller: textEditingController2,
              onChanged: (text) {
                Provider.of<TambahPortoState>(context, listen: false)
                    .onDescriptionChanged(text, searchState);
              },
              decoration: InputDecoration(
                hintText: 'Deskripsi',
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.amber),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextField3 extends StatelessWidget {
  const _TextField3(
      {Key key,
      this.textEditingController,
      this.textEditingController2,
      this.textEditingController3,
      this.isPorto = false,
      this.isPorto2 = false})
      : super(key: key);
  final TextEditingController textEditingController;
  final TextEditingController textEditingController2;
  final TextEditingController textEditingController3;
  final bool isPorto;
  final bool isPorto2;

  @override
  Widget build(BuildContext context) {
    var items = [
      'Logo Design',
      'Social Media Design',
      'Digital Banner Design',
      'UI Design',
      'Branding Design',
    ];
    final searchState = Provider.of<SearchState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 7, right: 7),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: textEditingController3,
            decoration: InputDecoration(
              border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                const Radius.circular(25.0),
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(25.0))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber[700], width: 0.0),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(25.0))),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: 'Masukan atau pilih jenis desain',
              hintStyle: TextStyle(fontSize: 15),
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down),
                onSelected: (String value) {
                  textEditingController3.text = value;
                },
                itemBuilder: (BuildContext context) {
                  return items.map<PopupMenuItem<String>>((String value) {
                    return new PopupMenuItem(
                        child: new Text(value), value: value);
                  }).toList();
                },
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          )),
        ],
      ),
    );
  }
}
