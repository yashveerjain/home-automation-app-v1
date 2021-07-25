

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/rooms.dart';
import 'components/room_item.dart';

class RoomScreen extends StatelessWidget{
  static const roomScreenRoute = "/room-screen";
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    Room room = Provider.of<RoomsProvider>(context).getRoom(id);
    List<String> electricalAppliancesNames = room.electricalAppliance.keys.toList();
    List<bool> electricalApplianceswitch = room.electricalAppliance.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(room.roomName,style: Theme.of(context).textTheme.headline5,),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (ctx,index){
            String light = electricalAppliancesNames[index];
            bool lightSwitch = electricalApplianceswitch[index];
            return RoomItem(light: light, room: room, lightSwitch: lightSwitch);
          },
      itemCount: room.electricalAppliance.length,),
    );

  }
}

