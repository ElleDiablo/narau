import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pages/a_landing_page.dart';
import 'pages/b_camera_page.dart';
import 'pages/c_photo_page.dart';
import 'pages/d_description_page.dart';


late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(NarauApp());
}

class NarauApp extends StatelessWidget {
  const NarauApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Narau',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
              '/': (context) => LandingPage(),
              '/camera': (context) => CameraPage(cameras: cameras),
              '/photos': (context) => PhotoPage(), // <- Add this
              '/description': (context) => DescriptionPage(), // <- Add this
            }

    );
  }
}
