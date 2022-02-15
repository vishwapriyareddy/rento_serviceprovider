import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:roi_serviceprovider/screens/login_screen.dart';
import 'package:roi_serviceprovider/services/firebase_services.dart';
import 'package:roi_serviceprovider/widgets/order_summary_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _user = FirebaseAuth.instance.currentUser!;
  FirebaseServices _services = FirebaseServices();
  int tag = 0;
  String? status;
  List<String> options = [
    'All',
    'Accepted',
    'On the Way',
    'Service Start',
    'Service Completed',
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: ElevatedButton(
                onPressed: () {
                  // auth.error = '';
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                  // FirebaseAuth.instance.signOut().whenComplete(() {
                  //   FirebaseAuth.instance
                  //       .authStateChanges()
                  //       .listen((User? user) {
                  //     if (mounted) {
                  //       if (user == null) {
                  //         Navigator.pushReplacementNamed(
                  //             context, LoginScreen.id);
                  //       }
                  //     }
                  //   });
                  // });
                },
                child: Text('Sign Out')),
            //backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
            title: const Text(
              'My Orders',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  child: ChipsChoice<int>.single(
                    value: tag,
                    onChanged: (val) {
                      if (val == 0) {
                        setState(() {
                          status = null;
                        });
                      }
                      setState(() {
                        tag = val;
                        if (tag > 0) {
                          status = options[val];
                        }
                      });
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v,
                    ),
                    choiceStyle: C2ChoiceStyle(
                      color: Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _services.orders
                      .where('serviceProvider.phone',
                          isEqualTo: _user.phoneNumber)
                      .where('orderStatus', isEqualTo: tag == 0 ? null : status).orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.size == 0) {
                      return Center(child: Text("No $status Orders"));
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return OrderSummaryCard(
                              document: document,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                  // ); Center(
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Text('home Screen'),
                  //       SizedBox(height: 30),
                  //       ElevatedButton(
                  //           onPressed: () {
                  //             // auth.error = '';
                  //             FirebaseAuth.instance.signOut().whenComplete(() {
                  //               FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  //                 if (user == null) {
                  //                   Navigator.pushReplacementNamed(context, LoginScreen.id);
                  //                 }
                  //               });
                  //             });
                  //           },
                  //           child: Text('Sign Out')),
                  //     ],
                  //   ),
                ),
              ],
            ),
          )),
    );
  }
}
