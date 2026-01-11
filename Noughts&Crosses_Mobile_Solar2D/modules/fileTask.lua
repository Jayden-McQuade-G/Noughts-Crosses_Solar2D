--Saves Values into a text document
local fileTask = {}

function fileTask.saveScores(WINS, LOSS, DRAWS)
    -- Path for the file to read
    local path = system.pathForFile( "scores.txt", system.DocumentsDirectory )
    local file, errorString = io.open(path, "w")
    
    if not file then
        --error occured file failed to open
        print("file error, cannot open:"..errorString)
    else
        --write data to file
        file:write(WINS.."\n")
        file:write(LOSS.."\n")
        file:write(DRAWS.."\n")
        --Close the file
        print("file saved")
        
        io.close(file)
    end
    file = nil
    
end

-- Reads each line and saves into a list
function fileTask.readScores()
    local path = system.pathForFile( "scores.txt", system.DocumentsDirectory )
    local values = {}

    -- Try to open the file in read mode
    local file, errorString = io.open(path, "r")
    
    if not file then
        print("File Error, creating new file")
        
        file, errorString = io.open(path, "w") 
        if not file then
            print("Error creating file: " .. errorString)
            return
        else
            -- Write default scores (0, 0, 0) to the file
            file:write("0\n0\n0\n")
            io.close(file) -- Close the file after writing
        end

        -- Now reopen the file for reading
        file, errorString = io.open(path, "r")
        if not file then
            print("file error unable to open: " .. errorString)
            return
        end
    end

    -- Read scores from the file
    for line in file:lines() do
        table.insert(values, tonumber(line) or 0)
    end
    
    io.close(file) -- Close the file and set to nil
    file = nil

    -- Ensure at least 3 scores are returned
    while #values < 3 do
        table.insert(values, 0)
    end

    return values
end


return fileTask