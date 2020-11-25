import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:provider/provider.dart';

class PortoImage extends StatelessWidget {
  const PortoImage({
    Key key,
    this.model,
    this.type,
  }) : super(key: key);

  final FeedModel model;
  final TipePorto type;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      alignment: Alignment.center,
      child: model.imagePath == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                top: 0,
              ),
              child: InkWell(
                onTap: () {
                  if (type == TipePorto.HubunganPorto) {
                    return;
                  }
                  var state = Provider.of<FeedState>(context, listen: false);
                  state.getpostDetailFromDatabase(model.key);
                  state.setPorto = model;
                  Navigator.of(context)
                      .pushNamed('/FeedPostDetail/' + model.key);
                },
                child: ClipRRect(
                  child: Container(
                    width: fullWidth(context) *
                            (type == TipePorto.Detail ? .95 : .9) -
                        8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: AspectRatio(
                      aspectRatio: 7 / 3,
                      child: customNetworkImage(model.imagePath,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
