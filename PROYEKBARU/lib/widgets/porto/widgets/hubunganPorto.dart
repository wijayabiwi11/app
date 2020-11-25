import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/porto/Portofolio.dart';
import 'package:findes3/widgets/porto/widgets/tidaktersedia.dart';
import 'package:provider/provider.dart';

class ParentPortoWidget extends StatelessWidget {
  ParentPortoWidget(
      {Key key,
      this.childRetwetkey,
      this.type,
      this.isImageAvailable,
      this.trailing})
      : super(key: key);

  final String childRetwetkey;
  final TipePorto type;
  final Widget trailing;
  final bool isImageAvailable;

  void onPortoPressed(BuildContext context, FeedModel model) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    feedstate.getpostDetailFromDatabase(null, model: model);
    Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
  }

  @override
  Widget build(BuildContext context) {
    var feedstate = Provider.of<FeedState>(context, listen: false);
    return FutureBuilder(
      future: feedstate.fetchPorto(childRetwetkey),
      builder: (context, AsyncSnapshot<FeedModel> snapshot) {
        if (snapshot.hasData) {
          return Portofolio(
              model: snapshot.data,
              type: TipePorto.HubunganPorto,
              trailing: trailing);
        }
        if ((snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.waiting) &&
            !snapshot.hasData) {
          return UnavailablePorto(
            snapshot: snapshot,
            type: type,
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
