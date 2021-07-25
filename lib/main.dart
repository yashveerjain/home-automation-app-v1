import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/rooms.dart';
import 'screens/room_details/room_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'breakpoint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx)=>RoomsProvider(),
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        canvasColor: secondaryColor,
        scaffoldBackgroundColor: bgColor,
        textTheme: TextTheme(
          headline6: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white70
          ),
          headline5: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white70
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 5,
          color: secondaryColor,
          titleTextStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        )


      ),
        home: DashBoardScreen(),
        routes: {
        RoomScreen.roomScreenRoute : (ctx)=>RoomScreen(),
        },
    ),
    );
  }
}
