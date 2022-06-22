# CyberTelemetry
This is a LUA script for OpenTX systems that implements a system for displaying telemetry information. This version is written for the Taranis FrSky Q X7 transmitter.
Correct operation is supported at the moment:
* Baro altimeter
* RSSI meter 
* Batarey voltmeter
* Ammeter
* Visual display of the remaining charge
* Flight timer
* Visual display and voice indication of the release of spoilers or flaps

Changelist 

Alpha 0.1 
Now by changing the arguments in the draw*Something* functions, you can move blocks with data. Like this:

        drawBatteryData(you_x_coordinate, you_y_coordinate)


License: publication in sources with indication of authorship, use for commercial purposes is prohibited.
