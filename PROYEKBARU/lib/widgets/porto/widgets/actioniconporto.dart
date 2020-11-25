import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:provider/provider.dart';

class PortoBottomSheet {
  Widget portoOptionIcon(
      BuildContext context, FeedModel model, TipePorto type) {
    return customInkWell(
        radius: BorderRadius.circular(20),
        context: context,
        onPressed: () {
          _openbottomSheet(context, type, model);
        },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.keyboard_arrow_down),
        ));
  }

  void _openbottomSheet(
      BuildContext context, TipePorto type, FeedModel model) async {
    var authState = Provider.of<AuthState>(context, listen: false);
    bool isMyPorto = authState.userId == model.userId;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) *
                (type == TipePorto.Porto
                    ? (isMyPorto ? .25 : .44)
                    : (isMyPorto ? .38 : .52)),
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == TipePorto.Porto
                ? _portoOptions(context, isMyPorto, model, type)
                : _portoDetailOptions(context, isMyPorto, model, type));
      },
    );
  }

  Widget _portoDetailOptions(
      BuildContext context, bool isMyPorto, FeedModel model, TipePorto type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        isMyPorto
            ? _widgetBottomSheetRow(
                context,
                AppIcon.iconcancel,
                text: 'Delete Portfolio',
                onPressed: () {
                  _deletePorto(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            : isMyPorto
                ? Container()
                : _widgetBottomSheetRow(
                    context,
                    AppIcon.report,
                    text: 'Report Portofolio',
                  ),
      ],
    );
  }

  Widget _portoOptions(
      BuildContext context, bool isMyPorto, FeedModel model, TipePorto type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        isMyPorto
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Portfolio',
                onPressed: () {
                  _deletePorto(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            : Container(),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, int icon,
      {String text, Function onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null)
            onPressed();
          else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
              SizedBox(
                width: 10,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePorto(BuildContext context, TipePorto type, String portoId,
      {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deletePorto(portoId, type, parentkey: parentkey);

    Navigator.of(context).pop();
    if (type == TipePorto.Detail) {
      Navigator.of(context).pop();

      state.removeLastPortoDetail(portoId);
    }
  }
}
