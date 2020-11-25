import 'dart:io';

import 'package:flutter/material.dart';
import 'package:findes3/helper/variabelicon.dart';
import 'package:findes3/helper/theme.dart';
import 'package:findes3/widgets/icondll.dart';
import 'package:image_picker/image_picker.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final TextEditingController textEditingController2;
  final TextEditingController textEditingController3;
  final Function(File) onImageIconSelcted;
  ComposeBottomIconWidget(
      {Key key,
      this.textEditingController,
      this.textEditingController2,
      this.textEditingController3,
      this.onImageIconSelcted})
      : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() =>
      _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  Color wordCountColor;
  String porto = '';

  @override
  void initState() {
    wordCountColor = Colors.blue;
    widget.textEditingController.addListener(updateUI);
    super.initState();
  }

  void updateUI() {
    setState(() {
      porto = widget.textEditingController.text;
      if (widget.textEditingController.text != null &&
          widget.textEditingController.text.isNotEmpty) {
        if (widget.textEditingController.text.length > 259 &&
            widget.textEditingController.text.length < 280) {
          wordCountColor = Colors.orange;
        } else if (widget.textEditingController.text.length >= 280) {
          wordCountColor = Theme.of(context).errorColor;
        } else {
          wordCountColor = Colors.blue;
        }
      }
    });
  }

  Widget _bottomIconWidget() {
    return Container(
      alignment: Alignment.center,
      height: 200,
      decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor)),
          color: Theme.of(context).backgroundColor),
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                RaisedButton.icon(
                  onPressed: () {
                    setImage(ImageSource.gallery);
                  },
                  elevation: 2.0,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),
                  color: const Color(0xFFFFB822),
                  icon: Icon(Icons.file_upload),
                  label: Text(
                    "Upload image",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void setImage(ImageSource source) {
    ImagePicker.pickImage(source: source, imageQuality: 20).then((File file) {
      setState(() {
        // _image = file;
        widget.onImageIconSelcted(file);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bottomIconWidget(),
    );
  }
}
