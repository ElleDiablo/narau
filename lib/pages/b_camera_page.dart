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

  /// Helper function to read exactly [length] bytes from the socket.
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

  /// Capture a photo, send it to the server, and receive the annotated image and detections.
  Future<void> _captureAndSendImage() async {
    try {
      final XFile image = await _controller.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();

      // Connect to your TCP server (adjust IP & port)
      final socket = await Socket.connect('192.168.222.214', 3000);

      // Send length prefix
      final lengthPrefix = ByteData(4)
        ..setUint32(0, imageBytes.lengthInBytes, Endian.big);
      socket.add(lengthPrefix.buffer.asUint8List());

      // Send image data
      socket.add(imageBytes);
      await socket.flush();

      // Receive annotated image
      final annotatedImageLengthBytes = await _readExact(socket, 4);
      final annotatedImageLength = ByteData.sublistView(annotatedImageLengthBytes).getUint32(0, Endian.big);
      final annotatedImageBytes = await _readExact(socket, annotatedImageLength);

      // Receive detections JSON
      final detectionsLengthBytes = await _readExact(socket, 4);
      final detectionsLength = ByteData.sublistView(detectionsLengthBytes).getUint32(0, Endian.big);
      final detectionsBytes = await _readExact(socket, detectionsLength);
      final detectionsJson = utf8.decode(detectionsBytes);
      final List<Map<String, dynamic>> detections = List<Map<String, dynamic>>.from(json.decode(detectionsJson));

      // Close the socket
      socket.destroy();

      // Update the UI with the received data
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          _annotatedImage != null
              ? Image.memory(_annotatedImage!)
              : CameraPreview(_controller),

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

          // Display detections
          if (_detections != null)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                color: Colors.white70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _detections!.map((detection) {
                    return Text(
                      'Class ID: ${detection['class_id']}, Score: ${detection['score'].toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


