import 'package:flutter/material.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './models/models.dart';
import './redux/reducers/app_reducer.dart';
import './redux/redux.dart';
import './routes.dart';
import './screens/splash_screen.dart';
import './widgets/custom_future_builder.dart';

typedef StoreCreator = Store<AppState> Function(AppState);

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Store<AppState> store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      thunkMiddleware,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: const StoreConnector<AppState, _ViewModel>(
          distinct: true,
          converter: _ViewModel.fromStore,
          builder: _builder,
        ),
        onGenerateRoute: Routes.generator,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  static Widget _builder(BuildContext ctx, _ViewModel vm) => vm.isAuthenticated
      ? Routes.productsOverview.build(ctx)
      : CustomFutureBuilder(
          future: (_) => vm.tryAutoLogin(),
          waitingBuilder: (_) => const SplashScreen(),
          successBuilder: (data, ctx2) => data ? Routes.productsOverview.build(ctx2) : Routes.auth.build(ctx2),
        );
}

class _ViewModel {
  final bool isAuthenticated;
  final Future<bool> Function() tryAutoLogin;

  const _ViewModel({required this.isAuthenticated, required this.tryAutoLogin});

  static _ViewModel fromStore(Store<AppState> store) => _ViewModel(
        isAuthenticated: store.state.authSlice.isReady && store.state.authSlice.credential.isValid,
        tryAutoLogin: () => store.dispatch(TryAutoLogin()),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel && runtimeType == other.runtimeType && isAuthenticated == other.isAuthenticated;

  @override
  int get hashCode => isAuthenticated.hashCode;
}
