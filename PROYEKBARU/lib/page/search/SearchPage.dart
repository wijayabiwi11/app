import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/state/cariState.dart';
import 'package:findes3/state/cariState2.dart';
import 'package:findes3/widgets/AppBar.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customUrlText.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';
import 'package:findes3/state/discoverState.dart';
import '../../helper/enum.dart';
import 'package:findes3/widgets/porto/Portofolio.dart';
import 'package:findes3/widgets/porto/widgets/actioniconporto.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchFeedState>(context, listen: false);
      state.resetFilterList();
    });
    super.initState();
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/TrendsPage');
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchFeedState>(context);

    var feedState = Provider.of<FeedState>(context, listen: false);
    final list = state.feedlist;
    print("panjang");
    print(list.length);
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        onActionPressed: onSettingIconPressed,
        onSearchChanged: (text) {
          print("text : ${text}");
          state.filterByfeed(text);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var state = Provider.of<SearchFeedState>(context, listen: false);
          var feedState = Provider.of<FeedState>(context, listen: false);
          feedState.getDataFromDatabase();
          state.getDataFromDatabase();
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Column(
            children: list.map(
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
        ),
        // child: ListView.separated(
        //   addAutomaticKeepAlives: false,
        //   physics: BouncingScrollPhysics(),
        //   itemBuilder: (context, index) => Container(
        //     color: Colors.white,
        //     child: Text("${list.elementAt(index).description}"),
        //   ),
        //   separatorBuilder: (_, index) => Divider(
        //     height: 0,
        //   ),
        //   itemCount: list?.length ?? 0,
        // ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key key, this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        kAnalytics.logViewSearchResults(searchTerm: user.userName);
        Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
      },
      leading: customImage(context, user.profilePic, height: 40),
      subtitle: Text(user.userName),
    );
  }
}
