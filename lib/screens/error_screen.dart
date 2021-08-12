

import 'package:flutter/material.dart';

class ErrorScreen {

  void errorScreen(BuildContext context,String title){
    showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text(title),
        content: Text("Please check your internet Connection",style: TextStyle(
            color: Colors.white
        ),),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(ctx).pop();
          }, child: Text("Okay"))
        ],
      );
    });
  }

}