import 'dart:io';

import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  File? _avatar;

  File? get avatar => _avatar;

  void setAvatar(File file) {
    _avatar = file;
    notifyListeners();
  }

  void clearAvatar() {
    _avatar = null;
    notifyListeners();
  }
}
