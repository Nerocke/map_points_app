import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const MapPointsApp());
}

class MapPointsApp extends StatelessWidget {
  const MapPointsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Points',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}
