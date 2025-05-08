import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _initialized = false;
  Uint8List? _annotatedImage;
  List<Map<String, dynamic>>? _detections;

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

  Future<Uint8List> _readExact(Socket socket, int length) async {
    final buffer = BytesBuilder();
    int remaining = length;
    while (remaining > 0) {
      final chunk = await socket.first;
      buffer.add(chunk);
      remaining -= chunk.length;
    }
    return buffer.toBytes();
  }

  Future<void> _captureAndSendImage() async {
    try {
      final XFile image = await _controller.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      final socket = await Socket.connect('192.168.222.214', 3000);

      final lengthPrefix = ByteData(4)
        ..setUint32(0, imageBytes.lengthInBytes, Endian.big);
      socket.add(lengthPrefix.buffer.asUint8List());
      socket.add(imageBytes);
      await socket.flush();

      final annotatedImageLengthBytes = await _readExact(socket, 4);
      final annotatedImageLength = ByteData.sublistView(
        annotatedImageLengthBytes,
      ).getUint32(0, Endian.big);
      final annotatedImageBytes = await _readExact(
        socket,
        annotatedImageLength,
      );

      final detectionsLengthBytes = await _readExact(socket, 4);
      final detectionsLength = ByteData.sublistView(
        detectionsLengthBytes,
      ).getUint32(0, Endian.big);
      final detectionsBytes = await _readExact(socket, detectionsLength);
      final detectionsJson = utf8.decode(detectionsBytes);
      final List<Map<String, dynamic>> detections =
          List<Map<String, dynamic>>.from(json.decode(detectionsJson));

      socket.destroy();

      setState(() {
        _annotatedImage = annotatedImageBytes;
        _detections = detections;
      });

      debugPrint('Image and detections received successfully!');
    } catch (e) {
      debugPrint('Error capturing or sending image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Centered camera preview with black frame
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 375,
              height: 600,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child:
                    _annotatedImage != null
                        ? Image.memory(_annotatedImage!, fit: BoxFit.cover)
                        : CameraPreview(_controller),
              ),
            ),
          ),

          // Focus square in center
          Center(
            child: Icon(
              Icons.center_focus_strong,
              color: Colors.white70,
              size: 40,
            ),
          ),

          // Capture button
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _captureAndSendImage,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
