import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  String _name = 'Service';
  String get name => _name;

  void setName(String newName) {
    _name = newName;
    notifyListeners();
  }
}
