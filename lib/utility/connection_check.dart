import 'dart:io';


import 'package:flutter/material.dart';

class InternetConnectivity extends ChangeNotifier {
  static bool? isInternetAvilable;
  Future<void> checking() async {
    isInternetAvilable = true;
    notifyListeners();
    try {
      final result = await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetAvilable = true;
        notifyListeners();
      } else {
       
        isInternetAvilable = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      isInternetAvilable = false;
      notifyListeners();
    }
  }
}
