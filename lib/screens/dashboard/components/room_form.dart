import 'package:flutter/material.dart';
import 'package:home_automation_app_v1/models/rooms.dart';
import 'package:provider/provider.dart';

class RoomForm extends StatefulWidget{
  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final roomController = TextEditingController();
  var _isLoading = false;
  final buttonFocus = FocusNode();

  Future<void> createRoom(BuildContext context) async {
    if (roomController.text.isEmpty) {
      return;}
    setState(() {
      _isLoading = true;
    });
    try{
      await Provider.of<RoomsProvider>(context, listen: false).addRoom(
          roomController.text).then((value) => null);
      setState(() {
        _isLoading=false;
      });
      Navigator.of(context).pop();
    }
          catch(error){
            print("error in creating room : $error");
            setState(() {
              _isLoading=false;
            });
            return;
          }

  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.only(
          left: mediaQuery.size.height*0.01,
          right: mediaQuery.size.height*0.01,
          top: mediaQuery.size.height*0.01,
          bottom: mediaQuery.viewInsets.bottom,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(
                  color: Colors.white70
              ),
            decoration: InputDecoration(labelText: "Room Name"),
            controller: roomController,
              textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
              onSubmitted: (_) {
                Focus.of(context).requestFocus(buttonFocus);
              },
          ),
            SizedBox(height: 10,),
            Row(
              children: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text("Cancel")),
                SizedBox(
                  width: 6,
                ),
                _isLoading? CircularProgressIndicator() : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Theme.of(context).primaryColor,
                  ),
                  focusNode: buttonFocus,
                    onPressed: () {
                      createRoom(context);
                    },
                    child: Text("Add")
                ),
              ],
            )
          ]
        ),
      ),
    );
  }
}