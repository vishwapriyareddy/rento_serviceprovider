import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:roi_serviceprovider/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServices {
  FirebaseServices _services = FirebaseServices();
  Color? statusColor(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Colors.red;
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Colors.purple[900];
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Colors.pink[900];
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon? statusIcon(DocumentSnapshot document) {
    if (document.get('orderStatus') == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Rejected') {
      return Icon(
        Icons.assignment_late_outlined,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'On the Way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Start') {
      return Icon(
        Icons.sailing,
        color: statusColor(document),
      );
    }
    if (document.get('orderStatus') == 'Service Completed') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  Widget? statusContainer(DocumentSnapshot document, context) {
    FirebaseServices _services = FirebaseServices();
    if (document.get('serviceProvider')['name'].length > 1) {
      if (document.get('orderStatus') == 'Accepted') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'On the Way')
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order Status is changed to on the way');
                });
              },
              child: Text('Update Status to on the way',
                  style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(statusColor(document))),
            ),
          ),
        );
      }
      if (document.get('orderStatus') == 'On the Way') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Service Start')
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order Status is changed to Service Start');
                });
              },
              child: Text('Update Status to Service Start',
                  style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(statusColor(document))),
            ),
          ),
        );
      }
      if (document.get('orderStatus') == 'Service Start') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Service Completed')
                    .then((value) {
                  EasyLoading.showSuccess(
                      'Order Status is changed to Service Completed');
                });
              },
              child: Text('Update Status to Service Completed',
                  style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(statusColor(document))),
            ),
          ),
        );
      }
      //  if (document.get('orderStatus') == 'Service Completed') {
      return Container(
        color: Colors.grey[300],
        height: 30,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: () {
            // EasyLoading.show();
            // _services
            //     .updateStatus(id: document.id, status: 'Service Completed')
            //     .then((value) {
            //   EasyLoading.showSuccess(
            //       'Order Status is changed to Service Completed');
            // });
          },
          child: Text('Order Completed', style: TextStyle(color: Colors.white)),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green)),
        ),
      );
      //}
    }

    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                showMyDialog('Accept Order', 'Accepted', document.id, context);
              },
              child: Text('Accept', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AbsorbPointer(
              absorbing:
                  document.get('orderStatus') == 'Rejected' ? true : false,
              child: TextButton(
                onPressed: () {
                  showMyDialog(
                      'Reject Order', 'Rejected', document.id, context);
                },
                child: Text('Reject', style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        document.get('orderStatus') == 'Rejected'
                            ? Colors.grey
                            : Colors.red)),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();

    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Are you sure ?'),
            actions: [
              TextButton(
                onPressed: () {
                  // EasyLoading.show(status: 'Updating status');
                  // status == 'Accepted'
                  //     ? _orderServices
                  //         .updateOrderStatus(documentId, status)
                  //         .then((value) {
                  //         EasyLoading.showSuccess('Updated successfully');
                  //       })
                  //     : _orderServices
                  //         .updateOrderStatus(documentId, status)
                  //         .then((value) {
                  //         EasyLoading.showSuccess('Updated successfully');
                  //       });
                  // Navigator.pop(context);
                },
                child: Text('OK',
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                // style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ],
          );
        });
  }

  void launchCall(number) async {
    if (!await launch(number)) throw 'Could not launch $number';
  }

  void launchMap(lat, long, name) async {
    final availableMaps = await MapLauncher.installedMaps;
    //print(
    //  availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(lat, long),
      title: name,
    );
  }
}
