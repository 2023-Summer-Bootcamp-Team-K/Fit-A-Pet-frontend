import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  late String _username = '';
  late String _userage = '';
  late String _userfood = '';
  late String _usercount = '';
  late String _usergender = '';
  late String _userspecie = '';
  late String _usersupplement = '';
  late String _usersensorwear = '';
  late String _userImage = '';

  String get username => _username;
  String get userage => _userage;
  String get userfood => _userfood;
  String get usercount => _usercount;
  String get usergender => _usergender;
  String get userspecie => _userspecie;
  String get usersupplement => _usersupplement;
  String get usersensorwear => _usersensorwear;
  String get userImage => _userImage;

  set username(String username) {
    _username = username;
    notifyListeners();
  }

  set userage(String userage) {
    _userage = userage;
    notifyListeners();
  }

  set userfood(String userfood) {
    _userfood = userfood;
    notifyListeners();
  }

  set usercount(String usercount) {
    _usercount = usercount;
    notifyListeners();
  }

  set usergender(String usergender) {
    _usergender = usergender;
    notifyListeners();
  }

  set usersupplement(String usersupplement) {
    _usersupplement = usersupplement;
    notifyListeners();
  }

  set userspecie(String userspecie) {
    _userspecie = userspecie;
    notifyListeners();
  }

  set usersensorwear(String usersensorwear) {
    _usersensorwear = usersensorwear;
    notifyListeners();
  }

  set userImage(String userImage) {
    _userImage = userImage;
    notifyListeners();
  }
}
