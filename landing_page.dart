import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'loginpage.dart'; // Import the Login Page

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/TRUCK.mp4')
          ..initialize().then((_) {
            setState(() {}); // Refresh UI after initialization
          })
          ..play()
          ..setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Stack(
        children: [
          // Background Video
          Positioned.fill(
            child:
                _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : Center(child: CircularProgressIndicator()),
          ),

          // Overlay content
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Name / Header
                  Text(
                    "PRIME LOG",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                      letterSpacing: 3,
                    ),
                  ),
                  Spacer(), // Pushes the button down
                  // Get Started Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ), // Navigate to Login Page
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "GET STARTED",
                      style: GoogleFonts.lato(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  SizedBox(height: 50), // Adjust spacing from the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
