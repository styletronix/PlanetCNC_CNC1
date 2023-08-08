# PlanetCNC_CNC1
Profile for Planet CNC TNGv2

This Profile is based on a real machine which is used in production.

This demonstrates the 3D visualisation capabilities and the adaptability of the TNGv2 Software by adding own scripts.

This Profile is designed to work without any change in simulation and in real production mode.

Over the years, there where some problems to solve, but now, the machine is working the whole time like a charm.

For more than 2 Years in production environment, I can recommend to use the Planet CNC Controller, Wireless Handwheel and also the TNGv2 Software.


# 2023-08-08
I decided to upload the Power Circuit Plan, to show, how to connect MK3/9 controller to industrial equipment.

You find it as Schaltplan.pdf in the Profile Directory.
This shows...
- connection of Axis Drivers
- Connection of a IR Temperature Sensor to the AUX Analog Input
- Using of Ext output Relay Board
- using Solid State Relays as output and input isolation
- Using Z-Diods to prevent interferences at the Relays and magnetic valves.



# The most important things I had to learn:

1. Use Opto isolators for in and output. Those from Planet CNC or if you prefere a more industrial style, you may use solid state relais like this one:
   [https://int.rsdelivers.com/product/rs-pro/rs-pro-solid-state-interface-relay-din-rail-mount/9054277](https://de.rs-online.com/web/p/halbleiter-interfacerelais/9054277)
   They can direct connected to the output and input of the Planet CNC Controller.


3. You can use the Aux input as analog input but you need an industrial grade fully isolated voltage devider. That's not the cheapesd, but the easiest and safest way to use the anaolog input.


4.  Use a combination of Z-Diod and Diod or RC-Module with every single coil of each relais or electromagnetic valve. If you don't, you may get interferences which may result in switching all external outputs on, for a very short time each time a valve or relais is switched off.   


5. Make a Backup before every Update of the TNG Software. Just copy the entire TNG Program Folder to another location, and you can always start the old version if there are problems with the new one. Just in case. And try the most important things after an update. Maybe something has changed which affects your way of using the Programm and the controller. So expect the unexpected.
