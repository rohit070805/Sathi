import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sathi/loginscreen.dart';
import 'package:sathi/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? _user;
  void _checkUserStatus(){
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });
    if(_user != null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>BottomNavigate()),);
    }
    else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen()),);
    }

  }
  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds: 4),(){
      _checkUserStatus();

      });
  }
  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: mediaquery.size.width*0.7,
          height: mediaquery.size.height*0.4,
          child: Lottie.asset('assets/animations/handshake.json',
          repeat: true,
          ),
        ),
      ),
    );
  }
}
