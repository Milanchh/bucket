import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS S3 Picture Frame',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PictureFrameApp(),
    );
  }
}

class PictureFrameApp extends StatefulWidget {
  const PictureFrameApp({super.key});

  @override
  State<PictureFrameApp> createState() => _PictureFrameAppState();
}

class _PictureFrameAppState extends State<PictureFrameApp> {
  final List<String> _imageUrls = [
    'https://milanb.s3.amazonaws.com/van.png',
    'https://milanb.s3.amazonaws.com/tor.png',
  ];
  int _currentIndex = 0;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _imageUrls.length;
        });
      }
    });
  }

  void _togglePauseResume() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Picture Frame'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent, width: 10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              _imageUrls[_currentIndex],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text('Failed to load image'),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePauseResume,
        tooltip: _isPaused ? 'Resume' : 'Pause',
        child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
