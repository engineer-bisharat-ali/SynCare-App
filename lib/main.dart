// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:provider/provider.dart';
// signup_screen.dart';
import 'package:syncare/pages/intro_screens/splash_screen.dart';
import 'package:syncare/provider/records_provider.dart';
import 'package:syncare/provider/symptom_provider.dart';
// import 'package:syncare/pages/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize hive
  await Hive.initFlutter();
  //register adapter
  Hive.registerAdapter(MedicalRecordAdapter());
  //open box
  await Hive.openBox('medical_records');

  //initialize firebase
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecordsProvider()),
        ChangeNotifierProvider(create: (_) => SymptomProvider()..loadSymptoms()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
