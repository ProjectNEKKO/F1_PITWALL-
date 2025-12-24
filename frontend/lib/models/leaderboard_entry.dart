class LeaderboardEntry {
  final int position;
  final String symbol; // "VER"
  final String name;   // "Max Verstappen"
  final String team;   // "Red Bull Racing"
  final String color;  // Hex code "3671C6"
  final String time;   // "1:29.708"

  LeaderboardEntry({
    required this.position,
    required this.symbol,
    required this.name,
    required this.team,
    required this.color,
    required this.time,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      position: json['position'],
      symbol: json['symbol'],
      name: json['name'],
      team: json['team'],
      color: json['color'],
      time: json['time'],
    );
  }
}