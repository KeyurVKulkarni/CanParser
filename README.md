# CAN TRACE PARSER PROGRAM

_[Description in infant stage ; young draft and open to suggestions ; Formulated to certain extent, yet many things to be set in place.]_

## Developer's Note while the Release v0.1.1: -
For using this program I think it would be in the best interest of the user to specify all arguments in the command line along with Lua program compilation/interpretation.  The parser has proven to be useful for me. Once the right interpretation for the CAN ID is designed, parsing the CAN ID takes seconds and visualing the Data points takes couple of stress-free minutes. Process will get streamlined after next release with the support of Data Tags.  For now I am adding all kinds of major variants of the Parser that I have developed for different messages. Will be combining them in the final full-fledged version. You can consult the documentation below to understand usage of other Parser scripts.  Thanks for using my Parser. Any feedback will be hugely appreciated!  Stay put for the future releases. Godspeed.

## Getting Lua set-up on your device: -

+ _Get Lua 5.4 binaries_ = Can use this link to [download this Zip folder](https://drive.google.com/file/d/1b_IUj9JAIjPRejbMNKRkLzmoJ08spBAK/view?usp=drive_link) from my Drive. Unzip and place it in any known location.
+ _Place the path of the link in System Environment variables' Path_
+ _Open Powershell session anywhere and verify by executing 'lua54' in the Command Line. If positive response of the Powershell session comes then the Lua binaries have been rightly placed. Else need to resolve how the binaries are accessed. Could contact me for this._

## Executing the Script: -

If Lua has been set-up in your PC, then, for making the Parser script to run on your trace file, place the Trace file and Parser script in the same folder.

## For _parser.lua_ >>

Resultant command in the terminal will look like this. User can fill in the arguments as they like as per the description mentioned above :
```
lua54 parser.lua argument_1 argument_2 >argument_3
```

### Arguments for _parser.lua_ Script Call >>

+ _argument 1_ = Filename along with the extension (case sensetive) . e.g.: file_name.trc. It would be in the best interest of the program's purpose to have a .trc file. It is also the same file that is generated from PCAN-View when a CAN trace is saved.

+ _argument 2_ = CAN ID (like we use it in Hex format) (case agnostic) e.g.: 18FF51D0

+ _argument 3_ = output file name where the output of this script needs to be stored. If no file of your given name is present then new file will be created. Else if file is present then it is over-written. Please take note! This is currently a limitation; will be fixed later. e.g.: file_name.txt

### Output generated by _parser.lua_ Script >>

The following fields are taken from the CAN trace, interpreted and presented in the Output File. In the Output File, theses fields will be defined for each occurence of the required CAN ID.

+ _Serial Number_ = The Serial number from where the record of that CAN ID was planned in the CAN Trace file. e.g.: '27)' means the CAN ID, and the following CAN ID related data, is serially 27th message in the CAN trace file.

+ _Time of occurence_ = The CAN trace file contains the time at which that particular CAN message was received. The same is being reflected here. This has been included in the output so that cyclicity of the CAN message can also be checked. e.g.: '68330.3' means the CAN ID, and the following CAN ID related data, occurs 68330.3 milli-seconds after the CAN trace record was started.

+ _Data Payload_ = The Data payload is interpreted and displayed. Currently, most basic interpretation is implemented. Each byte of the Data Payload is converted from hexadecimal to decimal value and prints assuming MSB first on the left. Configurable interpretation is being developed. e.g.: The sample Data Payload of some arbitrary CAN ID and its interpretation in the Output file is displayed below.
```
CAN Data Payload = 00 01 3C 4D 89 20 11 00 ; Interpretation in the Output file = 0 1 60 77 137 32 17 0
```

## For '_parser_cellVoltage.lua_' >>

This Script has been specifically designed to decipher rolling CAN messages pertaning to Cell Voltages. So, the CAN ID is fixed and not configurable: **18FF30D0**.
Described below is the fixed strategy of parsing is used in this case.
```
xx xx yy yy zz zz ww ww
^^-^^-------------------- (2 Bytes) Reference Cell Index; Voltages of (Cell_Index+1), (Cell_Index+1), (Cell_Index+1) are displayed in this message.
                           If the Cell Index does not pertain to the last set of Cells, then (Cell_Index+3) is going to be the Cell Index of the  next CAN message.
      ^^-^^-------------- (2 Bytes) Voltage of Cell number (Cell_Index+1).
            ^^-^^-------- (2 Bytes) Voltage of Cell number (Cell_Index+2).
                  ^^-^^-- (2 Bytes) Voltage of Cell number (Cell_Index+3).
```
Resultant command in the terminal will look like this. User can fill in the arguments as they like as per the description mentioned above :
```
lua54 parser.lua argument_1 >argument_2
```

### Arguments for _parser_cellVoltage.lua_ Script Call >>

+ _argument 1_ = Filename along with the extension (case sensetive) . e.g.: file_name.trc. It would be in the best interest of the program's purpose to have a .trc file. It is also the same file that is generated from PCAN-View when a CAN trace is saved.

+ _argument 2_ = output file name where the output of this script needs to be stored. If no file of your given name is present then new file will be created. Else if file is present then it is over-written. Please take note! This is currently a limitation; will be fixed later. e.g.: file_name.txt

### Output generated by _parse_cellVoltage.lua_ Script >>

If the CAN trace begins with the message of some arbitrary cell voltage (and not from the first set of cell voltages) then those will be concatenated and displayed.
E.g.: In the sample output below, maximum Cells present in the system are 32. A sample average Cell voltage of 3500mV has been used. The first Cell Voltage message present in the CAN trace has Cell Index 27. This means we won't be able to get previous Cell Voltages. However, after displaying Cell Voltages of the following Cells, Cell voltages will be displayed again starting from Cell Index 0. Hence the following output.
```
28 : 3500 , 29 : 3501 , 30 : 3500 , 31 : 3500 ; 32 : 3501 , 33 : 0 ,
1 : 3500 , 2 : 3501 , 3 : 3500 , 4 : 3500 ; 5 : 3501 , 6 : 3502 , 7 : 3500 , 8 : 3501 , 9 : 3500 , 10 : 3500 ; 11 : 3501 , 12 : 3502 , 13 : 3500 , 14 : 3501 , 15 : 3500 , 16 : 3500 ; 17 : 3501 , 18 : 3502 , 19 : 3500 , 20 : 3501 , 21 : 3500 , 22 : 3500 ; 23 : 3501 , 24 : 3502 , 25 : 3500 , 26 : 3501 , 27 : 3500 , 28 : 3500 ; 29 : 3501 , 30 : 3502 , 31 : 3500 ; 32 : 3501 , 33 : 0 ,
1 : 3500 , 2 : 3501 , 3 : 3500 , 4 : 3500 ; 5 : 3501 , 6 : 3502 , 7 : 3500 , 8 : 3501 , 9 : 3500 , 10 : 3500 ; 11 : 3501 , 12 : 3502 , 13 : 3500 , 14 : 3501 , 15 : 3500 , 16 : 3500 ; 17 : 3501 , 18 : 3502 , 19 : 3500 , 20 : 3501 , 21 : 3500 , 22 : 3500 ; 23 : 3501 , 24 : 3502 , 25 : 3500 , 26 : 3501 , 27 : 3500 , 28 : 3500 ; 29 : 3501 , 30 : 3502 , 31 : 3500 ; 32 : 3501 , 33 : 0 ,
.
.
.
```

When the cell voltage CAN messages begin from the first set of cell voltage then all 1 to 32 (max number of cells as decided) cell voltages will be concatenated and displayed.
e.g.: In the sample output below, maximum Cells present in the system are 32. A sample average Cell voltage of 3500mV has been used. The CAN trace must have the first Cell Voltage CAN message woth Cell Index 0. Hence, ideally, right from the first data point, voltages of all 32 cells can be seen.
```
1 : 3500 , 2 : 3501 , 3 : 3500 , 4 : 3500 ; 5 : 3501 , 6 : 3502 , 7 : 3500 , 8 : 3501 , 9 : 3500 , 10 : 3500 ; 11 : 3501 , 12 : 3502 , 13 : 3500 , 14 : 3501 , 15 : 3500 , 16 : 3500 ; 17 : 3501 , 18 : 3502 , 19 : 3500 , 20 : 3501 , 21 : 3500 , 22 : 3500 ; 23 : 3501 , 24 : 3502 , 25 : 3500 , 26 : 3501 , 27 : 3500 , 28 : 3500 ; 29 : 3501 , 30 : 3502 , 31 : 3500 ; 32 : 3501 , 33 : 0 ,
1 : 3500 , 2 : 3501 , 3 : 3500 , 4 : 3500 ; 5 : 3501 , 6 : 3502 , 7 : 3500 , 8 : 3501 , 9 : 3500 , 10 : 3500 ; 11 : 3501 , 12 : 3502 , 13 : 3500 , 14 : 3501 , 15 : 3500 , 16 : 3500 ; 17 : 3501 , 18 : 3502 , 19 : 3500 , 20 : 3501 , 21 : 3500 , 22 : 3500 ; 23 : 3501 , 24 : 3502 , 25 : 3500 , 26 : 3501 , 27 : 3500 , 28 : 3500 ; 29 : 3501 , 30 : 3502 , 31 : 3500 ; 32 : 3501 , 33 : 0 ,
.
.
.
```

## Next Release (hopefully before April, 2024) will include: -

+ _Dialog box for input arguments_ = Since the number of arguments are expected to increase, accomodating them will be quite tricky for the User. Instead, entering those arguments that are being requested by the Dialog box, present on the command line itself, will sort input handling to the Parser.
+ _Support for Data Tags_ = Configurable interpretation for the Data Payload is necessary as Data Payloads of different CAN IDs are different.

## Future Releases before v1.0.1 shall contain: -

+ _Automatic output file_ = This exists to curb the drawback of potentially losing previous data if user-specified output file is already used before. The output file name will not be configurable as possibility of over-writing previous outputs exists. It is better to have different output files for different executions. Output file indentifier can be used for keeping track among different executions. It is left to the user to clear output files of unwanted executions.

## Basic features for the CAN trace parser (in v1.0.1) will include: -

+ **Data Tags** : Name a data tag and assign it certain bits from the data payload of certain CAN ID(s). Observe the variation of the value of these bits in the CAN Trace file w.r.t time. Addresses the spatial multiplexing of the Data Payload for accomodating multiple Data fields.

+ + **Enum Tag** : If a Value or Range of Values of the Data Tag correspond to certain discrete state OR condition OR enumeration then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ + **Value Tag** : If a Value or Range of Values of the Data Tag correspond to certain continuous value (unsigned/signed integer (8/16/32/64bits) / float / etc.) then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ **Temporal Tags** : Name a temporal tag and assign it a CAN ID. Assign it a dependency (dependency = element that will differentiate between different versions of the CAN ID in time). Addresses the time multiplexing of the Data Payload for accomodating multiple Data fields.

+ **Data scaling** : Scale every occurence of a data component by a constant. This might be helpful for unit conversions.

+ **Time / Frequency analysis** : Note the time of occurence of a particular CAN ID and keep check of the time after which it repeats itself. Change in time of occurence of a particular CAN ID can reflect occurence of soem physical event.
