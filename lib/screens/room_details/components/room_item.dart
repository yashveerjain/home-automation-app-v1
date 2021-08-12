
import 'package:flutter/material.dart';
import 'package:home_automation_app_v1/models/device.dart';
import 'package:home_automation_app_v1/screens/error_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/rooms.dart';
import '../../../breakpoint.dart';
import 'device_form.dart';

class RoomItem extends StatefulWidget {
  const RoomItem({
  Key? key, required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  _RoomItemState createState() => _RoomItemState();
}

class _RoomItemState extends State<RoomItem> {
  var _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<Device>(context);
    final deviceName = deviceProvider.deviceName;
    final deviceSwitchState = deviceProvider.switchState;
    return InkWell(
      onTap: () async{
        // Provider.of<RoomsProvider>(context,listen: false).updateSwitch(roomId: roomId,deviceId: deviceId);
        try{
          await Provider.of<Device>(context,listen: false).toggleSwitch();}
          catch(error){
          print("not able to switch State $error");
          // ErrorScreen().errorScreen(context, "not able to switch State");
          }
      },
      child: Container(
        margin: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(

            gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.4),
                  // Colors.white70,
                  Theme.of(context).accentColor
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            ),
            borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children : [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    deviceSwitchState?Icon(Icons.lightbulb,size : 20):Icon(Icons.lightbulb_outline,size: 20,),
                    Spacer(),
                    _isDeleting?CircularProgressIndicator():
                    IconButton(onPressed: () async{
                      try{
                        setState(() {
                          _isDeleting=true;
                        });
                      await Provider.of<RoomsProvider>(context,listen: false).deleteDeviceInRoom(deviceProvider.id!,
                          widget.roomId);
                        setState(() {
                          _isDeleting=false;
                        });
                      }
                      catch(error){
                        setState(() {
                          _isDeleting=false;
                        });
                        ErrorScreen().errorScreen(context, "erro while deleting the device");
                      }

                    }, icon: Icon(Icons.delete_outline)),
                    IconButton(onPressed: (){
                          showDialog(context: context, builder: (ctx){
                            return DeviceForm(roomId: widget.roomId,deviceId: deviceProvider.id,);});
                    }, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
              deviceSwitchState?
              Text("ON",style: Theme.of(context).textTheme.headline6,) :
              Text("OFF",style: Theme.of(context).textTheme.headline6,),

              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Text(deviceName,style: TextStyle(
                  color: Colors.black54,
                  fontSize: kDefaultPadding,
                  fontWeight: FontWeight.bold
                ),
                  ),
              )
            ]
        ),
      ),
    );
  }
}