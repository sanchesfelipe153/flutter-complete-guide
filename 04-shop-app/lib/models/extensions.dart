import 'dart:async';

import './auth_credential.dart';

extension AuthCredentialExtension on AuthCredential {
  bool get isValid => expiryDate.isAfter(DateTime.now());

  AuthCredential withTimer(Function() callback) {
    // Cancel the previous timer
    logoutTimer.cancel();

    // Creates the new timer
    final timer;
    final timeToExpire = expiryDate.difference(DateTime.now()).inSeconds;
    if (timeToExpire > 0) {
      timer = Timer(Duration(seconds: timeToExpire), callback);
    } else {
      timer = AuthCredential.invalidTimer;
    }
    return AuthCredential(
      token: token,
      userID: userID,
      expiryDate: expiryDate,
      logoutTimer: timer,
    );
  }
}
