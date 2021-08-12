# home_automation_app_v1

A new Flutter project.

## Getting Started

This app has feature to add number of lights and other electrical appliances to it,
which than can be controled by the user of tha app,
currently in beta.

## UI Features added
* Updated the code lookwise little cooler ;)
* added features to delete the room and also light bulb icon on the each room tiles to show any light is on in the room, if yes then it will glow other wise it will be dim.
* added edit, delete icon buttons for the each device tile, now device can be deleted from the room or can be edited
* added text time widget for appbar now it show good morning, afternoon, evening or night on the appbar
* added `device form` for user to add new device on fly

## Database features added
* added `Firebase real-time database`
* It has 3 collections 
    - `devices` :
        - contains device collection, each device has deviceName and gpio number, and generated uniqued id for it by firebase
        - eg : {'-MgWzoVAIiju8_EYaCAr': {'deviceName': 'dev2', 'gpio': 4}, '-MgWzsOTc2kFbqeEWIyj': {'deviceName': 'dev3', 'gpio': 3}}
    - `rooms` : 
        - contains room, each room has roomName, devicesId (which are the firebase generated Id of devices) list
        - eg : {'-MgWieOXj-gU7YfrLktN': {'devices': ['-MgWzoVAIiju8_EYaCAr', '-MgWzsOTc2kFbqeEWIyj'], 'roomName': 'room 1'}}
    - `switchState` : 
        - contain deviceId (which are the firebase generated Id of devices) and corresponding state (True/False)
        - eg : {'-MgWzoVAIiju8_EYaCAr': True, '-MgWzsOTc2kFbqeEWIyj': False}
* added database get,post,put,delete,patch feature in the rooms.dart , devices.dart files for :
    - adding/updating/deleting device
    - adding/deleting room
    - updating switchState
 
* important to note if room deleted all the devices connected to it will be deleted and so its switch Status, same goes for individual device

## TODO 
- (least priority)update UI it can have different icon for different electrical appliances
- (medium priority)added extra functionalities like weather reportings usign some apis.
- (least priority)added retreiving the data from raspberrypi like temp