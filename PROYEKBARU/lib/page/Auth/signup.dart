import 'dart:math';

import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/enum.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/model/user.dart';
import 'package:findes3/page/Auth/widget/googleLoginButton.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:findes3/widgets/Widgetbarubaru2/customLoader.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final VoidCallback loginCallback;

  const Signup({Key key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmController;
  CustomLoader loader;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    loader = CustomLoader();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: fullHeight(context) - 88,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 80,
              height: 150,
              child: Image.asset('assets/images/model3.png'),
            ),
            _entryFeild('Nama', controller: _nameController),
            _entryFeild('Masukan email',
                controller: _emailController, isEmail: true),
            // _entryFeild('Mobile no',controller: _mobileController),
            _entryFeild('Masukan password',
                controller: _passwordController, isPassword: true),
            _entryFeild('Konfirmasi password',
                controller: _confirmController, isPassword: true),
            _submitButton(context),

            Divider(height: 30),
            SizedBox(height: 30),
            // _googleLoginButton(context),
            GoogleLoginButton(
              loginCallback: widget.loginCallback,
              loader: loader,
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.amber),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: AplikasiColor.dodgetBlue,
        onPressed: _submitForm,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Text('Daftar', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _googleLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
    if (state.isbusy) {
      return;
    }
    loader.showLoader(context);
    state.handleGoogleSignIn().then((status) {
      // print(status)
      if (state.user != null) {
        loader.hideLoader();
        Navigator.pop(context);
        widget.loginCallback();
      } else {
        loader.hideLoader();
        cprint('Unable to login', errorIn: '_googleLoginButton');
      }
    });
  }

  void _submitForm() {
    if (_emailController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Masukan Nama');
      return;
    }
    if (_emailController.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Tidak boleh lebih dari 27 karakter');
      return;
    }
    if (_emailController.text == null ||
        _emailController.text.isEmpty ||
        _passwordController.text == null ||
        _passwordController.text.isEmpty ||
        _confirmController.text == null) {
      customSnackBar(_scaffoldKey, 'perhatikan dalam pengetikan');
      return;
    } else if (_passwordController.text != _confirmController.text) {
      customSnackBar(_scaffoldKey, 'Password dan confirm password tidak cocok');
      return;
    }

    loader.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int nomorrandom = random.nextInt(8);

    User user = User(
      email: _emailController.text.toLowerCase(),
      bio: 'Edit profile untuk update bio',
      // contact:  _mobileController.text,
      displayName: _nameController.text,
      dob: 'www.findes.com',
      location: 'Lokasi belum ditentukan',
      profilePic:
          'https://www.polyflor.com.au/media/catalog/product/f/l/flaxen-9849.jpg',
    );
    state
        .signUp(
      user,
      password: _passwordController.text,
      scaffoldKey: _scaffoldKey,
    )
        .then((status) {
      print(status);
    }).whenComplete(
      () {
        loader.hideLoader();
        if (state.authStatus == AuthStatus.LOGGED_IN) {
          Navigator.pop(context);
          widget.loginCallback();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText(
          'Daftar',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
