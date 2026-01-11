local myFunctions = {}
    

    
    --SwapTurns 
    -- Input: currentTurn x or y
    -- Output: nextTurn y or x
    --This Function checks what the current turn is and swaps it.
    function myFunctions.swapTurn(turn)
        if turn == "X" then
            return ("O")
        else
            return("X")
        end
    end

    --checkWin 
    -- Input: the current turn, global vars: board
    -- Output: Win as a 3 (yes) or 0 (No)
    --This Function checks what the current turn is and swaps it.
    function myFunctions.checkWin(turn, board, winningSet)
        for i, rows in ipairs(winningSet) do
            local selects = 0
            for e, sqIndex in ipairs(rows) do
                if board[sqIndex][7] == turn then
                    selects = selects + 1
                end
            end
            if selects == 3 then 
                return true
            end
        end
        return false
    end

    --This function checks if every cell on the board has a value in it
    --Input:pointer to the board
    --Outputs true if full, false if not
    function myFunctions.checkFullBoard(board)
        local fullCount = 0
        for index, cell in ipairs(board) do
            if board[index][7] ~= 0 then
                fullCount = fullCount + 1
            end
        end
        if fullCount == #board then
            return true
        end
        return false
    end


    -- save previous game into a single array of moves
    -- input ordered moves made by, player 1 and player 2
    function myFunctions.savePreviousMoves(turnsX, turnsO)
        local maxMoves = math.max(#turnsX, #turnsO)
        local previousMoves = {}
            for moveindex = 1, maxMoves do
                if turnsX[moveindex] then
                        table.insert(previousMoves, {"X",turnsX[moveindex][1]})
                end

                if turnsO[moveindex] then
                    table.insert(previousMoves, {"O",turnsO[moveindex][1]})
                end
            end
        return previousMoves
    end











            

return myFunctions