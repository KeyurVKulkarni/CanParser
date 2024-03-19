----------------------------------------------------------------------------------------------------------------------------------------------
-- WHOEVER USES THIS CAN PARSER AS PER THE RULES MENTIONED SHALL DO SO WITH THE BLESSING OF KEYUR KULKARNI
-- Date: March 13, 2024
-- Author: Keyur Kulkarni (keyur@maxwellenergy.co)
-- File name: balancing_parser.lua
-- While using this script in command line, along with Run command, provide <1> trace file full name (must not contain spaces).
-- This CAN parser is hard-coded to CAN ID 18FF30D0
----------------------------------------------------------------------------------------------------------------------------------------------

file = io.open(arg[1],"r")
text = file:read("*all")
file:close()
index = 1
parserCellNumber = 0
flag = 0
record = 0 -- number of records of cell voltages printed in the Output
cellNumber = arg[2]
loopCellNumber = ((math.floor(cellNumber/3))*3)

----------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES USED FOR INDEX MANIPULATION DENOTING NUMBER OF CHARACTERS
----------------------------------------------------------------------------------------------------------------------------------------------

betweenCanIdAndPayloadLen = 2       -- number of characters between the beginning of the CAN ID field and the Data Length field.
betweenPayloadLenAndPayload = 2     -- number of characters between the beginning of the Data Length field and the Data Payload field.
betweenCanIdAndTiming = 21          -- number of characters between the beginning of the CAN ID field and the Timing field.
timeField_txtLen = 12               -- number of characters present in the Timing field that are to be read.
data_payload_txt_len = 0            -- number of characters present in the Data Payload field that are to be read. Configured automatically as per the Data Payload Length field.

----------------------------------------------------------------------------------------------------------------------------------------------
-- READ THE CAN TRACE FILE UNTIL THE REQUIRED MESSAGE IS NOT FOUND
----------------------------------------------------------------------------------------------------------------------------------------------

while index ~= nil do
    
    flag = 0
    -- print("Entering For Loop")
    parserCellNumber = 0
    while parserCellNumber<=loopCellNumber do
        -- print("loop "..i.." has begun")      -- DEBUG MESSAGE

        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- FIND THE REQUIRED CAN ID IN THE CAN TRACE FILE
        ----------------------------------------------------------------------------------------------------------------------------------------------

        canId = "18FF30D0"                      -- fixed CAN ID for reading cell voltages.
        canId_len = 8                           -- since, CAN ID is fixed, length of the CAN ID is also fixed.
        index = string.find(text, canId, index) -- getting the place in the file where the required CAN ID begins.

        ----------------------------------------------------------------------------------------------------------------------------------------------
        -- EXIT CONDITION: WHEN, AFTER THE CURRENT INDEX, REQUIRED CAN ID IS NOT FOUND IN THE TRACE FILE
        ----------------------------------------------------------------------------------------------------------------------------------------------

        if index == nil then
            flag = 1                            -- raising the flag for traceability later in the code.
            print("breaking from index nil")    -- loop breaking debug message
            break
        else

            ----------------------------------------------------------------------------------------------------------------------------------------------
            -- GOING BEHIND THE INDEX TO ACCESS THE SERIAL NUMBER AND MESSAGE TIMING FIELDS IN THE CAN TRACE
            ----------------------------------------------------------------------------------------------------------------------------------------------

            -- GETTING CAN MESSAGE TIMING FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

            index = index - betweenCanIdAndTiming + 1                                   -- adjusting index to the required characters.
            timing_present = string.sub(text, index, (index + timeField_txtLen))        -- extracting Message Timing field from CAN Trace.
            -- print(timing_present)                                                    -- DEBUG MESSAGE
            index = index + (betweenCanIdAndTiming) - 1                                 -- since the above information was obtained by going behind the Index, the index has to be restored ; done in line below.

            ----------------------------------------------------------------------------------------------------------------------------------------------
            -- GOING AHEAD THE INDEX TO ACCESS THE DATA PAYLOAD LENGTH AND DATA PAYLOAD FIELDS IN THE CAN TRACE
            ----------------------------------------------------------------------------------------------------------------------------------------------

            -- GETTING THE DATA PAYLOAD LENGTH FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

            index = index + canId_len + betweenCanIdAndPayloadLen                       -- adjusting index to the required characters.
            data_payload_len = 8                                                        -- since the CAN ID is fixed, the Data Payload Length for the given CAN ID is known to be 8

            -- GETTING THE DATA PAYLOAD FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

            data_payload_txt_len = 3*data_payload_len-1                                 -- based on value of data length field, calculating the number of characters for data payload.
            -- print(data_payload_txt_len)                                              -- DEBUG MESSAGE
            index = index + betweenPayloadLenAndPayload                                 -- number of characters after which data payload starts.
            -- print(index)                                                             -- DEBUG MESSAGE
            data_payload = string.sub(text, index, (index+data_payload_txt_len))        -- extracting the data payload from the CAN trace.
            -- print(data_payload)                                                      -- DEBUG MESSAGE
            filtered_data_payload = string.gsub(data_payload, " ", "")                  -- removing the spaces present in the data payload acquired from the CAN trace.
            -- print(filtered_data_payload)                                             -- DEBUG MESSAGE

            ----------------------------------------------------------------------------------------------------------------------------------------------
            -- INTERPRETATION OF DATA FROM THE DATA PAYLOAD
            -- (for now simplest interpetation is implemented. configurable interpretation is being developed)
            ----------------------------------------------------------------------------------------------------------------------------------------------

            data_cellIndex = tonumber((string.sub(filtered_data_payload, 0, 4)), 16)    -- (2 bytes) extracting the Cell Index, that tells which Cell's voltages are present in the CAN message 
            if data_cellIndex == nil then data_cellIndex = 0 end                        -- handling nil value
            -- print(data_cellIndex)                                                    -- DEBUG MESSAGE
            data_cellIndex0 = tonumber((string.sub(filtered_data_payload, 5, 8)), 16)   -- (2 bytes) extracting voltages of Cell number (cell_index+3)
            if data_cellIndex0 == nil then data_cellIndex0 = 0 end                      -- handling nil value
            -- print(data_cellIndex0)                                                   -- DEBUG MESSAGE
            data_cellIndex1 = tonumber((string.sub(filtered_data_payload, 9, 12)), 16)  -- (2 bytes) extracting voltages of Cell number (cell_index+3)
            if data_cellIndex1 == nil then data_cellIndex1 = 0 end                      -- handling nil value
            -- print(data_cellIndex1)                                                   -- DEBUG MESSAGE
            data_cellIndex2 = tonumber((string.sub(filtered_data_payload, 13, 16)), 16) -- (2 bytes) extracting voltages of Cell number (cell_index+3)
            if data_cellIndex2 == nil then data_cellIndex2 = 0 end                      -- handling nil value
            -- print(data_cellIndex2)                                                   -- DEBUG MESSAGE


            if data_cellIndex == 0 or data_cellIndex ~= parserCellNumber then                   -- if cell index begins from 0 (i.e. new set of cell voltages) or some arbitrary cell voltages appear ..
                data_output = timing_present.." ; C_"..(data_cellIndex+1).." : "..data_cellIndex0.." ; "                 -- .. then begin a new data-point ..
            else
                data_output = data_output..timing_present.." ; C_"..(data_cellIndex+1).." : "..data_cellIndex0.." ; "    -- .. else continue appending the data point with previous cell voltages.
            end
            data_output = data_output.."C_"..(data_cellIndex+2).." : "..data_cellIndex1.." ; "
            data_output = data_output.."C_"..(data_cellIndex+3).." : "..data_cellIndex2.." ; "

            if data_cellIndex ~= parserCellNumber then 
                parserCellNumber = data_cellIndex
            end

            if ((flag == 0 and data_cellIndex == loopCellNumber)) then
                record = record+1
                print(record.." ; "..data_output)
            end
        end
        parserCellNumber = parserCellNumber+3 -- 
    end
end

print("Keyur")
