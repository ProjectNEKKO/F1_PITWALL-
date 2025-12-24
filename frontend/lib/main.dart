import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Connects to your new Firebase project
  runApp(const PitwallApp());
}

class PitwallApp extends StatelessWidget {
  const PitwallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_tethering, color: Colors.greenAccent, size: 64),
              SizedBox(height: 20),
              Text(
                "Pitwall Online",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text("Connected to New Firebase Project"),
            ],
          ),
        ),
      ),
    );
  }
}