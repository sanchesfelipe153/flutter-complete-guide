import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../state/state.dart';

final authReducer = combineReducers<AuthSlice>([
  TypedReducer<AuthSlice, UpdateAuthCredential>(
    (_, action) => AuthSlice(
      credential: action.credential,
      isReady: true,
    ),
  ),
]);
