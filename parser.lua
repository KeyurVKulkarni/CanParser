----------------------------------------------------------------------------------------------------------------------------------------------
-- WHOEVER USES THIS CAN PARSER AS PER THE RULES MENTIONED SHALL DO SO WITH THE BLESSING OF KEYUR KULKARNI
-- Date: March 13, 2024
-- Author: Keyur Kulkarni (keyur@maxwellenergy.co)
-- File name: parser.lua
-- While using this script in command line, along with Run command, provide <1> trace file full name (must not contain spaces) <2> required CAN ID
----------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------
-- READING THE CAN TRACE FILE
----------------------------------------------------------------------------------------------------------------------------------------------

file = io.open(arg[1],"r")  -- accessing the file in READ mode.
text = file:read("*all")    -- reading the entire Trace file.
file:close()                -- closing access to the trace file.
index = 1                   -- the index that the parser maintains whenever it has to search for next occurence of the required ID.

----------------------------------------------------------------------------------------------------------------------------------------------
-- GENERAL PURPOSE VARIABLES
----------------------------------------------------------------------------------------------------------------------------------------------

flag = 0    -- program main loop exit flag.
bytes = 0   -- iterator variable for the loop that decodes the bytes of the data payload.
byte1 = 0  -- decoded value of the 1st byte of data payload.
byte2 = 0  -- decoded value of the 2nd byte of data payload.
byte3 = 0  -- decoded value of the 3rd byte of data payload.
byte4 = 0  -- decoded value of the 4rd byte of data payload.
byte5 = 0  -- decoded value of the 5th byte of data payload.
byte6 = 0  -- decoded value of the 6th byte of data payload.
byte7 = 0  -- decoded value of the 7th byte of data payload.
byte8 = 0  -- decoded value of the 8th byte of data payload.

----------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES USED FOR INDEX MANIPULATION DENOTING NUMBER OF CHARACTERS
----------------------------------------------------------------------------------------------------------------------------------------------

betweenCanIdAndPayloadLen = 2       -- number of characters between the beginning of the CAN ID field and the Data Length field.
betweenPayloadLenAndPayload = 2     -- number of characters between the beginning of the Data Length field and the Data Payload field.
betweenCanIdAndTiming = 21          -- number of characters between the beginning of the CAN ID field and the Timing field.
betweenTimingAndSerial = 7          -- number of characters between the beginning of the Timing field and the Serial number field.

timeField_txtLen = 12               -- number of characters present in the Timing field that are to be read.

----------------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES THAT STORE THE REQUIRED FIELDS OF THAT CAN TRACE RECORD
----------------------------------------------------------------------------------------------------------------------------------------------

serialNum = 0       -- houses the Serial Number field from CAN trace.
timing = 0          -- houses the Message Timing field from CAN trace.
data_output = 1     -- houses the string to be printed after concatenation of all fields.

----------------------------------------------------------------------------------------------------------------------------------------------
-- READ THE CAN TRACE FILE UNTIL THE REQUIRED MESSAGE IS NOT FOUND
----------------------------------------------------------------------------------------------------------------------------------------------

while index ~= nil do

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- GET THE REQUIRED CAN ID AND FIND IT IN THE CAN TRACE FILE
    ----------------------------------------------------------------------------------------------------------------------------------------------

    canId = arg[2]                              -- reading the CAN ID passed along with the run command.
    canId_len = string.len(canId)               -- determining the length of the CAN ID (can change between Extened and Standard addressing).
    index = string.find(text, canId, index)     -- getting the place in the file where the required CAN ID begins.
    -- print(canId_len)                         -- DEBUG MESSAGE

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

    index = index - betweenCanIdAndTiming + 1                               -- adjusting index to the required characters.
    timing = string.sub(text, index, (index + timeField_txtLen))            -- extracting Message Timing field from CAN Trace.
    -- print(timing)                                                        -- DEBUG MESSAGE

    -- GETTING THE SERIAL NUMBER FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

    index = index - betweenTimingAndSerial                                  -- adjusting index to the required characters.
    serialNum = string.sub(text, index, (index + betweenTimingAndSerial))   -- extracting Serial Number field from CAN Trace.
    -- print(serialNum)                                                     -- DEBUG MESSAGE

    index = index + (betweenTimingAndSerial + betweenCanIdAndTiming) - 1    -- since the above information was obtained by going behind the Index, the index has to be restored ; done in line below.

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- GOING AHEAD THE INDEX TO ACCESS THE DATA PAYLOAD LENGTH AND DATA PAYLOAD FIELDS IN THE CAN TRACE
    ----------------------------------------------------------------------------------------------------------------------------------------------

    -- GETTING THE DATA PAYLOAD LENGTH FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

    index = index + canId_len + betweenCanIdAndPayloadLen           -- adjusting index to the required characters.
    data_payload_len = tonumber(string.sub(text, index, index+1))   -- extracting Data Payload Length field.

    -- GETTING THE DATA PAYLOAD FIELD OF THAT CAN ID OCCURENCE FROM CAN TRACE FILE

    data_payload_txt_len = 3*data_payload_len-1                             -- based on value of data length field, calculating the number of characters for data payload.
    -- print(data_payload_txt_len)                                          -- DEBUG MESSAGE
    index = index + betweenPayloadLenAndPayload                             -- number of characters after which data payload starts.
    -- print(index)                                                         -- DEBUG MESSAGE
    data_payload = string.sub(text, index, (index+data_payload_txt_len))    -- extracting the data payload from the CAN trace.
    -- print(data_payload)                                                  -- DEBUG MESSAGE
    filtered_data_payload = string.gsub(data_payload, " ", "")              -- removing the spaces present in the data payload acquired from the CAN trace.
    -- print(filtered_data_payload)                                         -- DEBUG MESSAGE

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- INTERPRETATION OF DATA FROM THE DATA PAYLOAD
    -- (for now simplest interpetation is implemented. configurable interpretation is being developed)
    ----------------------------------------------------------------------------------------------------------------------------------------------

    byte1 = tonumber((string.sub(filtered_data_payload, 1, 2)), 16) -- extracting 1st byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte1 == nil then byte1 = 0 end                              -- handling nil value

    byte2 = tonumber((string.sub(filtered_data_payload, 3, 4)), 16) -- extracting 2nd byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte2 == nil then byte2 = 0 end                              -- handling nil value

    byte3 = tonumber((string.sub(filtered_data_payload, 5, 6)), 16) -- extracting 3rd byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte3 == nil then byte3 = 0 end                              -- handling nil value

    byte4 = tonumber((string.sub(filtered_data_payload, 7, 8)), 16) -- extracting 4th byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte4 == nil then byte4 = 0 end                              -- handling nil value

    byte5 = tonumber((string.sub(filtered_data_payload, 9, 10)), 16) -- extracting 5th byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte5 == nil then byte5 = 0 end                              -- handling nil value

    byte6 = tonumber((string.sub(filtered_data_payload, 11, 12)), 16) -- extracting 6th byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte6 == nil then byte6 = 0 end                              -- handling nil value

    byte7 = tonumber((string.sub(filtered_data_payload, 12, 14)), 16) -- extracting 7th byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte7 == nil then byte7 = 0 end                              -- handling nil value

    byte8 = tonumber((string.sub(filtered_data_payload, 14, 16)), 16) -- extracting 8th byte from hexadecimal to decimal value assuming MSB first on the left.
    if byte8 == nil then byte8 = 0 end                              -- handling nil value

    -- chbpRes = tonumber((string.sub(filtered_data_payload, 1, 4)), 16)    -- implementation specific for extracting byte 1 to 4 for isolation resistance of chassis <> BatPlus
    -- if chbpRes == nil then chbpRes = 0 end                               -- handling nil value

    -- chbnRes = tonumber((string.sub(filtered_data_payload, 5, 8)), 16)    -- implementation specific for extracting byte 5 to 8 for isolation resistance of chassis <> BatPlus
    -- if chbnRes == nil then chbnRes = 0 end                               -- handling nil value

    ----------------------------------------------------------------------------------------------------------------------------------------------
    -- DATA, RELATED TO THAT OCCURENCE OF CAN ID AND PAYLOAD INTERPRETATION, TO BE PRINTED IN CONSOLE / OUTPUT FILE 
    ----------------------------------------------------------------------------------------------------------------------------------------------

    data_output = serialNum.." : "..timing.." : "..byte1.." "..byte2.." "..byte3.." "..byte4.." "..byte5.." "..byte6.." "..byte7.." "..byte8
    print(data_output)

    end
end

print("Keyur") -- End of Code
