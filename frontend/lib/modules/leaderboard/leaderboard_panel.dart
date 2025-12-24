import 'package:flutter/material.dart';
import '../../models/leaderboard_entry.dart';
import '../../services/api_service.dart';

class LeaderboardPanel extends StatefulWidget {
  const LeaderboardPanel({super.key});

  @override
  State<LeaderboardPanel> createState() => _LeaderboardPanelState();
}

class _LeaderboardPanelState extends State<LeaderboardPanel> {
  final ApiService _api = ApiService();
  List<LeaderboardEntry> _drivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final data = await _api.getLeaderboard();
      if (mounted) {
        setState(() {
          _drivers = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle error cleanly so app doesn't crash
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- NEW HELPER FUNCTION TO FIX THE CRASH ---
  String _formatTime(String rawTime) {
    if (rawTime == "No Time" || rawTime.isEmpty) {
      return "No Time";
    }
    
    // Safety check: Only substring if it's long enough
    // Expected format: "0 days 00:01:29.708000"
    // We want: "01:29.70"
    try {
      final parts = rawTime.split(' ');
      if (parts.isNotEmpty) {
        final timePart = parts.last; // "00:01:29.708000"
        if (timePart.length >= 8) {
          return timePart.substring(0, 8); // Safe truncation
        }
        return timePart; // Return full string if it's short
      }
    } catch (e) {
      return rawTime;
    }
    return rawTime;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: const Color(0xFF1E1E1E), 
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black26,
            width: double.infinity,
            child: const Text(
              "LIVE TIMING",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                letterSpacing: 1.5,
                color: Colors.grey
              ),
            ),
          ),
          
          // The List
          Expanded(
            child: ListView.builder(
              itemCount: _drivers.length,
              itemBuilder: (context, index) {
                final driver = _drivers[index];
                
                // Parse Color (Safety check included)
                Color teamColor;
                try {
                  teamColor = Color(int.parse("0xFF${driver.color}"));
                } catch (e) {
                  teamColor = Colors.grey;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white10)),
                  ),
                  child: Row(
                    children: [
                      // Position
                      SizedBox(
                        width: 25, 
                        child: Text(
                          "${driver.position}", 
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        )
                      ),
                      
                      // Team Color Stripe
                      Container(width: 4, height: 24, color: teamColor),
                      const SizedBox(width: 12),
                      
                      // Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(driver.team, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        )
                      ),
                      
                      // Time (USING THE NEW HELPER)
                      Text(
                        _formatTime(driver.time), 
                        style: const TextStyle(fontFamily: 'monospace')
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}