import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';
import 'widgets/custom_future_builder.dart';

Future main() async {
  await DotEnv.load(fileName: 'assets/env/.env_firebase');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', const []),
          update: (_, auth, previous) => Products(auth.token ?? '', auth.userID ?? '', previous?.items ?? []),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', const []),
          update: (_, auth, previous) => Orders(auth.token ?? '', auth.userID ?? '', previous?.orders ?? []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, __) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuthenticated
              ? Routes.productsOverview.build(ctx)
              : CustomFutureBuilder(
                  future: (_) => auth.tryAutoLogin(),
                  waitingBuilder: (_) => SplashScreen(),
                  successBuilder: (data, ctx2) => data ? Routes.productsOverview.build(ctx2) : Routes.auth.build(ctx2),
                ),
          onGenerateRoute: Routes.generator,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
