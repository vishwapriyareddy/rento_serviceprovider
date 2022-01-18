import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roi_serviceprovider/screens/home_screen.dart';
import 'package:roi_serviceprovider/screens/login_screen.dart';
import 'package:roi_serviceprovider/provider/auth_provider.dart';
import 'package:roi_serviceprovider/screens/register_screen.dart';
import 'package:roi_serviceprovider/screens/reset_password.dart';
import 'package:roi_serviceprovider/screens/splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider(create: (_) => AuthProvider()),
  ], child: MyApp()));
  ;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  title: 'ROI Service Provider App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        RegisterScreen.id: (context) => RegisterScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
