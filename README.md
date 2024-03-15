# CAN TRACE PARSER PROGRAM

_[Description in infant stage ; young draft and open to suggestions ; Formulated to certain extent, yet many things to be set in place.]_

## Developer's Note while the Release v0.1.1: -
For using this program I think it would be in the best interest of the user to specify all arguments in the command line along with Lua program compilation/interpretation.  The parser has proven to be useful for me. Once the right interpretation for the CAN ID is designed, parsing the CAN ID takes seconds and visualing the Data points takes couple of stress-free minutes. Process will get streamlined after next release with the support of Data Tags.  For now I am adding all kinds of major variants of the Parser that I have developed for different messages. Will be combining them in the final full-fledged version. You can consult the documentation below to understand usage of other Parser scripts.  Thanks for using my Parser. Any feedback will be hugely appreciated!  Stay put for the future releases. Godspeed.

## Why CAN Trace File Parser?

+ CAN Trace file usually contains all system outputs required from the device under test. Therefore it is one of the primary evidences if any change w.r.t. HW/FW needs to be observed.
+ Potential of deriving system behaviour from CAN trace file is undermined. It can be considerable in view of assisting development and debugging purposes.
+ CAN is one of the Output streams from the product through which even debug messages can be passed at a experimental stage of developing the product. Hence proving to be a medium of communication between Developer and Machine. Thus, in this light, Parser program interprets Machine data to the Developer.
+ Output Trace files from the PCAN-View are readable and hassle free.
+ Method of testing my secondary programming language ability, in my case: Lua, which can be used to complement my primary programming , in my case: C.

## Getting 'Lua' set-up on your device: -

+ _Get Lua 5.4 binaries_ = Can use this link to [download this Zip folder](https://drive.google.com/file/d/1b_IUj9JAIjPRejbMNKRkLzmoJ08spBAK/view?usp=drive_link) from my Drive. Unzip and place it in any known location.
+ _Place the path of the link in System Environment variables' Path_
+ _Open Powershell session anywhere and verify by executing 'lua54' in the Command Line. If positive response of the Powershell session comes then the Lua binaries have been rightly placed. Else need to resolve how the binaries are accessed. Could contact me for this._

## Parser programs: -

At the moment multiple parser programs are planned to be present in this repository. This is because All the functionalities could not be consolidated into one General Parser program, as it is under development. The following Parser programs and their purposes are mentioned below:
+ _parser.lua_ = The General Parser program intended to encompass every feature planend for the Parser program. At the moment each byte of the Data Payload is being translated from hexadecimal to Decimal value. Updates are planned. Refer the latest [Release](https://github.com/KeyurVKulkarni/CanParser/releases/tag/v0.1.1-General) and Release Notes.
+ _parser_cellVoltage.lua_ = The Parser program specifically intended to read the rolling message for Cell Voltage broadcasted by ION BMS. Besides basic implementations, not many developments are planned here. Nevertheless, proves to be very helpful Parse the current program. Refer the latest [Release](https://github.com/KeyurVKulkarni/CanParser/releases/tag/v0.1.1-CellVoltage) and Release notes.


## Basic features for the CAN trace parser (in v1.0.1) will include: -

+ **Data Tags** : Name a data tag and assign it certain bits from the data payload of certain CAN ID(s). Observe the variation of the value of these bits in the CAN Trace file w.r.t time. Addresses the spatial multiplexing of the Data Payload for accomodating multiple Data fields.

+ + **Enum Tag** : If a Value or Range of Values of the Data Tag correspond to certain discrete state OR condition OR enumeration then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ + **Value Tag** : If a Value or Range of Values of the Data Tag correspond to certain continuous value (unsigned/signed integer (8/16/32/64bits) / float / etc.) then those can be identified by selecting the relevant Data tag and defining the name corresponding the Value or Range of Values.

+ **Temporal Tags** : Name a temporal tag and assign it a CAN ID. Assign it a dependency (dependency = element that will differentiate between different versions of the CAN ID in time). Addresses the time multiplexing of the Data Payload for accomodating multiple Data fields.

+ **Data scaling** : Scale every occurence of a data component by a constant. This might be helpful for unit conversions.

+ **Time / Frequency analysis** : Note the time of occurence of a particular CAN ID and keep check of the time after which it repeats itself. Change in time of occurence of a particular CAN ID can reflect occurence of soem physical event.
