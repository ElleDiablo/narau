import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller.initialize();
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.green.shade900),
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'NARAU',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
