import 'package:flutter/material.dart';

class DescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Center(child: TriangleWidget()),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: Text(
                'Object Name\n' + 'a' * 250,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8),
              child: Text(
                'Description\nRarity:\nType:\nThreat:\nCurrent Status:\nWeakness:\nAffiliation:',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TriangleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(40, 40), painter: TrianglePainter());
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.shade600;
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
