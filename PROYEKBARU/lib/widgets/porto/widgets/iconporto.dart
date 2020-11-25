import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/customRoute.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/portoModel.dart';

import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/porto/widgets/actioniconporto.dart';
import 'package:provider/provider.dart';

class PortoIconsRow extends StatelessWidget {
  final FeedModel model;
  final Color iconColor;
  final Widget trailing;
  final Color iconEnableColor;
  final double size;
  final bool isPortoDetail;
  final TipePorto type;
  const PortoIconsRow(
      {Key key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.trailing,
      this.isPortoDetail = false,
      this.type})
      : super(key: key);

  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    var authState = Provider.of<AuthState>(context, listen: false);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(bottom: 0, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 0,
          ),
          _iconWidget(
            context,
            text: isPortoDetail ? '' : model.likeCount.toString(),
            icon: model.likeList.any((userId) => userId == authState.userId)
                ? AppIcon.iconstar1
                : AppIcon.iconstar,
            onPressed: () {
              addLikeToPorto(context);
            },
            iconColor:
                model.likeList.any((userId) => userId == authState.userId)
                    ? iconEnableColor
                    : iconColor,
            size: size ?? 16,
          ),
          /* _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
              onPressed: () {
            share('${model.description}',
                subject: '${model.user.displayName}\'s post');
          }, iconColor: iconColor, size: size ?? 10),*/
        ],
      ),
    );
  }

  Widget _iconWidget(BuildContext context,
      {String text,
      int icon,
      Function onPressed,
      IconData sysIcon,
      Color iconColor,
      double size = 10}) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                if (onPressed != null) onPressed();
              },
              icon: sysIcon != null
                  ? Icon(sysIcon, color: iconColor, size: size)
                  : customIcon(
                      context,
                      size: size,
                      icon: icon,
                      istwitterIcon: true,
                      iconColor: iconColor,
                    ),
            ),
            customText(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: iconColor,
                fontSize: size - 5,
              ),
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            SizedBox(width: 5),
            customText(getPostTime2(model.createdAt), style: textStyle14),
            SizedBox(width: 10),
            customText('',
                style: TextStyle(color: Theme.of(context).primaryColor))
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  void addLikeToPorto(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToPorto(model, authState.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        isPortoDetail ? _timeWidget(context) : SizedBox(),
        _likeCommentsIcons(context, model)
      ],
    ));
  }
}
