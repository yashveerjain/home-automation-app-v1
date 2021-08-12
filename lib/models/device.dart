
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Device with ChangeNotifier {
  int? GPIOPin;
  String deviceName;
  final String? id;

  bool switchState;

  Device({
    required this.GPIOPin,
    required this.deviceName,
    required this.id,
    this.switchState=false});

  Future<void> toggleSwitch() async {
    var oldSwitchState = switchState;
    switchState = !switchState;
    try{
      final url = Uri.parse("https://home-automation-v1-792ae-default-rtdb.firebaseio.com/switchState.json");
      final response = await http.patch(url,body: jsonEncode({
        id : switchState
      }));}
      catch(error){
      switchState=oldSwitchState;
      throw error;
    }
    notifyListeners();
  }

}