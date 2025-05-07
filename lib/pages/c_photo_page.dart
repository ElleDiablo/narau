import 'package:flutter/material.dart';

// Widget build(BuildContext context) {
//   return Center(child: Lottie.asset('assets/walking_guy.json', repeat: true));
// }

class PhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Detected Objects'),
        backgroundColor: Colors.green.shade900,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        color: Colors.grey.shade300,
        child: Column(
          children: [
            TriangleWidget(color: Colors.green),
            SizedBox(height: 20),
            TriangleWidget(color: Colors.green.shade700),
          ],
        ),
      ),
    );
  }
}
class TriangleWidget extends StatelessWidget {
  final Color color;
  TriangleWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(40, 40),
      painter: TrianglePainter(color: color),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path =
        Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
