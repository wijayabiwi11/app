import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/model/portoModel.dart';

class UnavailablePorto extends StatelessWidget {
  const UnavailablePorto({Key key, this.snapshot, this.type}) : super(key: key);

  final AsyncSnapshot<FeedModel> snapshot;
  final TipePorto type;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(
          right: 16,
          top: 5,
          left: type == TipePorto.Porto || type == TipePorto.HubunganPorto
              ? 70
              : 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColor.extraLightGrey.withOpacity(.3),
        border: Border.all(color: AppColor.extraLightGrey, width: .5),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: snapshot.connectionState == ConnectionState.waiting
          ? SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: AppColor.extraLightGrey,
                valueColor: AlwaysStoppedAnimation(
                  AppColor.darkGrey.withOpacity(.3),
                ),
              ),
            )
          : Text('Gak tersedia', style: userNameStyle),
    );
  }
}
