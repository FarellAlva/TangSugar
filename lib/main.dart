import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import "pages/base_page.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  try {
    
    if (Firebase.apps.isEmpty) {
     
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      
    } else {
     
    }
  } catch (e) {
    print("TANGSUGAR: Firebase initialization failed: $e");
   
  }

  try {
 
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
    print("TANGSUGAR: Firestore settings configured");
  } catch (e) {
    print("TANGSUGAR: Error setting Firestore settings: $e");
  }

  print("TANGSUGAR: Running App");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TangSugarrr',
      home: BasePage(),
    );
  }
}
