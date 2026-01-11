
-----------------------------------------------------------------------------------------
--
-- playComputer.lua
--
-----------------------------------------------------------------------------------------
local playComputer = {}

math.randomseed(os.time()) -- using a time based random seed will allow the following andom functions to be more random


--Computer Function (Easy)
--Creates an opponent for the player when they select play against computer 
function playComputer.easyOpp(turn, board)
    -- Check it is the computers move
        --check and store available choices
        local emptySqList = {}
        for index = 1, 9 do
            if board[index][7] == 0 then
                table.insert(emptySqList, index)
            end
        end
        --if no sqaures available no move can be made
        if #emptySqList > 0 then
            local choice = math.random(1, #emptySqList)
            choice = emptySqList[choice]
            return choice
        end
end

-- Checks if either of the players have inputted two squares in a row and 
-- retruns the first location to win/avoid loss.
-- Uses the WINNINGSET to make decsion
local function checkWinMov(board, winningSet, player)
    local choice
    for i, rows in ipairs(winningSet) do
        local playX = 0
        local playO = 0
        local empty = 0
        for e, index in ipairs(rows) do
            if board[index][7] == 0 then
                empty = index
            elseif board[index][7] == player then
                playX = playX + 1
            else
                playO = playO + 1
            end
        end
        --Checks if either player has 2 in row, places preference on its own win, 
        -- saves blocking the other player for end of loop
        if playO == 2 and empty ~= 0 then
            return empty

        elseif playX == 2 and empty ~= 0 then
            choice = empty
        end
    end
    --If even the other player has no two in a row will return nil
    if choice ~= nil then
        return choice
    else
        return nil
    end
end


-- This function checks if placing a sqaure anywhere creates two rows of two
local function checkTwoRowTwo(board, winningSet, player, bot)
-- Find empty squares 
    local emptySqList = {}
    for index = 1, 9 do
        if board[index][7] == 0 then
            table.insert(emptySqList, index)
        end
    end

    -- test if any placement in the empty squares result in two rows of two
    for y, index in ipairs(emptySqList) do
        local setsOfTwo = 0

        board[index][7] = bot

        -- Checks all winning sets if any rows of two exist
        for i, winRow in ipairs(winningSet) do
            local empty = 0
            local playO = 0

            -- checks avialability and plays in each cell of a win row
            for x, int in ipairs(winRow) do 
                if board[int][7] == 0 then 
                    empty = empty + 1
                elseif board[int][7] == player then
                    playO = playO + 1
                end
            end

            -- if two of the squares of a row belong to the bot and there is one empty, one row is found
            if playO == 2 and empty == 0 then
                setsOfTwo = setsOfTwo + 1
            end
        end

        -- checks if two rows of rows exist reset board and return that square
        if setsOfTwo >= 2 then
            board[index][7] = 0
            return index 
        end
        -- Reset board for next
        board[index][7] = 0
    end
    return nil
end



-- Checks if the last player made a move in a corner and placed their move in the corresponding corner if available
local function counterCorner(board, turnsX)
    local choice = 0
    local corners = {1, 3, 7, 9}
    local lastIndex = #turnsX
    -- Checks what sqaure was placed and what to return
    if lastIndex == 1 then
        choice = 9
    elseif lastIndex == 3 then 
        choice = 7
    elseif lastIndex == 7 then 
        choice = 3
    elseif lastIndex == 9 then 
        choice = 1
    else 
        return nil
    end
    -- checks if the corresponding sqaure is available
    if board[choice][7] == 0 then
        return choice
    else
        return nil
    end
end

--Checks if any of the boards corners are free, returns the first free corner.
local function checkCorner(board)
    local corners = {1, 3, 7, 9}
    for x, index in ipairs( corners ) do
         if board[index][7] == 0 then
            return index
         end
    end
    return nil
end


--Computer Function (Hard)
--Creates an opponent for the player when they select play against computer 
function playComputer.hardOpp(turn, board, winningSet, turnsX, player, bot)
    -- Check it is the computers move

        --check and store available choices
        local emptySqList = {}
        for index = 1, 9 do
            if board[index][7] == 0 then
                table.insert(emptySqList, index)
            end
        end

        -- Looks for the best square to place an O
        --if no squares available no move can be made
        -- checks if two in row, places on third
        if #emptySqList > 0 then
            local choice = checkWinMov(board, winningSet, player)
            if  choice ~= nil then
                return choice
            end
        -- Checks if can make two rows of two
        
            choice = checkTwoRowTwo(board, winningSet, player, bot)
            if choice ~= nil then
                return choice
            end

        --checks if the middle is empty and places there
            if board[5][7] == 0 then
                choice = 5
                return choice
            end
    

        -- Checks if the player placed in a corner and places in the adjacent corner if available
            choice = counterCorner(board, turnsX)
            if choice ~= nil then
                return choice
            end

        -- places in any corner
            choice = checkCorner(board)
            if choice ~= nil then
                return choice

        --Put it in an empty square
            else
                local choice = math.random(1, #emptySqList)
                choice = emptySqList[choice]
                return choice
            end
        end
    end


return playComputer