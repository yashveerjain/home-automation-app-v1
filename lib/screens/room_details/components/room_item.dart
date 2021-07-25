
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/rooms.dart';
import '../../../breakpoint.dart';

class RoomItem extends StatelessWidget {
  const RoomItem({
    Key? key,
    required this.light,
    required this.room,
    required this.lightSwitch,
  }) : super(key: key);

  final String light;
  final Room room;
  final bool lightSwitch;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<RoomsProvider>(context,listen: false).updateSwitch(light,room);
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
            // borderRadius: BorderRadius.circular(kDefaultPadding),
            shape: BoxShape.circle
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              lightSwitch?Icon(Icons.lightbulb,size : 20):Icon(Icons.lightbulb_outline,size: 20,),
              SizedBox(height: kDefaultPadding,),
              Text(light.toUpperCase(),style: Theme.of(context).textTheme.headline6,)
            ]
        ),
      ),
    );
  }
}