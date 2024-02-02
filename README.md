# CAN TRACE PARSER PROGRAM

_[Interim description ; rough draft, open to suggestions ; not completely formulated]_

## Developer's Note

For using this program I think it would be in the best interest of the user to specify all arguments in the command line along with Lua program compilation/interpretation. Else some stupid menu need to be devised for beginning with the program which accpets user value, which I think is overly complicated and cringy to the developer (and, sometimes, to the user). Future versions might support it, at least this feature not present for now. Look out for future release notes. Godspeed.

## Arguments for the Script Call

+ _argument 1_ = Filename along with the extension. e.g.: file_name.txt. It would be in the best interest of the program's purpose to have a .txt file.

+ _argument 2_ = CAN ID (like we use it in Hex format) e.g.: 0x18FF51D0H

+ _argument 3_ = how much to display, whether full record (row) corresponding to the CAN ID is required to be the output or just the data paylod corresponding to the CAN ID needs to be the output. This can be chosen from the options below.

    - _option 1_ = Full record in CAN Trace.

    - _option 2_ = Only data payload.

+ _argument 4_ = output file name where the output of this script needs to be stored. e.g.: file_name.txt
    
## Calling the Script

Resultant command in the terminal will look like this. User can fill in the arguments as they like as per the description mentioned above :
```
lua54 parser.lua argument_1 argument_2 argument_3 >argument_4
```

## Possible Improvements: -

+ **Data Tags** : Name a data tag and assign it certain bits from the data payload of certain CAN ID(s). Observe the variation of the value of these bits in the CAN Trace file w.r.t time. Addresses the spatial multiplexing of the Data Payload for accomodating multiple Data fields.

+ **Temporal Tags** : Name a temporal tag and assign it a CAN ID. Assign it a dependency (dependency = element that will differentiate between different versions of the CAN ID in time). Addresses the time multiplexing of the Data Payload for accomodating multiple Data fields.

+ **Enum Tag** : If a Value or Range of Values of the Data Tag correspond to certain discrete state OR condition OR enumeration then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ **Data scaling** : Scale every occurence of a data component by a constant. This might be helpful for unit conversions.

+ **Time / Frequency analysis** : Note the time of occurence of a particular CAN ID and keep check of the time after which it repeats itself. Change in time of occurence of a particular CAN ID can reflect occurence of soem physical event.
