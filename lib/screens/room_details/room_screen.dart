

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/rooms.dart';
import './components/device_form.dart';
import 'components/room_item.dart';

class RoomScreen extends StatelessWidget{
  static const roomScreenRoute = "/room-screen";
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    final roomProvider = Provider.of<RoomsProvider>(context);
    Room room = roomProvider.getRoom(id);

    return Scaffold(

      appBar: AppBar(
        title: Text(room.roomName,style: Theme.of(context).textTheme.headline5,),
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (ctx){
              return DeviceForm(roomId: room.roomId,);
            });
          }, icon: Icon(Icons.add))
        ],
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (ctx,index){
            return ChangeNotifierProvider.value(
                value: room.devices[index],
                child: RoomItem(roomId: room.roomId));
          },
      itemCount: room.devices.length,),
    );

  }
}

