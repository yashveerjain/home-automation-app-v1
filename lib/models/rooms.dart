import 'dart:math';

import 'package:flutter/material.dart';

class Room{
  final String roomName;
  final String id;
  final Map<String,bool> electricalAppliance;

  // String roomTemp;

  Room({required this.roomName,
    required this.id,
    required this.electricalAppliance,
  });
}

class RoomsProvider with ChangeNotifier {
  List<Room> _rooms = [
    Room(
      id:"1",
      roomName:"Room 1",
      electricalAppliance : {
        "light 1" : false,
        "fan" : true,
      },
    ),
    Room(
      id:"2",
      roomName:"Room 2",
      electricalAppliance : {
        "light" : false,
        "AC" : true,
      },
    ),
    Room(
      id:"3",
      roomName:"Room 3",
      electricalAppliance : {
        "fan" : false,
        "freezer" : true,
      },
    )
  ];

  List<Room> get rooms{
    return [..._rooms];
  }

  void addRoom(String roomName,Map<String,bool>elecApp){
    String Id = Random().nextInt(100).toString();
    Room room = Room(id: Id,roomName: roomName,electricalAppliance: elecApp);
    _rooms.add(room);
    notifyListeners();
  }

  Room getRoom(String id){
    return _rooms.firstWhere((room) => room.id==id);
  }
  
  void updateSwitch(String light,Room room){
    var index = _rooms.indexOf(room);
    room.electricalAppliance.update(light, (value) => value=!value);
    _rooms[index] = room;
    print(room.electricalAppliance);

    // print(index);
    // print(room.electricalAppliance);
    notifyListeners();
  }
  
}