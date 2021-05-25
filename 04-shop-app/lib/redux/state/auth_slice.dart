import 'package:meta/meta.dart';

import '../../models/models.dart';

@immutable
class AuthSlice with JsonRepresentation {
  final AuthCredential credential;
  final bool isReady;

  AuthSlice({
    required this.credential,
    required this.isReady,
  });

  AuthSlice.fromJson(json)
      : this.credential = AuthCredential.fromJson(json['credential']),
        this.isReady = json['isReady'];

  AuthSlice.initial()
      : this.credential = AuthCredential.invalid,
        this.isReady = false;

  @override
  get jsonMap => {
        'credential': credential,
        'isReady': isReady,
      };
}
