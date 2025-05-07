import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('習う', style: TextStyle(fontSize: 64, color: Colors.white)),
          SizedBox(height: 20),
          Text(
            'NARAU',
            style: TextStyle(
              fontSize: 48,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60),

          // Debug Buttons Section
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/'),
                child: Text('A'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/camera'),
                child: Text('B'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/photos'),
                child: Text('C'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/description'),
                child: Text('D'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
