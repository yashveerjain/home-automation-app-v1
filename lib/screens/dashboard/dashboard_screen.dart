
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import'../../breakpoint.dart';
import '../../models/rooms.dart';
import 'components/dashboard_room_list.dart';
import 'components/time_widget.dart';

class DashBoardScreen extends StatelessWidget{
  // final double currentTemp = 10;

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;
    final roomProvider= Provider.of<RoomsProvider>(context);
    final rooms = roomProvider.rooms;
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Home !!",style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
        ),),
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: () {},),
        ],
      ),
      body: Column(
        children: [

          SizedBox(
            height: kDefaultPadding,
          ),
          TimeWidget(),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Center(child: Text("Rooms List",style: Theme.of(context).textTheme.headline6,),
              heightFactor: 1,),
          ),
          SizedBox(height: kDefaultPadding,),
          Expanded(
            child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (ctx,index){
                  return DashboardItem(roomName: rooms[index].roomName,id : rooms[index].id);

                }),
          )
        ],
      ),
    );
    //
  }
}




// return Scaffold(
//     body: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Spacer(flex: 1,),
//         DashboardHeader(),
//         Text("Rooms List",style: Theme.of(context).textTheme.headline6,),
//         SizedBox(
//           height: kDefaultPadding,
//         ),
//         Text("${DateFormat.yMMMd().format(DateTime.now())}",style: TextStyle(
//             color: Colors.white70,
//             fontSize: 25,
//             fontStyle: FontStyle.italic
//         )),
//         Text("${DateFormat.jm().format(DateTime.now())}",
//             style: TextStyle(
//                 color: Colors.white70,
//               fontSize: 20,
//               decoration: TextDecoration.overline,
//               fontStyle: FontStyle.italic
//         )),
//         if (rooms.length ==0)Text("No Rooms Yet!!"),
//         if (rooms.length !=0) Expanded(
//             // fit: FlexFit.loose,
//             flex: 13,
//             child: ListView.builder(
//                itemCount: rooms.length,
//                 itemBuilder: (ctx,index){
//                  return GestureDetector(
//                    onTap: (){},
//                    child: Container(
//                      height: mediaQuerySize.height*0.1,
//                      margin: EdgeInsets.symmetric(
//                          horizontal: kDefaultPadding),
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(kDefaultPadding),
//                        border: Border.all(
//                          color: Colors.grey
//                        ),
//                        color: Colors.black54,
//                      ),
//                      padding: EdgeInsets.all(kDefaultPadding),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: [Text(rooms[index].roomName.toUpperCase(),
//                        style: Theme.of(context).textTheme.headline5,),
//                        Spacer(flex: 1,),
//                        if (!(rooms[index].roomTemp=="None"))Text("${rooms[index].roomTemp} \u00B0C",style: Theme.of(context).textTheme.headline6,),
//                        Icon(Icons.lightbulb,color: Theme.of(context).primaryColor,)]
//                      ),
//                    ),
//                  );
//                 }),
//           ),
//       ],
//     )
// );