/*
maen -> Morning Afternoon Evening Night
This widget will give you one of above according to Time
 */


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MaenTime extends StatefulWidget {

  @override
  _MaenTimeState createState() => _MaenTimeState();
}

class _MaenTimeState extends State<MaenTime> {
  TimeOfDay _timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1),(timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute){
        setState(() {
          _timeOfDay = TimeOfDay.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String _period = _timeOfDay.period==DayPeriod.am ? "AM" : "PM";
    String _maen = "";
    if (_timeOfDay.hour>=4 && _timeOfDay.hour<12){
      _maen = "morning";
    }
    else if (_timeOfDay.hour>=12 && _timeOfDay.hour<=17){
      _maen = "afternoon";
    }
    else if (_timeOfDay.hour>17 && _timeOfDay.hour<=21){
      _maen = "evening";
    }
    else {
      _maen = "night";
    }
    return Text("Good $_maen Sir!!",style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold
    ),);
  }
}

