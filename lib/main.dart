import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/pages/authentication_page.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyASpvYKs9w4NMUOF0U1eNY0xzBc1TZAzUs',
        appId: '1:1056314075041:android:6ca90ba0bda6ae72ee0de0',
        messagingSenderId: '1056314075041',
        projectId: 'note-application-495c4',
      ),
    );
    runApp(const MyApp());
  } catch (e) {
    if (kDebugMode) {
      print("Failed to initialize Firebase: $e");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
