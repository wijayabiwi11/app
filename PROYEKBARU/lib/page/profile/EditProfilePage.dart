import 'dart:io';
import 'package:flutter/material.dart';
import 'package:findes3/helper/utility.dart';
import 'package:findes3/state/authState.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _image;
  TextEditingController _name;
  TextEditingController _bio;
  TextEditingController _location;
  TextEditingController _dob;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _name = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    var state = Provider.of<AuthState>(context, listen: false);
    _name.text = state?.userModel?.displayName;
    _bio.text = state?.userModel?.bio;
    _location.text = state?.userModel?.location;
    _dob.text = state?.userModel?.dob;
    super.initState();
  }

  void dispose() {
    _name.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();
    super.dispose();
  }

  Widget _body() {
    var authstate = Provider.of<AuthState>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 180,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(authstate),
              ),
            ],
          ),
        ),
        _entry('Name', controller: _name),
        _entry('Bio', controller: _bio, maxLine: null),
        _entry('Location', controller: _location),
        _entry('Link', controller: _dob),
      ],
    );
  }

  Widget _userImage(AuthState authstate) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: customAdvanceNetworkImage(authstate.userModel.profilePic),
              fit: BoxFit.cover),
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundImage: _image != null
              ? FileImage(_image)
              : customAdvanceNetworkImage(authstate.userModel.profilePic),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: Center(
              child: IconButton(
                onPressed: uploadImage,
                icon: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entry(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void _submitButton() {
    if (_name.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Nama tidak boleh lebih dari 27 karakter');
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel.copyWith(
      key: state.userModel.userId,
      displayName: state.userModel.displayName,
      bio: state.userModel.bio,
      contact: state.userModel.contact,
      dob: state.userModel.dob,
      email: state.userModel.email,
      location: state.userModel.location,
      profilePic: state.userModel.profilePic,
      userId: state.userModel.userId,
    );
    if (_name.text != null && _name.text.isNotEmpty) {
      model.displayName = _name.text;
    }
    if (_bio.text != null && _bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_location.text != null && _location.text.isNotEmpty) {
      model.location = _location.text;
    }
    if (_dob.text != null && _dob.text.isNotEmpty) {
      model.dob = _dob.text;
    }
    state.updateUserProfile(model, image: _image);
    Navigator.of(context).pop();
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.amber),
        title: customTitleText('Profile Edit'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }
}
