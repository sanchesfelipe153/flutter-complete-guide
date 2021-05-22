import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  static const _userDataKey = 'userData@shop_app';

  String? _token;
  DateTime? _expiryDate;
  String? _userID;
  Timer? _authTimer;

  bool get isAuthenticated => token != null;

  String? get token {
    final expiryDate = _expiryDate;
    if (expiryDate != null && expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    _token = null;
    _expiryDate = null;
    _userID = null;
    return null;
  }

  String? get userID => _userID;

  Future<void> signup(String email, String password) {
    return _authenticate('signUp', email, password);
  }

  Future<void> login(String email, String password) {
    return _authenticate('signInWithPassword', email, password);
  }

  Future<void> _authenticate(String path, String email, String password) async {
    final response = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$path?key=${Firebase.apiKey}'),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }

    _token = responseData['idToken'];
    _userID = responseData['localId'];
    _expiryDate = DateTime.now().add(
      Duration(seconds: int.parse(responseData['expiresIn'])),
    );

    _autoLogout();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _userDataKey,
      json.encode({
        'token': _token,
        'userID': _userID,
        'expiryDate': _expiryDate!.toIso8601String(),
      }),
    );
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expiryDate = null;
    _authTimer?.cancel();
    _authTimer = null;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_userDataKey);
  }

  void _autoLogout() {
    _authTimer?.cancel();
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final userData = prefs.getString(_userDataKey);
    if (userData == null) {
      return isAuthenticated;
    }

    final extractedUserData = json.decode(userData);
    _token = extractedUserData['token'];
    _userID = extractedUserData['userID'];
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    return isAuthenticated;
  }
}
