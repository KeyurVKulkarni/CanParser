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
i = 0
flag = 0
while index ~= nil do
    
    flag = 0
    -- print("Entering For Loop")
    i = 0
    while i<=30 do
        
        -- print("loop "..i.." has begun") -- DEBUG MESSAGE
        index = string.find(text, "18FF30D0", (index+23))

        if index == nil then
            flag = 1
            print("breaking from index nil")
            break
        else

            index = index+13
            -- print(index) -- DEBUG MESSAGE

            data_payload = string.sub(text, index, (index+23))
            -- print(data_payload) -- DEBUG MESSAGE

            filtered_data_payload = string.gsub(data_payload, " ", "")
            -- print(filtered_data_payload) -- DEBUG MESSAGE

            data_cellIndex = tonumber((string.sub(filtered_data_payload, 0, 4)), 16)
            if data_cellIndex == nil then data_cellIndex = 0 end
            -- print(data_cellIndex) -- DEBUG MESSAGE

            data_cellIndex0 = tonumber((string.sub(filtered_data_payload, 5, 8)), 16)
            if data_cellIndex0 == nil then data_cellIndex0 = 0 end
            -- print(data_cellIndex0) -- DEBUG MESSAGE
            data_cellIndex1 = tonumber((string.sub(filtered_data_payload, 9, 12)), 16)
            if data_cellIndex1 == nil then data_cellIndex1 = 0 end
            -- print(data_cellIndex1) -- DEBUG MESSAGE
            data_cellIndex2 = tonumber((string.sub(filtered_data_payload, 13, 16)), 16)
            if data_cellIndex2 == nil then data_cellIndex2 = 0 end
            -- print(data_cellIndex2) -- DEBUG MESSAGE


            if data_cellIndex == 0 or data_cellIndex ~= i then -- if cell index begins from 0 (i.e. new set of cell voltages) or some arbitrary cell voltages appear ..
                data_output = (data_cellIndex+1).." : "..data_cellIndex0.." , " -- .. then begin a new data-point ..
            else
                data_output = data_output..(data_cellIndex+1).." : "..data_cellIndex0.." , " -- .. else continue appending the data point with previous cell voltages.
            end
            data_output = data_output..(data_cellIndex+2).." : "..data_cellIndex1.." , "
            data_output = data_output..(data_cellIndex+3).." : "..data_cellIndex2.." , "

            if data_cellIndex ~= i then 
                i = data_cellIndex
            end

            if ((flag == 0 and data_cellIndex == 30)) then
                print(data_output)
            end
        end
        i = i+3 -- 
    end
end

print("Keyur")