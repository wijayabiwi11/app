class Validator {
  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) {
        return true;
      }
    }
    return false;
  }

  String validateEmail(String s) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(s)) {
      return 'Masukan email!';
    } else {
      return null;
    }
  }

  String validateName(String s) {
    if (_isNumeric(s)) {
      return 'Nama tidak valid, jangan terdapat angka!';
    }
    if (s.isEmpty) {
      return 'Masukan Nama!';
    }
    return null;
  }

  String validatePassword(String s) {
    if (s.isEmpty) {
      return 'Masukan Password!';
    }
    return null;
  }
}
//UNTUK VALIDASI USER
