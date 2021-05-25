import 'dart:async';

import 'package:meta/meta.dart';

import './json_representation.dart';

@immutable
class AuthCredential with JsonRepresentation {
  static const prefsKey = 'auth_credential@shop_app';

  static Timer invalidTimer = Timer(const Duration(days: 1), () {})..cancel();

  static final invalid = AuthCredential(
    token: 'invalid',
    userID: 'invalid',
    expiryDate: DateTime.utc(-271821, 04, 20), // minimum value
    logoutTimer: invalidTimer,
  );

  final String token;
  final String userID;
  final DateTime expiryDate;
  final Timer logoutTimer;

  AuthCredential({
    required this.token,
    required this.userID,
    required this.expiryDate,
    Timer? logoutTimer,
  }) : this.logoutTimer = logoutTimer ?? invalidTimer;

  AuthCredential.fromJson(json)
      : this.token = json['token'],
        this.userID = json['userID'],
        this.expiryDate = DateTime.parse(json['expiryDate']),
        this.logoutTimer = invalidTimer;

  @override
  get jsonMap => {
        'token': token,
        'userID': userID,
        'expiryDate': expiryDate.toIso8601String(),
      };
}
