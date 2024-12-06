import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_fb/firebase_options.dart';
import 'package:todo_with_fb/screen/home.dart';
import 'package:todo_with_fb/screen/splashScreen.dart';

Future<void> main() async {
  //connectivity with firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // retrieved data form firebase.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(),
    );
  }
}
