import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import './my_app.dart';

Future main() async {
  await DotEnv.load(fileName: 'assets/env/.env_firebase');
  runApp(const MyApp());
}
