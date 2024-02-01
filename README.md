For using this program I think it would be in the best interest of the user to specify all arguments in the commandline along with lua file compilation/interpretation. Else some stupid menu need to be devised which accpets user value, which I think is overly complicated and cringy to the developer (and, sometimes, to the user). Future versions might support it, at least this feature not present for now. Look out for future release notes.

> argument_1 = filename along with the extension. e.g.: file_name.txt. It would be in the best interest of the program's purpose to have a .txt file.

> argument_2 = CAN ID (like we use it in Hex format) e.g.: 0x18FF51D0H

> argument_3 = how much to display, whether full record (row) corresponding to the CAN ID is required to be the output or just the data paylod corresponding to the CAN ID needs to be the output. This can be chosen from the options below.

> > option1 = full_record

> > option2 = data

> argument_4 = output file name where the output of this script needs to be stored. e.g.: file_name.txt
    
    
resultant command in the terminal:
```
lua54 parser.lua argument_1 argument_2 argument_3 >argument_4
```

Possible Improvements: -

+ take input for bitwise message description

+ data scaling - basic form
