
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/maen_time.dart';
import'../../breakpoint.dart';
import '../../models/rooms.dart';
import 'components/dashboard_room_list.dart';
import 'components/room_form.dart';
import 'components/time_widget.dart';
import '../error_screen.dart';


class DashBoardScreen extends StatelessWidget {

  Future<void> serveFetch(BuildContext context) async{
    try {
      await Provider.of<RoomsProvider>(context, listen: false).fetchRooms();
    }
    catch(error){
      print(error);
      ErrorScreen().errorScreen(context,"Not able fetch the Rooms!!");
    }
  }

  void _roomForm(BuildContext ctx){
    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          // return a widget in the ModelBottom Sheet
          // here we're using RoomForm our own widget to displa yon the modal Sheet
          return RoomForm();
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    // final mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: MaenTime(),
      ),
      body: RefreshIndicator(
        onRefresh: () {
           return serveFetch(context);
        },
        child: Column(
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
                child: Consumer<RoomsProvider>(
                builder: (ctx,roomProvider,child){
                  final rooms = roomProvider.rooms;
                  return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (ctx,index){
                        return DashboardItem(roomName: rooms[index].roomName,id : rooms[index].roomId);

                      });
                },
            ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){ _roomForm(context);},
        child: Icon(Icons.add),
      ),
    );
    //
  }
}


