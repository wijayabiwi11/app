import 'package:flutter/material.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/page/Auth/signup.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/Widgetbarubaru2/title_text.dart';
import 'package:provider/provider.dart';
import '../homePage.dart';
import 'signin.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: AplikasiColor.dodgetBlue,
        onPressed: () {
          var state = Provider.of<AuthState>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(loginCallback: state.getCurrentUser),
            ),
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TitleText('Buat akun', color: Colors.white),
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 80,
              height: 150,
              child: Image.asset('assets/images/icon-480.png'),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 80,
              height: 200,
              child: Image.asset('assets/images/model2.png'),
            ),
            Spacer(),
            TitleText(
              'Cari Freelancer dan Client dan mulai bekerja sama!',
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(
              height: 20,
            ),
            _submitButton(),
            Spacer(),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                TitleText(
                  'Sudah punya akun?',
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
                InkWell(
                  onTap: () {
                    var state = Provider.of<AuthState>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignIn(loginCallback: state.getCurrentUser),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: TitleText(
                      ' Masuk',
                      fontSize: 17,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN ||
              state.authStatus == AuthStatus.NOT_DETERMINED
          ? _body()
          : HomePage(),
    );
  }
}
