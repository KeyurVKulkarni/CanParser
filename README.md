# CAN TRACE PARSER PROGRAM

_[Description in infant stage ; young draft and open to suggestions ; Formulated to certain extent, yet many things to be set in place.]_

## Developer's Note while conception: -

For using this program I think it would be in the best interest of the user to specify all arguments in the command line along with Lua program compilation/interpretation. Else some stupid menu need to be devised for beginning with the program which accpets user value, which I think is overly complicated and cringy to the developer (and, sometimes, to the user). Future versions might support it, at least this feature not present for now. Look out for future release notes. Godspeed.

## Developer's Note while the Release v0.1.1: -

Not much to comment after the above. The parser has proven to be useful for me. Once the right interpretation for the CAN ID is designed, parsing the CAN ID takes seconds and visualing the Data points takes couple of minutes. Process can get streamlined after next release with the support of Data Tags. Thanks for using my Parser. Any feedback will be hugely appreciated!

## Getting Lua

+ _Get Lua 5.4 binaries_ = Can use this link to [download this Zip folder](https://drive.google.com/file/d/1b_IUj9JAIjPRejbMNKRkLzmoJ08spBAK/view?usp=drive_link) from my Drive. Unzip and place it in any known location.
+ _Place the path of the link in System Environment variables' Path_
+ _Open Powershell session anywhere and verify by executing 'lua54' in the Command Line._

## Executing the Script

Resultant command in the terminal will look like this. User can fill in the arguments as they like as per the description mentioned above :
```
lua54 parser.lua argument_1 argument_2 >argument_3
```

### Planned Arguments for the Script Call

+ _argument 1_ = Filename along with the extension. e.g.: file_name.trc. It would be in the best interest of the program's purpose to have a .trc file.

+ _argument 2_ = CAN ID (like we use it in Hex format) e.g.: 18FF51D0

+ _argument 3_ = output file name where the output of this script needs to be stored. e.g.: file_name.txt

### Output generated per occurence of the required CAN ID

+ _Serial Number_ = The Serial number from where the record of that CAN ID was planned in the CAN Trace file. e.g.: '27)' means the CAN ID, and the following CAN ID related data, is serially 27th message in the CAN trace file.
+ _Time of occurence_ = The CAN trace file contains the time at which that particular CAN message was received. The same is being reflected here. This has been included in the output so that cyclicity of the CAN message can also be checked. e.g.: '68330.3' means the CAN ID, and the following CAN ID related data, occurs 68330.3 milli-seconds after the CAN trace record was started.
+ _Data Payload_ = The Data payload is interpreted and displayed. Currently, most basic interpretation is implemented. Each byte of the Data Payload is converted from hexadecimal to decimal value and prints assuming MSB first on the left. Configurable interpretation is being developed. e.g.: (_will be updated soon_).

## Next Release (hopefully before April, 2024) will include: -

+ _Dialog box for input arguments_ = Since the number of arguments are expected to increase, accomodating them will be quite tricky for the User. Instead, entering those arguments that are being requested by the Dialog box, present on the command line itself, will sort input handling to the Parser.
+ _Support for Data Tags_ = Configurable interpretation for the Data Payload is necessary as Data Payloads of different CAN IDs are different. 

## Basic features for the CAN trace parser (in v1.0.1) will include: -

+ **Data Tags** : Name a data tag and assign it certain bits from the data payload of certain CAN ID(s). Observe the variation of the value of these bits in the CAN Trace file w.r.t time. Addresses the spatial multiplexing of the Data Payload for accomodating multiple Data fields.

+ + **Enum Tag** : If a Value or Range of Values of the Data Tag correspond to certain discrete state OR condition OR enumeration then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ + **Value Tag** : If a Value or Range of Values of the Data Tag correspond to certain continuous value (unsigned/signed integer (8/16/32/64bits) / float / etc.) then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ **Temporal Tags** : Name a temporal tag and assign it a CAN ID. Assign it a dependency (dependency = element that will differentiate between different versions of the CAN ID in time). Addresses the time multiplexing of the Data Payload for accomodating multiple Data fields.

+ **Data scaling** : Scale every occurence of a data component by a constant. This might be helpful for unit conversions.

+ **Time / Frequency analysis** : Note the time of occurence of a particular CAN ID and keep check of the time after which it repeats itself. Change in time of occurence of a particular CAN ID can reflect occurence of soem physical event.
