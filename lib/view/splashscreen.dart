import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_final/view/homescreen.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
    
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return  Scaffold(
      body: Container(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/splash_pic.jpg',
              fit: BoxFit.cover,
              width: width * 0.9,
              height: height * 0.5,),
              SizedBox(height: height * 0.04,),
              Text('Flash News', style: GoogleFonts.roboto(
                letterSpacing: 0.6,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              ),
              SizedBox(height: height * 0.04,),
              const SpinKitCircle(
                color: Colors.red
              )
            ],
          ),
        )
      ),
    );
  }
}