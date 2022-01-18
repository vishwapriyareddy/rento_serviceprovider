import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roi_serviceprovider/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('home Screen'),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                // auth.error = '';
                FirebaseAuth.instance.signOut().whenComplete(() {
                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    if (user == null) {
                      Navigator.pushReplacementNamed(context, LoginScreen.id);
                    }
                  });
                });
              },
              child: Text('Sign Out')),
        ],
      ),
    ));
  }
}
