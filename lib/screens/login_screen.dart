import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:roi_serviceprovider/screens/home_screen.dart';
import 'package:roi_serviceprovider/provider/auth_provider.dart';
import 'package:roi_serviceprovider/screens/register_screen.dart';
import 'package:roi_serviceprovider/screens/reset_password.dart';
import 'package:roi_serviceprovider/services/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String? email;
  String? password;
  Icon? icon;
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/splash.png',
                            height: 80,
                          ),
                          FittedBox(
                            child: const Text('SERVICE PROVIDER-LOGIN',
                                style: TextStyle(
                                    fontFamily: 'Anton',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        final bool _isValid = EmailValidator.validate(
                            _emailTextController.text.trim());
                        if (!_isValid) {
                          return 'Invalid Email Format';
                        }
                        setState(() {
                          email = value;
                        });
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        if (value.length < 6) {
                          return 'Minimun 6 characters';
                        }
                        setState(() {
                          password = value;
                        });
                        return null;
                      },
                      obscureText: _visible == false ? true : false,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Theme.of(context).primaryColor),
                    ),
                    //SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pushNamed(context, ResetPassword.id);
                    //       },
                    //       child: Text('Forgot Password ?',
                    //           textAlign: TextAlign.end,
                    //           style: TextStyle(
                    //               color: Colors.blue,
                    //               fontWeight: FontWeight.bold)),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show(status: 'Please Wait...');
                                  _services.validateUser(email).then((value) {
                                    if (value.exists) {
                                      if (value.get('password') == password) {
                                        _authData
                                            .loginBoys(email, password)
                                            .then((credential) {
                                          if (credential != null) {
                                            EasyLoading.showSuccess(
                                                    'Logged In Successfully')
                                                .then((value) {
                                              Navigator.pushReplacementNamed(
                                                  context, HomeScreen.id);
                                            });
                                          } else {
                                            EasyLoading.showInfo(
                                                    'Need to complete registration')
                                                .then((value) {
                                              _authData.getEmail(email);
                                              Navigator.pushNamed(
                                                  context, RegisterScreen.id);
                                            });
                                            // ScaffoldMessenger.of(context)
                                            //     .showSnackBar(SnackBar(
                                            //         content:
                                            //             Text(_authData.error)));
                                          }
                                        });
                                      } else {
                                        EasyLoading.showError(
                                            'Invalid Password..');
                                      }
                                    } else {
                                      // EasyLoading.showInfo(
                                      //         'Need to complete registration')
                                      //     .then((value) {
                                      //   _authData.getEmail(email);
                                      //   Navigator.pushNamed(
                                      //       context, RegisterScreen.id);
                                      // });
                                      EasyLoading.showError(
                                          '$email does not registered as our Service Provider');
                                    }
                                  });
                                }
                                // Navigator.pushReplacementNamed(context, LoginScreen.id);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    // SizedBox(height: 20),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.pushNamed(context, RegisterScreen.id);
                    //   },
                    //   child: Text('New Vendor?  Register here.',
                    //       textAlign: TextAlign.end,
                    //       style: TextStyle(
                    //           color: Colors.blue, fontWeight: FontWeight.bold)),
                    // ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
