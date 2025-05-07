import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(104, 121, 101, 1), 
                image: DecorationImage(
                  image: AssetImage('assets/images/background_2.png'), // Replace with your actual image file
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // child: Image.asset(
            //   "assets/images/background_2.png", // Replace with your actual image file
            //   fit: BoxFit.cover,
            // ),
          ),

          // Back & Camera Buttons
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Go back to main page
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/cameraPage",
                ); // Navigate to Camera Page
              },
            ),
          ),

          // Lottie Animation (Mage Walking)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3 - 100, // Adjust this value
            left: MediaQuery.of(context).size.width * 0.5 - 125, // Centers the animation
            child: Lottie.asset(
              'assets/walking_guy.json',
              width: 250,
              height: 250,
              repeat: true,
            ),
          ),


          // Scrollable White Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 350,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mage",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Genshin'
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Mana Level: 100%", style: TextStyle(fontSize: 18, fontFamily: 'Genshin')),
                    SizedBox(height: 10),
                    Text(
                      "Experience Points: 2500 XP",
                      style: TextStyle(fontSize: 18, fontFamily: 'Genshin'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
