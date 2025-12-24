import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Import our new layout
import 'layout/dashboard_layout.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PitwallApp());
}

class PitwallApp extends StatelessWidget {
  const PitwallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'F1 Pitwall',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        // F1 Red Accent Color
        primaryColor: Colors.redAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.redAccent,
          secondary: Colors.white,
        ),
      ),
      // This is the switch: Load the Dashboard instead of the test screen
      home: const DashboardLayout(), 
    );
  }
}