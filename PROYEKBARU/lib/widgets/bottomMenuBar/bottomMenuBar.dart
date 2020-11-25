// import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/state/appState.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/bottomMenuBar/itemBottomMenuBar.dart';
import 'package:provider/provider.dart';
import '../icondll.dart';
// import 'customBottomNavigationBar.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({this.pageController});
  final PageController pageController;
  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  PageController _pageController;
  int _selectedIcon = 0;
  @override
  void initState() {
    _pageController = widget.pageController;
    super.initState();
  }

  Widget _iconRow() {
    var state = Provider.of<AppState>(
      context,
    );

    return Container(
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 25.0,
                      width: MediaQuery.of(context).size.width / 1 - 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _icon(
                            null,
                            0,
                            icon: 0 == state.pageIndex
                                ? AppIcon.icondoctextinv
                                : AppIcon.icondoctextinv,
                            isCustomIcon: true,
                          ),
                          _icon(null, 1,
                              icon: 1 == state.pageIndex
                                  ? AppIcon.iconthlist
                                  : AppIcon.iconthlist,
                              isCustomIcon: true),
                          _icon(null, 2,
                              icon: 2 == state.pageIndex
                                  ? AppIcon.iconcommentinvalt2
                                  : AppIcon.iconcommentinvalt2,
                              isCustomIcon: true),
                          _icon(null, 3,
                              icon: 3 == state.pageIndex
                                  ? AppIcon.iconbellalt
                                  : AppIcon.iconbellalt,
                              isCustomIcon: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon(IconData iconData, int index,
      {bool isCustomIcon = false, int icon, String text}) {
    var state = Provider.of<AppState>(
      context,
    );
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: Duration(milliseconds: ANIM_DURATION),
          curve: Curves.easeIn,
          alignment: Alignment(0, ICON_ON),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: ANIM_DURATION),
            opacity: ALPHA_ON,
            child: IconButton(
              icon: isCustomIcon
                  ? customIcon(context,
                      icon: icon,
                      text: text,
                      size: 18,
                      istwitterIcon: true,
                      isEnable: index == state.pageIndex)
                  : Icon(
                      iconData,
                      color: index == state.pageIndex
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.caption.color,
                    ),
              onPressed: () {
                setState(() {
                  _selectedIcon = index;
                  state.setpageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
