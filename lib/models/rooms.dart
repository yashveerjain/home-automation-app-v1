/*
vey important file contains all the data processing and retreiving  part
 */


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'device.dart';

class Room{
  final String roomName;
  final String roomId;
  final List<Device> devices;

  // String roomTemp;

  Room({required this.roomName,
    required this.roomId,
    required this.devices,
  });
}

class RoomsProvider with ChangeNotifier {
  final roomUrl = ""; ##eg : https://default-rtdb.firebaseio.com/rooms
  final deviceUrl = ""; ##eg: "https://default-rtdb.firebaseio.com/devices";
  final switchStatusUrl = ""; ##eg: "https://default-rtdb.firebaseio.com/switchState.json";

  List<Room> _rooms = [];

  List<Room> get rooms{
    return [..._rooms];
  }

  Device getRoomDevice(String roomId,String deviceId){
    Room room = rooms.firstWhere((room) => room.roomId==roomId);
    return room.devices.firstWhere((device) => device.id==deviceId);
  }

  Future<Map<String, dynamic>> getSwitchStatus() async {
    // get switch status of all the devices which change there switch once
    // return : {'-MgWzoVAIiju8_EYaCAr': True, '-MgWzsOTc2kFbqeEWIyj': True}
    final url = Uri.parse(switchStatusUrl);
    final response = await http.get(url);
    if (jsonDecode(response.body) == null){
      return {};
    }
    // print(jsonDecode(response.body));
    final status = jsonDecode(response.body) as Map<String,dynamic>;
    return status;
  }

  Future<List<Device>> getDevices() async{
    /*
    This function will retreive all the devices from the server of devices collection
    return devices list containing all the devices irrespective of room
     */

    final url = Uri.parse(deviceUrl+".json");
    final response = await http.get(url);
    if (jsonDecode(response.body)==null){
      return [];
    }

    final switchStatus = await getSwitchStatus();
    final decodedResponse = jsonDecode(response.body) as Map<String,dynamic>;
    List<Device> devices = [];
      decodedResponse.forEach((serverDeviceId, deviceContent) {
        devices.add(Device(GPIOPin: deviceContent["gpio"],
            deviceName: deviceContent["deviceName"],
            switchState: switchStatus[serverDeviceId]??false,
            id: serverDeviceId));
      });
      return devices;
  }

  Future<void> fetchRooms() async {
    /*
    invoked by dashboard screen will fetch the details of room and device and also do few other things:
    remove the devices not present in the rooms
    remove the device from room on database and locally whicd device_id present in the room in rooms collection but not on device collection
    get the switch status as well
     */

    try {
      final url = Uri.parse(roomUrl+".json"); // fetching the data from rooms collection
      final response = await http.get(url);
      final roomDataCheck = jsonDecode(response.body);
      if (roomDataCheck == null) {
        return;
      }

      final roomData = roomDataCheck as Map<String, dynamic>;
      List<Device> devices = await getDevices();

      List<Device> floatingDevices = devices; // this is to take the devices which doesn't have room and delete those devices,

      List<Room> serverRoomList = []; // will contain the room list fetched from the server

      roomData.forEach((roomId, room) {
        bool devicePresent = true; // monitor if device is present in both room and device collection in database
        List<Device> roomDevices = [];
        if (room["devices"] == null) {
          // this will indicate that the device is empty list
          roomDevices = [];
        }
        else {
          final roomDeviceIds = room["devices"];
          roomDeviceIds.forEach((roomDeviceId) {
            bool present = devices.any((element) => element.id==roomDeviceId);
            if (!present){
              devicePresent=false;
              return;
            }
            roomDevices.add(
                devices.firstWhere((device) => device.id == roomDeviceId,
                  ));
            floatingDevices.removeWhere((device) => device.id == roomDeviceId);
          }
          );
        }
        if (!devicePresent){
          final url = Uri.parse(roomUrl+"/$roomId.json");
          http.patch(url,body: jsonEncode({
            "devices" : roomDevices,
          })).catchError((error){
            throw error;
          });
        }
        serverRoomList.add(
            Room(roomName: room["roomName"],
                roomId: roomId,
                devices: roomDevices
            )
        );
      });

      _rooms = serverRoomList;
      notifyListeners();

      // delete the devices which are not connected to any room
      if (floatingDevices.isNotEmpty){
        floatingDevices.forEach((device) {
          // print(device.id);
          deleteDeviceFromServer(device.id!);
        });
      }
    }
      catch(error){
      print(error);
       throw error;
      }
  }

  Future<void> addRoom(String roomName) async {
    // create the new room in the Room collection Firebase server and also locally add in rooms list
    //eg : Room 1 -> {MgWieOXj-gU7YfrLktN : {devices:[],roomName:"room 1"}}
    // in local Room its id = the unique id generated by the firebase eg : MgWieOXj-gU7YfrLktN

    List<String> devices = [];
    final url = Uri.parse(roomUrl+".json");
    final response  = await http.post(url,body: jsonEncode({
      "roomName" : roomName,
      "devices" : devices,
    }));

    final newId = jsonDecode(response.body)["name"];
    Room room = Room(roomId: newId,roomName: roomName,devices: []);
    _rooms.add(room);
    notifyListeners();
  }

  Future<void> deleteRoom(String roomId) async {
    // delete the room from server and locally and all the devices connected to it
    String particularRoomUrl = roomUrl+"/$roomId.json";
    Room oldRoom =  _rooms.firstWhere((room) => room.roomId==roomId);
    _rooms.removeWhere((room) => room.roomId==roomId);
    try{
      final url = Uri.parse(particularRoomUrl);
      final response = await http.delete(url);
      oldRoom.devices.forEach((device)
      {
        deleteDeviceFromServer(device.id!);}
        );
      notifyListeners();}
      catch(error){
        // print(error);
        _rooms.add(oldRoom);
        throw error;
      }
  }


  Future<void> addDeviceIdToRoom(String roomId) async {
    //update the device list in the room database: eg: add deviceId in the list of devices in that room
    //eg : Room 1 -> {MgWieOXj-gU7YfrLktN : {devices:["-MgWzoVAIiju8_EYaCAr","-MgWzsOTc2kFbqeEWIyj"],roomName:"room 1"}}

    String particularRoomUrl = roomUrl+"/$roomId.json";
    final deviceList = [];
    Room room = rooms.firstWhere((room) => room.roomId==roomId);
      room.devices.forEach((device) {
        deviceList.add(device.id);
      });
    final url = Uri.parse(particularRoomUrl);
    final response = await http.patch(url,body: jsonEncode({
      "devices" : deviceList
    }));

  }

  Future<void> addDevice(String roomId,Device device) async {
    // add the new device (name, gpio) in the device collection in the database
    // and also add the deviceid in the particular room id in device list
    // and also add the device to the room devices list in the application
    // in local Device object its id = the unique id generated by the firebase eg : -MgWzoVAIiju8_EYaCAr as unique id
    try {
      final index = rooms.indexWhere((room) => room.roomId == roomId);
      final url = Uri.parse(deviceUrl + ".json");
      final response = await http.post(url, body: jsonEncode({
        "gpio": device.GPIOPin,
        "deviceName": device.deviceName,
      }));
      final newId = jsonDecode(response.body)["name"];
      final newDevice = Device(GPIOPin: device.GPIOPin,
          deviceName: device.deviceName, id: newId);
      rooms[index].devices.add(newDevice);
    }
    catch(error){
      print(error);
      throw error;
    }
      try{
      //update the device list in the room database: eg: add deviceId in the list of that room
      await addDeviceIdToRoom(roomId);
      notifyListeners();
    }
    catch(error){
      print(error);
      throw error;
    }
    // print(newDevice.GPIOPin);
    // print(newDevice.deviceName);
    // print(newDevice.roomName);
    // print(newDevice.id);
    // print(newDevice.switchState);
  }

  Future<void> updateDevice(String roomId,Device device) async {
    // update the specific device in device collection in the firebase real time database
    // update can be device name or gpio number
    // this function is called by device_form.dart
    try {
      final index = rooms.indexWhere((room) => room.roomId == roomId);
      final url = Uri.parse(deviceUrl + "/${device.id}.json");
      final response = await http.patch(url, body: jsonEncode({
        "gpio": device.GPIOPin,
        "deviceName": device.deviceName,
      }));

      final deviceIndex = rooms[index].devices.indexWhere((insideDevice) => insideDevice.id==device.id);
      rooms[index].devices[deviceIndex] = device;
    }
    catch(error){
      print(error);
      throw error;
    }
    notifyListeners();
  }

 Future<void> deleteDeviceFromServer(String deviceId) async {
   // this called by the deleteDeviceInRoom it will delete the specific device from the device collection in firebase server
   //only need to give the deviceId
   final url = Uri.parse(deviceUrl+"/$deviceId.json");
   // try{
    await http.delete(url);
    // catch(error){
    //  print("not able to delete the device ID :$deviceId error : $error");
    // }
 }

 Future<void> deleteDeviceInRoom(String deviceId,String roomId) async {
   // this will notify listeners when deleting the device in the Room devices list: and also delete it from the server
   int index = rooms.indexWhere((room) => room.roomId==roomId);
   Device oldDevice = rooms[index].devices.firstWhere((device) => deviceId==device.id);
   rooms[index].devices.removeWhere((device) => device.id==deviceId);
   try{
     await deleteDeviceFromServer(deviceId);
      }
      catch(error){
        rooms[index].devices.add(oldDevice);
        throw error;
      }
      try{
        await addDeviceIdToRoom(roomId);
      }
      catch(error){
        // rooms[index].devices.add(oldDevice);
        throw error;
      }
   notifyListeners();
 }


  // this are some extra funtions used in device_forms to check whether the user input is already
  // present or not.
  Room getRoom(String id){
    return _rooms.firstWhere((room) => room.roomId==id);
  }

  List<String> deviceNames(String roomId){
    Room room = getRoom(roomId);
    return room.devices.map((device) => device.deviceName).toList();
  }
  List<bool> deviceSwitchState(String roomId){
    Room room = getRoom(roomId);
    return room.devices.map((device) => device.switchState).toList();
  }
  List<int?> deviceGpioPins(String roomId){
    Room room = getRoom(roomId);
    return room.devices.map((device) => device.GPIOPin).toList();
  }
  bool anySwitchOnInRoom(String roomId){
    Room room = getRoom(roomId);
    return room.devices.any((device) => device.switchState);
  }

  //
}