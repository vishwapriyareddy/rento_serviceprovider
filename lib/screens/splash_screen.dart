import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roi_serviceprovider/screens/home_screen.dart';
import 'package:roi_serviceprovider/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => WelcomeScreen(),
      //     ));
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (mounted) {
          if (user == null) {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          } else {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: deviceHeight(context) * 0.09,
            left: deviceWidth(context) * 0.09,
            right: deviceWidth(context) * 0.09,
            bottom: deviceHeight(context) * 0.09,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/splash.png'),
              Text('ROI - Service Provider App',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}
