import 'package:flutter/material.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customLoader.dart';
import 'package:findes3/widgets/Widgetbarubaru2/rippleButton.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({Key key, @required this.loader, this.loginCallback});
  final CustomLoader loader;
  final Function loginCallback;
  void _googleLogin(context) {
    var state = Provider.of<AuthState>(context, listen: false);
    loader.showLoader(context);
    state.handleGoogleSignIn().then((status) {
      // print(status)
      if (state.user != null) {
        loader.hideLoader();
        Navigator.pop(context);
        loginCallback();
      } else {
        loader.hideLoader();
        cprint('Unable to login', errorIn: '_googleLoginButton');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RippleButton(
      onPressed: () {
        _googleLogin(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xffeeeeee),
              blurRadius: 15,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: Wrap(
          children: <Widget>[
            Image.asset(
              'assets/images/google_logo.png',
              height: 20,
              width: 20,
            ),
            SizedBox(width: 10),
            TitleText(
              'Continue with Google',
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
