import 'package:flutter/material.dart';

import '../../../screens/room_details/room_screen.dart';
import '../../../breakpoint.dart';

class DashboardItem extends StatelessWidget {
  const DashboardItem({
    Key? key,
    required this.roomName,
    required this.id,
  }) : super(key: key);

  final String roomName;
  final String id;

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
            Navigator.of(context).pushNamed(RoomScreen.roomScreenRoute,arguments: id);
          },
          contentPadding: EdgeInsets.all(kDefaultPadding),
          leading: CircleAvatar(
            radius: kDefaultPadding+10,
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(Icons.home_outlined,color: Colors.black54,),
          ),
          title: Text(roomName,style: TextStyle(
              fontSize: 20,
              color: Colors.white
          ),),
          trailing: Icon(Icons.lightbulb,color:Colors.blue,),
        ),
      ),
    );
  }
}