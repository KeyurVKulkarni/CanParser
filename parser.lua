-- for using this program I think it would be in the best interest of the user to specify all arguments in the commandline along with lua file compilation/interpretation. else some stupid menu need to be devised which accpets user value, which I think is overly complicated and cringy to the developer. Future versions might support it, at least this feature not present for now. Look out for future release notes.

--     argument_1 = filename along with the extension. e.g.: file_name.txt
--     it would be in the best interest of the program's purpose to have a .txt file.
--     argument_2 = CAN ID (like we use it in Hex format) e.g.: 0x18FF51D0H
--     argument_3 = how much to display, whether full record (row) corresponding to the CAN ID is required to be the output or just the data paylod corresponding to the CAN ID needs to be the output. This can be chosen from the options below.
--             option1 = full_record
--             option2 = data
--     argument_4 = output file name where the output of this script needs to be stored. e.g.: file_name.txt
    
    
--     resultant command in the terminal:
--     lua54 parser.lua argument_1 argument_2 argument_3 >argument_4
-- specify bitwise allocation
-- data scaling - basic form
    

-- basic introduction to the Parser Script output.
-- listing all arguments and following up on the requested process.
-- also, to be integrated, concatenating bracketed arguments
can_trace_file_name = arg[1]
required_CAN_ID = arg[2]
display_mode = arg[3]
output_file_name = arg[4]

print("\n***********************************************************************************\n")
print("Executing the LUA Script for parsing CAN Trace Files .. courtesy KEYUR KULKARNI")
print("The CAN Trace file name is "..can_trace_file_name)
print("The CAN ID that needs to be looked for in the above CAN Trace is "..required_CAN_ID)
print("For the above CAN ID in the above trace file, you expect to receive "..display_mode)
print("The output of the following program needs to be stored in file "..output_file_name)
print("The LUA script accepts arguments requested above")
print("\n***********************************************************************************\n")

-- parsing argument 1
-- reading all data from the given file in a variable that can be referred from later (instead of repeated access to the file).
can_trace_file = io.open(can_trace_file_name,"r")
can_trace_file_content = can_trace_file:read("*all")
can_trace_file:close()

-- parsing argument 2
-- parsing argument 3
-- parsing argument 4
-- parsing argument 5