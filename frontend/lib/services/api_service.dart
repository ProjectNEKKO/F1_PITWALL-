import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/leaderboard_entry.dart';

class ApiService {
  // Android Emulator uses 10.0.2.2 to talk to localhost
  // iOS Simulator uses 127.0.0.1
  final String baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:8000' 
      : 'http://127.0.0.1:8000';

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/leaderboard'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => LeaderboardEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      print("Error fetching leaderboard: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getTelemetry(String driverSymbol) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/telemetry/$driverSymbol'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load telemetry');
      }
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }
}