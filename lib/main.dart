import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note/models/theme_provider.dart';
import 'package:note/pages/authentication_page.dart';
import 'package:provider/provider.dart';

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
  } catch (e) {
    if (kDebugMode) {
      print("Failed to initialize Firebase: $e");
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
