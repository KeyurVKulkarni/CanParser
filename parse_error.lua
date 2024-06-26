----------------------------------------------------------------------------------------------------------------------------------------------
-- WHOEVER USES THIS CAN PARSER AS PER THE RULES MENTIONED SHALL DO SO WITH THE BLESSING OF KEYUR KULKARNI
-- Date: March 30, 2024
-- Author: Keyur Kulkarni (keyur@maxwellenergy.co)
-- File name: parse_error.lua
-- While using this script in command line, along with Run command, provide <1> trace file full name (must not contain spaces).
-- This CAN parser is hard-coded to CAN ID 18FF10D0
----------------------------------------------------------------------------------------------------------------------------------------------

ParserFileNameFull = "parse_error.lua"
ParserInputFileNameFull = arg[1]
ParserInputFileNameFullLen = (string.len(ParserInputFileNameFull))
ParserInputFileNameLen = (ParserInputFileNameFullLen - 4)
ParserInputFileName = string.sub(ParserInputFileNameFull, 1,ParserInputFileNameLen)
ParserInputFile = io.open(ParserInputFileNameFull,"r")
text = ParserInputFile:read("*all")
ParserInputFile:close()
ParserInputFileIndex = 1
parserCellNumber = 0
flag = 0
record = 0 -- number of records of cell voltages printed in the Output
-- errorNumber = arg[2]
-- loopErrorNumber = ((math.floor(errorNumber/4))*4)
BMS_ERROR_CAN_ID_FIXED = "18FF10D0"
canId_match = 0

----------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES USED FOR INDEX MANIPULATION DENOTING NUMBER OF CHARACTERS
----------------------------------------------------------------------------------------------------------------------------------------------

betweenCanIdAndPayloadLen = 2       -- number of characters between the beginning of the CAN ID field and the Data Length field.
betweenPayloadLenAndPayload = 2     -- number of characters between the beginning of the Data Length field and the Data Payload field.
betweenCanIdAndTiming = 21          -- number of characters between the beginning of the CAN ID field and the Timing field.
timeField_txtLen = 12               -- number of characters present in the Timing field that are to be read.

data_payload_txt_len = 0            -- number of characters present in the Data Payload field that are to be read. Configured automatically as per the Data Payload Length field.

ERROR_STATE_MASK = 896              -- 0 0 0 0  0 0 _ _  _ 0 0 0  0 0 0 0
ERROR_STATE_SHIFT = 7               --                   ^-<-<-<--<-<-<-<
ERROR_ID_MASK = 64512               -- _ _ _ _  _ _ 0 0  0 0 0 0  0 0 0 0
ERROR_ID_SHIFT = 10                 --            ^-<-<--<-<-<-<--<-<-<-<

err0_State = 0                      -- Error State Number as extracted from the 1st Error Data in the CAN Message
err1_State = 0                      -- Error State Number as extracted from the 2nd Error Data in the CAN Message
err2_State = 0                      -- Error State Number as extracted from the 3rd Error Data in the CAN Message
err3_State = 0                      -- Error State Number as extracted from the 4th Error Data in the CAN Message

err0_Id = 0                         -- Error ID Number as extracted from the 1st Error Data in the CAN Message
err1_Id = 0                         -- Error ID Number as extracted from the 2nd Error Data in the CAN Message
err2_Id = 0                         -- Error ID Number as extracted from the 3rd Error Data in the CAN Message
err3_Id = 0                         -- Error ID Number as extracted from the 4th Error Data in the CAN Message

error_0_id = ""                     -- Error ID Name present in the 1st Error Data in the CAN Message
error_1_id = ""                     -- Error ID Name present in the 2nd Error Data in the CAN Message
error_2_id = ""                     -- Error ID Name present in the 3rd Error Data in the CAN Message
error_3_id = ""                     -- Error ID Name present in the 4th Error Data in the CAN Message

error_0_state = ""                  -- Error State Name present in the 1st Error Data in the CAN Message
error_1_state = ""                  -- Error State Name present in the 2nd Error Data in the CAN Message
error_2_state = ""                  -- Error State Name present in the 3rd Error Data in the CAN Message
error_3_state = ""                  -- Error State Name present in the 4th Error Data in the CAN Message

----------------------------------------------------------------------------------------------------------------------------------------------
-- READ THE CAN TRACE FILE UNTIL THE REQUIRED MESSAGE IS NOT FOUND
----------------------------------------------------------------------------------------------------------------------------------------------

function error_id_name(error_id)
    if error_id > 51 then error_name = "NUM_"..error_id.."UNDEFINED_ERROR" end
    if error_id == 0 then error_name = "OVERVOLTAGE" end
    if error_id == 1 then error_name = "UNDERVOLTAGE" end
    if error_id == 2 then error_name = "OVERTEMPERATURE" end
    if error_id == 3 then error_name = "UNDERTEMPERATURE" end
    if error_id == 4 then error_name = "OVERLOAD" end
    if error_id == 5 then error_name = "CURRENT_SHORT_CKT_SW" end
    if error_id == 6 then error_name = "BATTERY_PARAM_TIMEOUT" end
    if error_id == 7 then error_name = "BOARD_VALUES_OUTDATE" end
    if error_id == 8 then error_name = "CURRENT_OUTDATE" end
    if error_id == 9 then error_name = "SWITCHBOX_SHUTDOWN" end
    if error_id == 10 then error_name = "OPEN_CONNECTION" end
    if error_id == 11 then error_name = "PDU_FAILURE" end
    if error_id == 12 then error_name = "PDU_OVERTEMP" end
    if error_id == 13 then error_name = "ENCRYPTION_KEY_NOT_VALID" end
    if error_id == 14 then error_name = "CURRENT_SHORT_CIRCUIT_HW" end
    if error_id == 15 then error_name = "DATE_VALID" end
    if error_id == 16 then error_name = "DATA_CORRUPTED" end
    if error_id == 17 then error_name = "PRECHG_ENERGY_OVERLOAD" end
    if error_id == 18 then error_name = "INTERLOCK_ERROR" end
    if error_id == 19 then error_name = "VAR_TYPE_MISMATCH" end
    if error_id == 20 then error_name = "IMD_ERROR" end
    if error_id == 21 then error_name = "SAFETY_FUSE_TRIGGERED" end
    if error_id == 22 then error_name = "ASSOCIATION_ERROR" end
    if error_id == 23 then error_name = "MSD_ERROR" end
    if error_id == 24 then error_name = "HIGH_HUMIDITY_ERROR" end
    if error_id == 25 then error_name = "CELL_TEMP_IMBALANCE" end
    if error_id == 26 then error_name = "PRECHARGE_NO_LOAD_DETECTED" end
    if error_id == 27 then error_name = "PRECHARGE_INCOMPLETE" end
    if error_id == 28 then error_name = "UNAUTHORIZED_CHARGER" end
    if error_id == 29 then error_name = "CHARGER_AUNTHENTICATION_FAILURE" end
    if error_id == 30 then error_name = "DCHG_WELD_DETECTED" end
    if error_id == 31 then error_name = "CHG_WELD_DETECTED" end
    if error_id == 32 then error_name = "DCHG_OPEN_DETECTED" end
    if error_id == 33 then error_name = "CHG_OPEN_DETECTED" end
    if error_id == 34 then error_name = "JSON_PARSE_ERROR" end
    if error_id == 35 then error_name = "LOAD_AUTH_ERROR" end
    if error_id == 36 then error_name = "MCU_CONFIG_MISMATCH" end
    if error_id == 37 then error_name = "UNEXPECTED_RESET" end
    if error_id == 38 then error_name = "SF_PDU_FAULT_ERROR" end
    if error_id == 39 then error_name = "SF_AFE_FAULT_ERROR" end
    if error_id == 40 then error_name = "SF_MCU_FAULT_ERROR" end
    if error_id == 41 then error_name = "END_OF_LIFE_ERROR" end
    if error_id == 42 then error_name = "DEEP_DSCHG_ERROR" end
    if error_id == 43 then error_name = "PACK_IMBALANCE_ERROR" end
    if error_id == 44 then error_name = "CHG_CONTACTOR_OVERTEMP" end
    if error_id == 45 then error_name = "DCHG_CONTACTOR_OVERTEMP" end
    if error_id == 46 then error_name = "PRECHG_REG_OVERTEMP" end
    if error_id == 47 then error_name = "DC_DC_OVERTEMP" end
    if error_id == 48 then error_name = "SF_ANALOG_SENSING_FAULT_ERROR" end
    if error_id == 49 then error_name = "SF_POWER_SUPPLY_FAULT_ERROR" end
    if error_id == 50 then error_name = "DCHG_CURNT_DURING_CHG_ERROR" end
    if error_id == 51 then error_name = "THERMAL_RUNAWAY_ERROR" end
    return error_name
end

function error_state_name(error_state)
    if error_state > 6 then error_name = "NUM_"..error_id.."UNDEFINED_STATE" end
    if error_state == 0  then error_name = "NONE" end
    if error_state == 1  then error_name = "ENTERING_ERROR" end
    if error_state == 2  then error_name = "IN_ERROR" end
    if error_state == 3  then error_name = "LEAVING_ERROR" end
    if error_state == 4  then error_name = "ENTERING_WARNING" end
    if error_state == 5  then error_name = "IN_WARNING" end
    if error_state == 6  then error_name = "LEAVING_WARNING" end
    return error_name
end

ParserOutputFileNameFull = "_parsed_["..ParserInputFileName.."]_output_["..os.date('%Y-%m-%d-%H-%M-%S').."].txt"    -- deciding the File Name based on Trace file name and Date/Time Stamp
-- ParserOutputFile = io.open(ParserOutputFileNameFull, "a")                                                        -- creating the File in 'Append' mode

while ParserInputFileIndex ~= nil do

    flag = 0
    ParserOutputFileNewline = 0

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- FIND THE REQUIRED CAN ID IN THE CAN TRACE FILE
    ----------------------------------------------------------------------------------------------------------------------------------------------

    canId = BMS_ERROR_CAN_ID_FIXED                                        -- fixed CAN ID for reading cell voltages.
    canId_len = string.len(canId)                                         -- since, CAN ID is fixed, length of the CAN ID is also fixed.
    ParserInputFileIndex = string.find(text, canId, ParserInputFileIndex) -- getting the place in the file where the required CAN ID begins.

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- EXIT CONDITION: WHEN, AFTER THE CURRENT INDEX, REQUIRED CAN ID IS NOT FOUND IN THE TRACE FILE
    ----------------------------------------------------------------------------------------------------------------------------------------------

    if ParserInputFileIndex == nil then     -- if required CAN ID is not found then Exit with Debug Message
        flag = 1                            -- raising the flag for traceability later in the code.
        print("In the given Trace File : ' "..ParserInputFileNameFull.." ' , ' "..canId_match.." ' instances of given CAN ID = "..canId.." were found.")        -- loop breaking debug message
        print("The Number of data points derived from the parsed data is ' "..record.." ' , and are presented in File ' "..ParserOutputFileNameFull.." ' .")    -- loop breaking debug message
        break
    else

        canId_match = canId_match +1
        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- GOING BEHIND THE INDEX TO ACCESS THE SERIAL NUMBER AND MESSAGE TIMING FIELDS IN THE CAN TRACE
        ----------------------------------------------------------------------------------------------------------------------------------------------

        -- GETTING CAN MESSAGE TIMING FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

        ParserInputFileIndex = ParserInputFileIndex - betweenCanIdAndTiming + 1                                 -- adjusting ParserInputFileIndex to the required characters.
        timing_present = string.sub(text, ParserInputFileIndex, (ParserInputFileIndex + timeField_txtLen))      -- extracting Message Timing field from CAN Trace.
        -- print(timing_present)                                                                                -- DEBUG MESSAGE
        ParserInputFileIndex = ParserInputFileIndex + (betweenCanIdAndTiming) - 1                               -- since the above information was obtained by going behind the Index, the ParserInputFileIndex has to be restored ; done in line below.

        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- GOING AHEAD THE INDEX TO ACCESS THE DATA PAYLOAD LENGTH AND DATA PAYLOAD FIELDS IN THE CAN TRACE
        ----------------------------------------------------------------------------------------------------------------------------------------------

        -- GETTING THE DATA PAYLOAD LENGTH FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

        ParserInputFileIndex = ParserInputFileIndex + canId_len + betweenCanIdAndPayloadLen                     -- adjusting ParserInputFileIndex to the required characters.
        data_payload_len = 8                                                                                    -- since the CAN ID is fixed, the Data Payload Length for the given CAN ID is known to be 8

        -- GETTING THE DATA PAYLOAD FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

        data_payload_txt_len = 3*data_payload_len-1                                                             -- based on value of data length field, calculating the number of characters for data payload.
        ParserInputFileIndex = ParserInputFileIndex + betweenPayloadLenAndPayload                               -- number of characters after which data payload starts.
        data_payload = string.sub(text, ParserInputFileIndex, (ParserInputFileIndex+data_payload_txt_len))      -- extracting the data payload from the CAN trace.
        filtered_data_payload = string.gsub(data_payload, " ", "")                                              -- removing the spaces present in the data payload acquired from the CAN trace.
        -- print(filtered_data_payload)                                                                         -- DEBUG MESSAGE

        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- INTERPRETATION OF DATA FROM THE DATA PAYLOAD
        -- (for now simplest interpetation is implemented. configurable interpretation is being developed)
        ----------------------------------------------------------------------------------------------------------------------------------------------

        -- PARSING 1st ERROR IN THE DATA PAYLOAD
        error0 = tonumber((string.sub(filtered_data_payload, 0, 4)), 16)                        -- (2 bytes) extracting Data related to the 1st Error present in the CAN message
        if error0 == nil then error0 = 0 end                                                    -- handling nil value
        err0_Id = ((error0 & ERROR_ID_MASK) >> ERROR_ID_SHIFT)                                  -- The Error ID of the 1st CAN Message is treated differently because it inidicates what Error Data might be present in the CAN message.
        error_0_state = error_state_name(((error0 & ERROR_STATE_MASK) >> ERROR_STATE_SHIFT))    -- (3 bits ; Bit-08 to Bit-10) getting the Error State Name from the Error State from the Error Data
        error_0_id = error_id_name(err0_Id)                                                     -- (6 bits ; Bit-11 to Bit-16) getting the Error Name from the Error ID from the Error Data 

        if err0_Id ~= parserCellNumber then                                                     -- if some CAN message having different Error Data appears , then ...
            parserCellNumber = err0_Id                                                          -- ... then adjust Error Counter to the current Error ID number
            ParserOutputFileNewline = 1                                                         -- since, it is against the serial order (breaks the pattern), hence it must be considered as different from the previous Data Points
            if err0_Id == 0 then                                                                -- if the CAN Message with Error ID is received then ..
                record = record+1                                                               -- ... that means that the Data Points appended before must complete one set of readings.
                ParserOutputFilePrint = 1                                                       -- hence the Data Points collected so far must be printed out. So raise the Print flag so that the necessary condition can Write to the Output File
            end
        end

        -- PARSING 2nd ERROR IN THE DATA PAYLOAD
        error1 = tonumber((string.sub(filtered_data_payload, 5, 8)), 16)                        -- (2 bytes) extracting Data related to the 2nd Error present in the CAN message
        if error1 == nil then error1 = 0 end                                                    -- handling nil value
        error_1_state = error_state_name(((error1 & ERROR_STATE_MASK) >> ERROR_STATE_SHIFT))    -- (3 bits ; Bit-08 to Bit-10) getting the Error State Name from the Error State from the Error Data
        error_1_id = error_id_name(((error1 & ERROR_ID_MASK) >> ERROR_ID_SHIFT))                -- (6 bits ; Bit-11 to Bit-16) getting the Error Name from the Error ID from the Error Data 
        
        -- PARSING 3rd ERROR IN THE DATA PAYLOAD
        error2 = tonumber((string.sub(filtered_data_payload, 9, 12)), 16)                       -- (2 bytes) extracting Data related to the 3rd Error present in the CAN message
        if error2 == nil then error2 = 0 end                                                    -- handling nil value
        error_2_state = error_state_name(((error2 & ERROR_STATE_MASK) >> ERROR_STATE_SHIFT))    -- (3 bits ; Bit-08 to Bit-10) getting the Error State Name from the Error State from the Error Data
        error_2_id = error_id_name(((error2 & ERROR_ID_MASK) >> ERROR_ID_SHIFT))                -- (6 bits ; Bit-11 to Bit-16) getting the Error Name from the Error ID from the Error Data 
        
        -- PARSING 4th ERROR IN THE DATA PAYLOAD
        error3 = tonumber((string.sub(filtered_data_payload, 13, 16)), 16)                      -- (2 bytes) extracting Data related to the 4th Error present in the CAN message
        if error3 == nil then error3 = 0 end                                                    -- handling nil value
        error_3_state = error_state_name(((error3 & ERROR_STATE_MASK) >> ERROR_STATE_SHIFT))    -- (3 bits ; Bit-08 to Bit-10) getting the Error State Name from the Error State from the Error Data
        error_3_id = error_id_name(((error3 & ERROR_ID_MASK) >> ERROR_ID_SHIFT))                -- (6 bits ; Bit-11 to Bit-16) getting the Error Name from the Error ID from the Error Data 

        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- INTERPRETATION OF DATA FROM THE DATA PAYLOAD
        -- (for now simplest interpetation is implemented. configurable interpretation is being developed)
        ----------------------------------------------------------------------------------------------------------------------------------------------

        if (ParserOutputFilePrint == 1) then                                                           -- if Print flag is Set then print
            ParserOutputFilePrint = 0                                                                  -- resetting Print flag
            ParserOutputFile:write(record.." ; "..data_output.."\n")                                   -- Write / Append to the Output File
            -- print(record.." ; "..data_output)                                                       -- DEBUG MESSAGE
        end

        if ParserOutputFileNewline == 1 then                                                           -- if cell index begins from 0 (i.e. new set of cell voltages) or some arbitrary cell voltages appear ..
            data_output = timing_present.." ; "..error_0_id.." : "..error_0_state.." , "               -- .. then begin a new data-point ..
        else
            data_output = data_output..timing_present.." ; "..error_0_id.." : "..error_0_state.." , "  -- .. else continue appending the data point with previous cell voltages.
        end
        data_output = data_output..error_1_id.." : "..error_1_state.." , "                             -- appending data related to 2nd Error in the CAN message
        data_output = data_output..error_2_id.." : "..error_2_state.." , "                             -- appending data related to 3rd Error in the CAN message
        data_output = data_output..error_3_id.." : "..error_3_state.." ; "                             -- appending data related to 4th Error in the CAN message
        parserCellNumber = parserCellNumber + 4                                                        -- catching up to the number of Error data 
    end
end
print("Thanks for using "..ParserFileNameFull.."\nAdios Amigo.\n")
