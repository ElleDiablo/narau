import 'package:flutter/material.dart';
import 'package:camera/camera.dart';                 // camera plugin :contentReference[oaicite:0]{index=0}

// Entry point: fetch cameras, then launch the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();         // required before using plugins :contentReference[oaicite:1]{index=1}
  final cameras = await availableCameras();          // get list of device cameras :contentReference[oaicite:2]{index=2}
  runApp(MyApp(cameras: cameras));                   // pass cameras into the app
}

// The top‑level widget
class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real‑Time Classifier',
      theme: ThemeData.dark(),
      home: CameraScreen(cameras: cameras),           // show our camera UI
    );
  }
}

// A simple screen that displays the camera preview
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // pick the first (rear) camera
    _controller = CameraController(
      widget.cameras.first,                         // rear camera :contentReference[oaicite:3]{index=3}
      ResolutionPreset.medium,                      // moderate resolution :contentReference[oaicite:4]{index=4}
      enableAudio: false,
    );
    await _controller.initialize();                 // open the camera 
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller.dispose();                          // free resources 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),                 // live camera feed :contentReference[oaicite:7]{index=7}
          // Here you can overlay your classification labels, e.g.:
          const Positioned(
            bottom: 20, left: 20,
            child: Text('Label: …', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

