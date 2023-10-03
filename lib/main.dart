import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usermanagementapp/firebase_options.dart';
import 'package:usermanagementapp/screens/authenticate/login.dart';
import 'package:usermanagementapp/screens/authenticate/register.dart';
import 'package:usermanagementapp/wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Wrapper(),
    );
  }
}
