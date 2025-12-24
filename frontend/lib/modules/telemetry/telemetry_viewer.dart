import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/api_service.dart';

class TelemetryViewer extends StatefulWidget {
  final String driverSymbol; // We pass "VER" or "HAM" into this widget
  final Color driverColor;   // We pass the team color

  const TelemetryViewer({
    super.key, 
    required this.driverSymbol,
    required this.driverColor,
  });

  @override
  State<TelemetryViewer> createState() => _TelemetryViewerState();
}

class _TelemetryViewerState extends State<TelemetryViewer> {
  final ApiService _api = ApiService();
  List<FlSpot> _speedPoints = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTelemetry();
  }

  // Reload if the parent passes a new driver (e.g., User clicked Perez)
  @override
  void didUpdateWidget(TelemetryViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.driverSymbol != widget.driverSymbol) {
      _loadTelemetry();
    }
  }

  void _loadTelemetry() async {
    setState(() => _isLoading = true);
    
    final data = await _api.getTelemetry(widget.driverSymbol);
    
    if (data.containsKey('telemetry')) {
      List<dynamic> points = data['telemetry'];
      List<FlSpot> spots = points.map((p) {
        return FlSpot(p['dist'], p['speed']); // X = Distance, Y = Speed
      }).toList();

      if (mounted) {
        setState(() {
          _speedPoints = spots;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_speedPoints.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "${widget.driverSymbol} - SPEED TRACE",
            style: TextStyle(
              color: widget.driverColor, 
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(show: false), // Hide messy axis labels for now
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _speedPoints,
                    isCurved: false,
                    color: widget.driverColor,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true, 
                      color: widget.driverColor.withOpacity(0.2)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}