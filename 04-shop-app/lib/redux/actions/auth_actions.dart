import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase.dart';
import '../../models/models.dart';
import '../state/state.dart';

class UpdateAuthCredential with JsonRepresentation {
  final AuthCredential credential;

  const UpdateAuthCredential._(this.credential);

  @override
  get jsonMap => {'credential': credential};
}

class Logout extends CallableThunkAction<AppState> {
  @override
  Future<void> call(store) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthCredential.prefsKey);
    store.dispatch(UpdateAuthCredential._(AuthCredential.invalid));
  }
}

class TryAutoLogin extends CallableThunkAction<AppState> {
  @override
  Future<bool> call(store) async {
    final prefs = await SharedPreferences.getInstance();
    final credentialData = prefs.getString(AuthCredential.prefsKey);
    if (credentialData == null) {
      return false;
    }
    var credential = AuthCredential.fromJson(json.decode(credentialData));
    var isValid = credential.isValid;
    if (!isValid) {
      // Remove the invalid credential
      await prefs.remove(AuthCredential.prefsKey);
    } else {
      credential = credential.withTimer(() => store.dispatch(Logout()));
    }
    store.dispatch(UpdateAuthCredential._(credential));
    return isValid;
  }
}

class Signup extends CallableThunkAction<AppState> {
  final String email, password;

  Signup(this.email, this.password);

  @override
  Future<void> call(store) async => _authenticate(store, 'signUp', email, password);
}

class Login extends CallableThunkAction<AppState> {
  final String email, password;

  Login(this.email, this.password);

  @override
  Future<void> call(store) async => _authenticate(store, 'signInWithPassword', email, password);
}

Future<void> _authenticate(Store<AppState> store, String path, String email, String password) async {
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

  final credential = AuthCredential(
    token: responseData['idToken'],
    userID: responseData['localId'],
    expiryDate: DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']))),
  ).withTimer(() => store.dispatch(Logout()));

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(AuthCredential.prefsKey, credential.toJsonRepresentation());

  store.dispatch(UpdateAuthCredential._(credential));
}
