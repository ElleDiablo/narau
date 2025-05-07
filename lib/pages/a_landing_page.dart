import 'package:flutter/material.dart';
import '../misc/ripple_model.dart';
import '../misc/ripple_painter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final List<Ripple> _ripples = [];

void _addRipple(Offset position) {
    late AnimationController controller;

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
        setState(() {
          _ripples.removeWhere((r) => r.controller == controller);
        });
      }
    });

    final ripple = Ripple(position: position, controller: controller);
    setState(() => _ripples.add(ripple));
    controller.forward();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _addRipple(details.localPosition),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Ripples layer
            CustomPaint(painter: RipplePainter(_ripples)),

            // Centered Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '習う',
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontFamily: 'keifont',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'NARAU',
                    style: TextStyle(
                      fontSize: 90,
                      letterSpacing: -4,
                      color: Colors.white,
                      fontFamily: 'Dissfunction',
                    ),
                  ),
                  SizedBox(height: 60),
                  Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                        child: Text('A'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/camera'),
                        child: Text('B'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/photos'),
                        child: Text('C'),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushNamed(context, '/description'),
                        child: Text('D'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
