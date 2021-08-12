import 'package:flutter/material.dart';
import 'package:home_automation_app_v1/models/device.dart';
import 'package:home_automation_app_v1/models/rooms.dart';
import 'package:home_automation_app_v1/screens/error_screen.dart';
import 'package:provider/provider.dart';

class DeviceForm extends StatefulWidget{
  final String roomId;
  final String? deviceId;

  DeviceForm({ required this.roomId, this.deviceId});

  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  final deviceNameFocus = FocusNode();

  final deviceGpioFocus = FocusNode();

  var _isLoading = false;

  var _initValues = {
    'name' : "",
    'gpio' : "",
  };
  Device device = Device(GPIOPin: null, deviceName: "", id: null);

  @override
  void initState(){
    /*
    This is for intializing the form if we're editing any old device details
     */
    if (widget.deviceId!=null){
      device = Provider.of<RoomsProvider>(context,listen: false).getRoomDevice(widget.roomId, widget.deviceId!);
      _initValues["name"] = device.deviceName;
      _initValues["gpio"] = device.GPIOPin.toString();
      print(device.id);
      print(device.deviceName);
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Provider.of<RoomsProvider>(context,listen: false)
    // TODO: implement build
    return AlertDialog(
      title: Text("Add Device",textAlign: TextAlign.center,),
      elevation: 5,
      contentPadding: EdgeInsets.all(15),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              initialValue: _initValues["name"],
              style: TextStyle(
                  color: Colors.white70
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Device Name"),
              validator: (newValue){
                // print("device name : ${newValue}");
                if (newValue!.isEmpty){
                  return "please enter the Name";
                }
                if (Provider.of<RoomsProvider>(context,listen: false).deviceNames(widget.roomId).contains(newValue)
                && newValue!=_initValues["name"]){
                  return "already present";
                }
                return null;
              },
              onSaved: (newValue) {
               device = Device(
                   GPIOPin: device.GPIOPin,
                   deviceName: newValue!,
                   id: device.id);
              },
              // focusNode: deviceNameFocus,

              // onFieldSubmitted: (_){
              //   Focus.of(context).requestFocus(deviceGpioFocus);
              // },

            ),
            TextFormField(
              initialValue: _initValues["gpio"],
              style: TextStyle(
                color: Colors.white70
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "GPIO pin"),
              keyboardType: TextInputType.number,
              // focusNode: deviceGpioFocus,
              validator: (value){
                if (value!.isEmpty){
                  return "please enter GPIO pin";
                }
                if (int.tryParse(value)==null){
                  return "please enter the valid GPIO pin";
                }
                if (Provider.of<RoomsProvider>(context,listen: false).deviceGpioPins(widget.roomId).contains(int.parse(value))
                    && value!=_initValues["gpio"]){
                  return "already present";
                }
                return null;
              },
              onSaved: (newValue) {
                device = Device(
                    GPIOPin: int.parse(newValue!),
                    deviceName: device.deviceName,
                    id: device.id);
              },
            ),
            SizedBox(height: 15,),

          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){Navigator.of(context).pop();},
            child: Text("cancel",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100
              ),)),
        SizedBox(width: 5,),
        _isLoading? CircularProgressIndicator():ElevatedButton(
            onPressed: () async {
              final _isvalid = _formKey.currentState!.validate();
              if (!_isvalid){
                return;
              }
              _formKey.currentState!.save();
              if (widget.deviceId==null){
                try {
                  setState(() {
                    _isLoading=true;
                  });
                  await Provider.of<RoomsProvider>(context, listen: false)
                      .addDevice(widget.roomId, device);
                  setState(() {
                    _isLoading=false;
                  });
                }
                catch(error){
                  ErrorScreen().errorScreen(context, "Not able to add Device");
                  setState(() {
                    _isLoading=false;
                  });
                }
              }
              else if(device.GPIOPin!= _initValues["gpio"] || device.deviceName != _initValues["name"]){
                try {
                  setState(() {
                    _isLoading=true;
                  });
                  await Provider.of<RoomsProvider>(context, listen: false)
                      .updateDevice(widget.roomId, device);
                  setState(() {
                    _isLoading=false;
                  });
                }
                catch(error){
                  ErrorScreen().errorScreen(context, "Not able to edit Device");
                  setState(() {
                    _isLoading=false;
                  });
                }
              }
              Navigator.of(context).pop();
            },
            child: Text("Submit".toUpperCase(),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w100
                ))),

      ],
    );
  }
}