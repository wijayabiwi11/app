import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/model/portoModel.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/state/discoverState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customLoader.dart';
import 'package:findes3/widgets/Widgetbarubaru2/emptyList.dart';
import 'package:findes3/widgets/porto/Portofolio.dart';
import 'package:findes3/widgets/porto/widgets/actioniconporto.dart';
import 'package:provider/provider.dart';

class PortofolioPage extends StatelessWidget {
  const PortofolioPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Container(
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: () async {
            var feedState = Provider.of<FeedState>(context, listen: false);
            feedState.getDataFromDatabase();
            return Future.value(true);
          },
          child: _PortofolioPageBody(
            refreshIndicatorKey: refreshIndicatorKey,
            scaffoldKey: scaffoldKey,
          ),
        ),
      ),
    );
  }
}

class _PortofolioPageBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const _PortofolioPageBody(
      {Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);
  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
        child:
            customImage(context, authState.userModel?.profilePic, height: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Consumer<FeedState>(
      builder: (context, state, child) {
        final List<FeedModel> list = state.getPortoList(authstate.userModel);
        return CustomScrollView(
          slivers: <Widget>[
            child,
            state.isBusy && list == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: fullHeight(context) - 135,
                      child: CustomScreenLoader(
                        height: double.infinity,
                        width: fullWidth(context),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : !state.isBusy && list == null
                    ? SliverToBoxAdapter(
                        child: EmptyList(
                          'Belum ada portfolio',
                          subTitle:
                              'Tambahkann portfolio dengan menekan tombol tambah!',
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          list.map(
                            (model) {
                              return Container(
                                color: Colors.white,
                                child: Portofolio(
                                  model: model,
                                  trailing: PortoBottomSheet().portoOptionIcon(
                                    context,
                                    model,
                                    TipePorto.Porto,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
          ],
        );
      },
      child: SliverAppBar(
        floating: true,
        elevation: 0,
        leading: _getUserAvatar(context),
        title: customTitleText('Portfolio Saya'),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Colors.yellow[200],
        bottom: PreferredSize(
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
          preferredSize: Size.fromHeight(0.0),
        ),
      ),
    );
  }
}
