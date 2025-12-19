// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import "pages/base_page.dart";
import 'package:tangsugar/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {}
  } catch (e) {
    print("TANGSUGAR: Firebase initialization failed: $e");
  }

  try {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  } catch (e) {
    print("TANGSUGAR: Error setting Firestore settings: $e");
  }

  // Initialize Notification Service
  await NotificationService().init();

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
