
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dbUrl.dart';
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
      final url = Uri.parse(DBUrl().dbUrl+"/switchState.json");
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