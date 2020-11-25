import 'package:flutter/material.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import '../icondll.dart';

class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: fullHeight(context) - 135,
        color: AplikasiColor.mystic,
        child: NotifyText(
          title: title,
          subTitle: subTitle,
        ));
  }
}

class NotifyText extends StatelessWidget {
  final String subTitle;
  final String title;
  final String iconi;
  const NotifyText({Key key, this.subTitle, this.title, this.iconi})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title, fontSize: 20, textAlign: TextAlign.center),
        SizedBox(
          height: 8,
        ),
        TitleText(
          subTitle,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColor.darkGrey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
