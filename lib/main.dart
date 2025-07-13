import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncare/models/medical_records.dart';
import 'package:provider/provider.dart';
import 'package:syncare/pages/auths/auth_gate.dart';
import 'package:syncare/provider/bmi_provider.dart';
import 'package:syncare/provider/diabetes_prediction_provider.dart';
import 'package:syncare/provider/records_provider.dart';
import 'package:syncare/provider/symptom_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize hive
  await Hive.initFlutter();
  //register adapter
  Hive.registerAdapter(MedicalRecordAdapter());
  
  //initialize firebase
  await Firebase.initializeApp();

  //load environment variables
  await dotenv.load();
  //initialize supabase
   await Supabase.initialize(
   url: dotenv.env['SUPABASE_URL']!,        
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!, 
  );
  
  runApp(
    MultiProvider(
      providers: [
        // Providers for various functionalities
        ChangeNotifierProvider(create: (_) => RecordsProvider()), // Provider for managing medical records
        ChangeNotifierProvider(create: (_) => SymptomProvider()..loadSymptoms()), // Provider for managing symptoms with initial load
        ChangeNotifierProvider(create: (_) => DiabetesProvider()), // Provider for managing diabetes
        ChangeNotifierProvider(create: (context) => BMIProvider()), // Provider for managing BMI
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
