import 'package:flutter/material.dart';
import 'package:frontend/modules/telemetry/telemetry_viewer.dart';
// 1. Import the new Leaderboard Widget
import '../modules/leaderboard/leaderboard_panel.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ---------------------------
          // ZONE A: SIDEBAR (Navigation)
          // ---------------------------
          NavigationRail(
            backgroundColor: const Color(0xFF1E1E1E),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.only(bottom: 20.0, top: 20.0),
              child: Icon(Icons.speed, color: Colors.redAccent, size: 40), // App Logo
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics, color: Colors.redAccent),
                label: Text('Telemetry'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map, color: Colors.redAccent),
                label: Text('Track'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings, color: Colors.redAccent),
                label: Text('Config'),
              ),
            ],
          ),
          
          const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),

          // ---------------------------
          // ZONE B: MAIN STAGE (60%)
          // ---------------------------
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black12,
              // USE THE NEW VIEWER HERE (Hardcoded to Max for testing)
              child: const TelemetryViewer(
                driverSymbol: "VER", 
                driverColor: Colors.blueAccent, // Red Bull Blue
              ),
            ),
          ),

          const VerticalDivider(thickness: 1, width: 1, color: Colors.white10),

          // ---------------------------
          // ZONE C: INFO PANEL (25%)
          // ---------------------------
          const Expanded(
            flex: 1, // Takes up 1 part of space
            // 2. Use the new widget here instead of the empty Container
            child: LeaderboardPanel(), 
          ),
        ],
      ),
    );
  }
}