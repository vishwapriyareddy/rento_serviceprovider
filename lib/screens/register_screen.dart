// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_serviceprovider/provider/auth_provider.dart';
import 'package:roi_serviceprovider/widgets/image_picker.dart';
import 'package:roi_serviceprovider/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: const [
                ServicePicCard(),
                RegisterForm(),
              ])),
        )),
      ),
    );
  }
}
