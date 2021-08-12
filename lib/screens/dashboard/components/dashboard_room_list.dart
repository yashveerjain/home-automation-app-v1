import 'package:flutter/material.dart';
import 'package:home_automation_app_v1/models/rooms.dart';
import 'package:home_automation_app_v1/screens/error_screen.dart';
import 'package:provider/provider.dart';

import '../../../screens/room_details/room_screen.dart';
import '../../../breakpoint.dart';

class DashboardItem extends StatefulWidget {
  const DashboardItem({
    Key? key,
    required this.roomName,
    required this.id,
  }) : super(key: key);

  final String roomName;
  final String id;

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultPadding+10,
      vertical: kDefaultPadding-10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.white30
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )

      ),
      child: Card(

        elevation: 5,
        child: ListTile(
          onTap: (){
            Navigator.of(context).pushNamed(RoomScreen.roomScreenRoute,arguments: widget.id);
          },
          contentPadding: EdgeInsets.all(kDefaultPadding),
          leading: CircleAvatar(
            radius: kDefaultPadding+10,
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.home_outlined,color: Colors.black54,),
          ),
          title: Text(widget.roomName,style: TextStyle(
              fontSize: 20,
              color: Colors.white
          ),),
          trailing: Container(
            width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     _isLoading?Icon(Icons.lightbulb,color:Colors.blue,):
               // Consumer is used here to only render the Icon bulb when the switch of any light is on or all the switch are off
                  Consumer<RoomsProvider>(builder: (ctx,roomData,child)
                           { return roomData.anySwitchOnInRoom(widget.id)?
                             Icon(Icons.lightbulb,color:Colors.blue,):
                           Icon(Icons.lightbulb_outline,color:Colors.blue,);}),
                    
                    // _isLoading true then  we are deleting the room from the server, and false then the delete icon button will be shown
                    _isLoading?CircularProgressIndicator():
                    IconButton(onPressed: () async{
                      setState(() {
                        _isLoading=true;
                      });
                      try{
                        await Provider.of<RoomsProvider>(context,listen: false).deleteRoom(widget.id);

                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("deleted!!",textAlign: TextAlign.center,),
                          duration: Duration(seconds: 1),
                        ));
                      }
                      catch(error){
                        setState(() {
                          _isLoading=false;
                        });
                        ErrorScreen().errorScreen(context,"Not able delete the ${widget.roomName}!!");
                      }

                    }, icon: Icon(Icons.delete,color: Colors.red,)),
                  ],
          )),
        ),
      ),
    );
  }
}