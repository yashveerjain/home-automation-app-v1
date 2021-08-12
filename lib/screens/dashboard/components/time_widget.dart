
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeWidget extends StatefulWidget{

  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${_timeOfDay.hour}:${_timeOfDay.minute}",
                style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.w100,
                    color: Colors.white70
                )),
            RotatedBox(
                quarterTurns: 3,
                child: Text(_period,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w100,
                      color: Colors.white70
                  ),))
          ],
        ),
        Text("${DateFormat.yMMMd().format(DateTime.now())}",style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w200,
        )),
      ],
    );

  }
}

