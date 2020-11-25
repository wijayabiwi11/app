import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';

import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:findes3/widgets/porto/widgets/hubunganPorto.dart';
import 'package:findes3/widgets/porto/widgets/iconporto.dart';
import 'package:provider/provider.dart';

import 'widgets/portofolioImage.dart';

class Portofolio extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final TipePorto type;
  final bool isDisplayOnProfile;
  const Portofolio(
      {Key key,
      this.model,
      this.trailing,
      this.type = TipePorto.Porto,
      this.isDisplayOnProfile = false})
      : super(key: key);

  void onLongPressedPorto(BuildContext context) {
    if (type == TipePorto.Detail || type == TipePorto.HubunganPorto) {
      var text = ClipboardData(text: model.description);

      Clipboard.setData(text);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AplikasiColor.black,
          content: Text(
            'kaming sun, bisa ngapus (option menu)',
          ),
        ),
      );
    }
  }

  void onTapPorto(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    if (type == TipePorto.Detail || type == TipePorto.HubunganPorto) {
      return;
    }
    if (type == TipePorto.Porto && !isDisplayOnProfile) {
      feedstate.clearAllDetailAndReplyPortoStack();
    }
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        type != TipePorto.HubunganPorto
            ? SizedBox.shrink()
            : Positioned.fill(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 38,
                    top: 75,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 3.0, color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ),
        InkWell(
          onLongPress: () {
            onLongPressedPorto(context);
          },
          onTap: () {
            onTapPorto(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(
                    top: type == TipePorto.Porto ? 20 : 0,
                  ),
                  child: _PortoBody(
                    isDisplayOnProfile: isDisplayOnProfile,
                    model: model,
                    trailing: trailing,
                    type: type,
                  )),
              PortoImage(
                model: model,
                type: type,
              ),
              PortoIconsRow(
                type: type,
                model: model,
                isPortoDetail: type == TipePorto.Detail,
                iconColor: Theme.of(context).textTheme.caption.color,
                iconEnableColor: AppColor.primary,
                size: 20,
              ),
              type == TipePorto.HubunganPorto
                  ? SizedBox.expand()
                  : Divider(height: 1, thickness: 2)
            ],
          ),
        ),
      ],
    );
  }
}

class _PortoBody extends StatelessWidget {
  final FeedModel model;
  final Widget trailing;
  final TipePorto type;
  final bool isDisplayOnProfile;
  const _PortoBody(
      {Key key, this.model, this.trailing, this.type, this.isDisplayOnProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double descriptionFontSize = type == TipePorto.Porto
        ? 20
        : type == TipePorto.Detail || type == TipePorto.HubunganPorto
            ? 20
            : 14;
    FontWeight descriptionFontWeight =
        type == TipePorto.Porto || type == TipePorto.Porto
            ? FontWeight.w700
            : FontWeight.w700;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            width: 30,
            height: 30,
            child: GestureDetector(
              onTap: () {
                if (isDisplayOnProfile) {
                  return;
                }
                Navigator.of(context)
                    .pushNamed('/ProfilePage/' + model?.userId);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: customImage(context, model.user.profilePic),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: fullWidth(context) - 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: 0, maxWidth: fullWidth(context) * .5),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TitleText(model.user.displayName,
                                fontSize: 17, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(width: 3),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: customText('· ${getChatTime(model.createdAt)}',
                              style: userNameStyle),
                        ),
                      ],
                    ),
                  ),
                  Container(child: trailing == null ? SizedBox() : trailing),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 5, right: 5),
                child: UrlText(
                  text: model.description,
                  onHashTagPressed: (tag) {
                    cprint(tag);
                  },
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: descriptionFontSize,
                      fontWeight: descriptionFontWeight),
                  urlStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: descriptionFontSize,
                      fontWeight: descriptionFontWeight),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, bottom: 10, right: 5),
                child: UrlText(
                  text: model.description3,
                  onHashTagPressed: (tag) {
                    cprint(tag);
                  },
                  style: TextStyle(color: Colors.black54, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
