import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_mitsu/views/taches/liste.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAj1MpYGZUnAx_rWx678WbLC0xAPN9rqZU',
      appId: '1:239947646467:android:0f11b7a5c810bec27b703',
      messagingSenderId: '239947646467',
      projectId: 'mitsu-digital',
      storageBucket: "mitsu-digital.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ListeTachePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

