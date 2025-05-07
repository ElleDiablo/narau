import 'dart:io';
import 'dart:typed_data';
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

  /// Capture a photo, open a TCP socket, and send the raw bytes.
  Future<void> _captureAndSendImage() async {
    try {
      final XFile image = await _controller.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      // Connect to your TCP server (adjust IP & port)
      final socket = await Socket.connect('192.168.222.214', 3000);
      
      // OPTIONAL: send length prefix
      final lengthPrefix = ByteData(4)
        ..setUint32(0, imageBytes.lengthInBytes, Endian.big);
      socket.add(lengthPrefix.buffer.asUint8List());
      
      // Send image data
      socket.add(imageBytes);
      await socket.flush();
      socket.destroy();
      debugPrint('Image sent successfully!');
    } catch (e) {
      debugPrint('Error capturing or sending image: $e');
    }
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
          CameraPreview(_controller),

          // Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Bottom Controls with tap handler
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.green.shade900),
              child: Center(
                child: GestureDetector(
                  onTap: _captureAndSendImage,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 30),
                  ),
                ),
              ),
            ),
          ),

          // Title
          Positioned(
            top: 40,
            left: MediaQuery.of(context).size.width * 0.5 - 50,
            child: const Text(
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

