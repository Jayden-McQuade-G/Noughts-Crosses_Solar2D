
-----------------------------------------------------------------------------------------
--
-- gameScene.lua
--
-----------------------------------------------------------------------------------------

-- Access the composer library
local composer = require("composer")

-- Create a current Scene
local scene = composer.newScene()

------------------------------------------------------------------------------------------

-- access Modules from playComputer
-- hardOpp: player vs Hard mode Computer 
-- easyOpp: player vs Easy mode Computer
local playComputer = require("modules.playComputer")
local myFunctions = require("modules.myFunctions")
local fileTask = require("modules.fileTask")
local widget = require("widget")


--Set Centers to variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight

-- Setting up composer variables to track wins, losses and draws for each player 

if composer.getVariable("wins") == nil then
    composer.setVariable("wins", 0)
end  
if composer.getVariable("loss") == nil then
    composer.setVariable("loss", 0)
end
if composer.getVariable("draws") == nil then
    composer.setVariable("draws", 0)
end

DRAWS = composer.getVariable("draws")
WINS = composer.getVariable("wins")
LOSS = composer.getVariable("loss")

-- Global variables for PVP scores 
if composer.getVariable("xWins") == nil then
    composer.setVariable("xWins", 0)
end  
if composer.getVariable("oWins") == nil then
    composer.setVariable("oWins", 0)
end
if composer.getVariable("pvpDraw") == nil then
    composer.setVariable("pvpDraw", 0)
end

XWINS = composer.getVariable("xWins")
OWINS = composer.getVariable("oWins")
PVPDRAW = composer.getVariable("pvpDraw")


composer.setVariable( "pastGame")

-- Game state
GAMELOADING = false


-----------------------------------------------------------------------------------------
function scene:create(event)
    local sceneGroup = self.view

    local resetGame -- this allows resetGame function to access other functions function, to reset variables


    



    d = display
    w20 = d.contentWidth * .2
    h20 = d.contentHeight * .2 
    w40 = d.contentWidth * .4
    h40 = d.contentHeight * .4
    w60 = d.contentWidth * .6
    h60 = d.contentHeight * .6
    w80 = d.contentWidth * .8
    h80 = d.contentHeight * .8


    ----DRAW LINES FOR BOARD
    local function drawBoard()
        local lline = d.newLine(w40,h20,w40,h80 )
        lline.strokeWidth = 5
        sceneGroup:insert(lline)

        local rline = d.newLine(w60,h20,w60,h80 )
        rline.strokeWidth = 5
        sceneGroup:insert(rline)

        local bline = d.newLine(w20,h40,w80,h40 )
        bline.strokeWidth = 5
        sceneGroup:insert(bline)

        local tline = d.newLine(w20,h60,w80,h60 )
        tline.strokeWidth = 5
        sceneGroup:insert(tline)
    end


    --depicts what mode the user is in
    local function createHeading()
        local headText
        if GAMEMODE == "playerMode" then
            headText = "PVP"
        elseif GAMEMODE == "easyMode" then
            headText = "Easy Mode"
        else
            headText = "Hard Mode"
        end

        local title = display.newText({
            text = headText,
            x = centerX,
            y = centerY/5.5,
            fontSize = 25
        })
        title:setFillColor( 1, 1, 1 )
        sceneGroup:insert(title)
    end
    
    --displays win, loss, draw stats at top of page
    local function keepScore()
        -- Retrieve global scores
        WINS = composer.getVariable("wins")
        LOSS = composer.getVariable("loss")
        DRAWS = composer.getVariable("draws")

        -- PVP variables
        XWINS = composer.getVariable("xWins")
        OWINS = composer.getVariable("oWins")
        PVPDRAW = composer.getVariable("pvpDraw")
        
        
        if GAMEMODE == "playerMode" then
            -- For PvP, show X and O scores separately
            local statText = '"X" Score: ' .. XWINS .. '\n"O" Score: ' .. OWINS .. "\nDraws: " .. PVPDRAW
            -- Clear any existing version of the display object
            if statsPVP then
                display.remove( statsPVP )
                statsPVP = nil 
            end
                statsPVP = display.newText({
                    text = statText,
                    x = 45,
                    y = 15,
                    fontSize = 13
                })
                statsPVP:setFillColor(1, 1, 1)
                sceneGroup:insert(statsPVP)
        
        -- Check if it's Player vs Computer mode
        else
            -- Update the display for Player vs Computer mode
            local statText = 'Win Score: ' .. WINS .. '\nLoss Score: ' .. LOSS .. "\nDraws: " .. DRAWS
            -- Clear any existing version of the display object
            if statsPVB then
                display.remove( statsPVB)
                statsPVB = nil
            end

                statsPVB = display.newText({
                    text = statText,
                    x = 50,
                    y = centerY/5,
                    fontSize = 13
                })
                statsPVB:setFillColor(1, 1, 1)
                sceneGroup:insert(statsPVB)
        end  
    end  




        --Input: Index of the selected square, the current turn
    --FILL COMPARTMENT(square) W/ COLOUR WHEN TOUCHED
    local function fill (sqIndex, board, currentTurn)
    -- Checks if a value already exists in a square, if not places new objects inside square.
        if board[sqIndex][7] == 0 then
            local r = display.newRect(board[sqIndex][3],board[sqIndex][6],w20,h20)
            sceneGroup:insert(r)
            -- Checks whos turn it is, X = Red O = Green
            if currentTurn == "X" then
                r:setFillColor(1,0,0)
            elseif currentTurn == "O" then
                r:setFillColor(0,1,0)
            end
            -- Display "X" or "O" in square, set to default native font
            local text = display.newText(currentTurn, board[sqIndex][3] + w20 /2, board[sqIndex][6] + h20 /2, native.systemFont, 35)
            text:setFillColor(0, 0, 0)
            sceneGroup:insert(text)

            -- stores what value is in what square

            board[sqIndex][7] = currentTurn
            --Stored as key value pair
            local fill = {sqIndex, r, text}


            print(currentTurn,"placed in cell #", sqIndex)
            r.anchorX=0
            r.anchorY=0
            return board, fill
        end
    end
        

-- Create a button that completes a function when clicked
    local function handleButtonEvent(event)
        if not GAMELOADING then
            if ("ended" == event.phase) then
                composer.gotoScene("modules.mainMenu")
                composer.removeScene("modules.gameScene")
            end
        end
    end
    

-- Activated when undoButton clicked
-- resets the previous move
    local function handleUndoButton (event)
        if ("ended" == event.phase) then
            if not GAMELOADING then
                local currentMove = CURRENTTURN
                local turnsX = TURNSX
                local turnsO = TURNSO
                if currentMove == "O" then
                    if #turnsX > 0 then
                        local lastMove = turnsX[#turnsX]
                        local sqIndex = lastMove[1]
                        local rect = lastMove[2]
                        local text = lastMove[3]

                        display.remove(rect)
                        display.remove(text)

                        -- remove last move from move list and reset that cell on the board to 0
                        BOARD[sqIndex][7] = 0
                        table.remove(turnsX, #turnsX)

                        -- swap player back to previous move
                        CURRENTTURN = myFunctions.swapTurn(CURRENTTURN)
                    end
                    
                else 
                    if #turnsO > 0 then
                        local lastMove = turnsO[#turnsO]
                        local sqIndex = lastMove[1]
                        local rect = lastMove[2]
                        local text = lastMove[3]

                        display.remove(rect)
                        display.remove(text)

                        -- remove last move from move list and reset that cell on the board to 0
                        BOARD[sqIndex][7] = 0
                        table.remove(turnsO, #turnsO)

                        -- swap player back to previous move
                        CURRENTTURN = myFunctions.swapTurn(CURRENTTURN)
                    end
                end
            end
        end
    end

    -- Activated when resetStatButton clicked
    local function handleResetStat(event)
        if ("ended" == event.phase) then
            if GAMEMODE == "playerMode" then
                composer.setVariable( "xWins", 0) 
                composer.setVariable( "oWins", 0)
                composer.setVariable( "pvpDraw", 0)
                

            else
                composer.setVariable( "wins", 0) 
                composer.setVariable( "loss", 0)
                composer.setVariable( "draws", 0)
                fileTask.saveScores(0, 0, 0)
                print("Stats Reset and Saved")
            end
        keepScore()
        end
    end

   


-- Activated when the replayButton clicked 
local function handleReplay(event)
    if ("ended" == event.phase) then
        if not GAMELOADING then
            GAMELOADING = true
            resetGame()
            
            
            
            print("replay begin")
            local previous = composer.getVariable("pastGame")
            if previous then
                local delay = 500

                for x, pastMove in ipairs(previous) do
                    local fillreplay = function() 
                        fill(pastMove[2], BOARD, pastMove[1]) 
                    end
                    timer.performWithDelay(delay, fillreplay)

                    delay = delay + 1000
                end

                -- Delay set to run after replay
                timer.performWithDelay(delay, function()
                    GAMELOADING = false 
                    resetGame()
                    
                end)
            else
                local error = display.newText({
                    text = "No games to replay, play a game first",
                    x = centerX,
                    y = 60,
                    fontSize = 10
                })
                error:setFillColor(1, 1, 1)

                -- Remove error message after a delay
                timer.performWithDelay(1000, function()
                    display.remove(error)
                end)

                -- Allow button to be clicked after delay
                GAMELOADING = false
            end
        end
    end
end    
  



    local function createButtons()
        local menuButton = widget.newButton({
            x = centerX,
            y = centerY *1.85,
            label = "Main Menu",
            fontSize = 14,
            onEvent = handleButtonEvent,
            labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
 
            shape = "roundedRect",
            width = 100,
            height =  screenHeight/8,
            fillColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0 } }
        })
        -- insert button into sceneGroup
        sceneGroup:insert(menuButton)


        local undoButton = widget.newButton({
            x = centerX /4,
            y = centerY *1.85,
            label = "Undo",
            fontSize = 14,
            onEvent = handleUndoButton,
            labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
 
            shape = "roundedRect",
            width = 70,
            height =  screenHeight/8,
            fillColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0 } }
        })
        sceneGroup:insert(undoButton)


        local resetStatButton = widget.newButton({
            x = centerX* 1.71,
            y = centerY * 1.65,
            label = "Reset Score",
            fontSize = 10,
            onEvent = handleResetStat,
            labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
 
            shape = "roundedRect",
            width = 80,
            height =  25,
            fillColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0 } }
        })
        sceneGroup:insert(resetStatButton)


        local replayButton = widget.newButton({
            x = centerX* 1.75,
            y =  centerY *1.85,
            label = "Replay",
            fontSize = 14,
            onEvent = handleReplay,
            labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
 
            shape = "roundedRect",
            width = 70,
            height =  display.contentHeight/8,
            fillColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0 } }
        })
        sceneGroup:insert(replayButton)

    end


    --sets all variables required to start the game
    local function initialiseCode()

        GAMEMODE = composer.getVariable( "menuOption" )
        PLAYERSELECT = composer.getVariable( "playerSelect")

        if PLAYERSELECT == "X" then
            BOT = "O"
        else
            BOT = "X"
        end

        -- Run all functions neccercary for set up
        createHeading()
        keepScore()
        drawBoard()
        createButtons()

        --PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE
        BOARD = 
        {{"tl", 1, w20, h40, w40, h20,0},
        {"tm",2, w40,h40,w60,h20,0},
        {"tr",3, w60,h40,w80,h20,0},

        {"ml", 4, w20, h60, w40, h40,0},
        {"mm",5, w40,h60,w60,h40,0},
        {"mr",6, w60,h60,w80,h40,0},

        {"bl", 7, w20, h80, w40, h60,0},
        {"bm",8, w40,h80,w60,h60,0},
        {"br",9, w60,h80,w80,h60,0}}

        --List of winning combinations
        WINNINGSET = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}}

        CURRENTTURN = "X"

        local EMPTY, X, O = 0, 1, 2 -- this is useless atm
        
        WINNER =  0
        TURNSX = {}
        TURNSO = {}
        
    end
   



    --- Displays win message to screen
    local function displayWin (currentTurn)
        print("Player "..currentTurn.." won the game")
        local winText =    
            display.newText("Player '"..currentTurn.. "' won the game",  centerX, centerY/3, native.systemFont, 20)
        winText: setFillColor(1,1,1)
        sceneGroup:insert(winText)
        
    end

    local function displayDraw()
        print("Both players came to a draw")
        local drawText =
        display.newText("Draw",  centerX, centerY/3, native.systemFont, 20)
        drawText: setFillColor(1,1,1)
        sceneGroup:insert(drawText)
    end

        -- Caller that links with checkwin, calls checkWin, displayWin, resetGame
    -- Input the Board, current players turn, set of winning values
    -- Output: calls check win and if win calls display win and resetOnTouch
    local function winProcMngr(board, currentTurn, winningSet, winner, turnsX, turnsO, sceneGroup)


        if myFunctions.checkWin(currentTurn, board, winningSet) == true then
            displayWin(currentTurn)

            

            local continue = false

            -- make ordered list of all moves take for this game
            -- set list to composer variable for easy access
            local previousMoves = myFunctions.savePreviousMoves(TURNSX, TURNSO)
            composer.setVariable( "pastGame", previousMoves)

            -- delay before resetting game
            timer.performWithDelay(1000, function() resetGame() end)

            -- Update Scores based on game modes selected
            if GAMEMODE == "playerMode" then
                if currentTurn == "X" then 
                    composer.setVariable("xWins", XWINS+1)
                else
                    composer.setVariable("oWins", OWINS+1)
                end
            else
                if currentTurn == PLAYERSELECT then 
                    composer.setVariable("wins", WINS+1)

                    fileTask.saveScores(WINS+1, LOSS, DRAWS)
                    print("file saved, Wins incremented")
                else
                    composer.setVariable("loss", LOSS+1)

                    fileTask.saveScores(WINS, LOSS+1, DRAWS)
                    print("file saved, Loss incremented")
                end
            end
            return true


        elseif myFunctions.checkFullBoard(board) then
            
            displayDraw()

            -- make ordered list of all moves take for this game
            -- set list to composer variable for easy access
            local previousMoves = myFunctions.savePreviousMoves(TURNSX, TURNSO)
            composer.setVariable( "pastGame", previousMoves)


            timer.performWithDelay(1500, function() resetGame() end)
            if GAMEMODE == "playerMode" then
                composer.setVariable("pvpDraw", PVPDRAW+1)
            else
                composer.setVariable("draws", DRAWS+1)
                fileTask.saveScores(WINS, LOSS, DRAWS+1)
                print("file saved, Draws incremented")
            end
            return true
        end
        return false
    end
    

    local function botRun(winner, winningSet, turnsX, turnsO)
        if GAMELOADING then -- Check if the game is in replay mode
            return
        end
        
        local choice = 0
        local mode = composer.getVariable("menuOption")

        if mode == "playerMode" then
            return
        elseif mode == "easyMode" then
            --run computers moves
            choice = playComputer.easyOpp(CURRENTTURN, BOARD, winningSet, turnsX)
        elseif mode == "hardMode" then
            choice = playComputer.hardOpp(CURRENTTURN, BOARD, winningSet, turnsX, PLAYERSELECT, BOT )
        end
        --run computers moves
        if choice ~= nil then
            local filledSq
            BOARD, filledSq = fill(choice, BOARD, CURRENTTURN)
            if CURRENTTURN == "X" then
                table.insert(TURNSX, filledSq) 
            else
                table.insert(TURNSO, filledSq)
            end
            --Winner handling (computer)
            local winLoss = winProcMngr(BOARD, CURRENTTURN, winningSet, winner, turnsX, turnsO, sceneGroup)
            --Swap Turn after Box is coloured
            
            if winLoss == false then
                CURRENTTURN = myFunctions.swapTurn(CURRENTTURN)
            end
        end
        return
    end
    



    -- reset the game to the beginning, delete all onbjects and redraw
function resetGame() -- Reset is public - accessible by its instantiation above and can be used by functions defined before resetGame definition due to dependencies
        -- loops in reverse order to handle changing indexes as items are removed
       --if not GAMELOADING then
            for displayObject = sceneGroup.numChildren,1 , -1 do
                sceneGroup[displayObject]: removeSelf()
                sceneGroup[displayObject] = nil
            end
            initialiseCode()

            if not GAMELOADING and PLAYERSELECT == "O" then
                botRun(WINNER, WINNINGSET, TURNSX, TURNSO)
            end
            
            return true
        --end
    end

    -- onClick
    -- When someone clicks the screen calls the relevent functions
function onClick( event ) -- public so it is accessible to previos functions and the event listener
        if event.phase == "began" then
            if not GAMELOADING then
                local tap = 0
                -- Checks What square a screen touch was in
                for sqIndex = 1, 9 do
                    if event.x > BOARD[sqIndex][3] and event.x < BOARD[sqIndex][5] then
                        if event.y < BOARD[sqIndex][4] and event.y > BOARD[sqIndex][6] then

                            -- Ensures square is empty & fills
                            if BOARD[sqIndex][7] == 0 then

                                -- hold the filled object + square number
                                local filledSq
                                BOARD, filledSq = fill(sqIndex, BOARD, CURRENTTURN)
                                if CURRENTTURN == "X" then
                                    table.insert(TURNSX, filledSq) 
                                else
                                    table.insert(TURNSO, filledSq)
                                end 

                                --Winner handling (Player)
                                local winLoss = winProcMngr(BOARD, CURRENTTURN, WINNINGSET, WINNER, TURNSX, TURNSO, sceneGroup)

                                if winLoss == false then
                                    CURRENTTURN = myFunctions.swapTurn(CURRENTTURN)
                                    

                                    if GAMEMODE ~= "playerMode" then
                                        botRun(WINNER, WINNINGSET, TURNSX, TURNSO)      
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end      
    end
    Runtime:addEventListener("touch", onClick)

    





initialiseCode()
if PLAYERSELECT == "O" then
    botRun(WINNER, WINNINGSET, TURNSX, TURNSO)
end


end



-- show scene
-- called before the scene is show on the display, first time and when app switches back
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- code here runs when the scene is still iff screen (but is about to come on screen)
    elseif phase == "did" then
        --code here runs when the scenen is entirley on screen
    end
end

-- hide scene 
-- called just bbefore and after the scene goes off display
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- code here runs when the scene is still iff screen (but is about to come on screen)

    elseif phase == "did" then
        --code here runs when the scenen is entirley on screen
    end
end

-- delete scene
-- call when the scene is no longer required, use to clean up scene specific, e.g unload audio, close network connections etc.
function scene:destroy(event)
    local sceneGroup = self.view

    --  code here runs prior to remobval of scene

    -- remove every item from scene group
    for displayObject = sceneGroup.numChildren,1 , -1 do
        sceneGroup[displayObject]: removeSelf()
        sceneGroup[displayObject] = nil
    end

    -- remove event listner fromrun time
    Runtime:removeEventListener("touch", onClick)

    BOARD = nil
    CURRENTTURN = nil
    WINNER = nil
    TURNSX = nil
    TURNSO = nil
    WINNINGSET = nil
    GAMELOADING = nil

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene





