-----------------------------------------------------------------------------------------
--
-- mainMenu.lua
--
-----------------------------------------------------------------------------------------
-- Access the composer library
local composer = require("composer")

-- Create a current Scene
local scene = composer.newScene()
composer.setVariable( "menuOption", nil )

-- --------------------------------------------------------------------------------------
-- code outside of scene event functions will on be executed ONCE unless scene is removed entirly via composer.removeScene()
-- ----------------------------------------------------------------------------------------------------------------

-- load in widgets library for buttons
local widget = require("widget")
local fileTask = require("modules.fileTask")

--Set Centers to variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight


-- Setting up composer variables to track wins, losses and draws for each player 
local scores = fileTask.readScores("scores.txt")
if scores and #scores >= 3  then
    WINS = scores[1] -- sets it to what is read
    LOSS = scores[2]
    DRAWS = scores[3]

    composer.setVariable("wins", WINS)
    composer.setVariable("loss", LOSS)
    composer.setVariable("draws", DRAWS)
    end
    

if WINS == nil then
    composer.setVariable( "wins", 0)
end  
if LOSS == nil then
    composer.setVariable( "loss", 0)
end
if DRAWS == nil then
    composer.setVariable( "draws", 0) 
end
DRAWS = composer.getVariable("draws")
WINS = composer.getVariable("wins")
LOSS = composer.getVariable("loss")



-- --------------------------------------------------------------------------------------
-- scene event Functions
-- --------------------------------------------------------------------------------------

-- create new scene, runs when a scene is created but not yet viewed on screen.
function scene: create(event)
    -- easy reference, allows to insert display objects in the Display Group, allows the onjects to moved on and off the screen with the scene
    local sceneGroup = self.view
    

    --set background to white
    local background = display.newRect( centerX, centerY, screenWidth, screenHeight )
    sceneGroup:insert(background)

    local title = display.newText({
        text = "SUPER Circles & X's",
        x = centerX,
        y = 50,
        fontSize = 25
    })
    title:setFillColor( 0, 0, 0 )
    sceneGroup:insert(title)

    local function mainScore()
        -- Clear any existing version of the display object
        if mainScoreText then
            display.remove( mainScoreText )
            mainScoreText = nil 
        end

        DRAWS = composer.getVariable("draws")
        WINS = composer.getVariable("wins")
        LOSS = composer.getVariable("loss")

        local statText = "Scores\nWins: " .. WINS .. "    Loss: " .. LOSS .. "\nDraws: " .. DRAWS

        mainScoreText = display.newText({
            text = statText,
            x = centerX,
            y = centerY - 50,
            fontSize = 25
        })
        mainScoreText:setFillColor(0, 0, 0)
        sceneGroup:insert(mainScoreText)
    end
    mainScore()
   

    -- Handle a button Click, on end click phase
    local function handlePlayerEvent(event)
        if ("ended" == event.phase) then
            composer.setVariable( "menuOption", "playerMode" )
            composer.gotoScene( "modules.gameScene" )
            composer.removeScene("modules.mainMenu")

        end
    end

    local function handleEasyEvent(event)
        if ("ended" == event.phase) then
            composer.setVariable( "menuOption", "easyMode" )
            composer.gotoScene( "modules.playerSelect" )
            composer.removeScene("modules.mainMenu")

        end
    end

    local function handleHardEvent(event)
        if ("ended" == event.phase) then
            composer.setVariable( "menuOption", "hardMode" )
            composer.gotoScene( "modules.playerSelect" )
            composer.removeScene("modules.mainMenu")

        end
    end

    -- Activated when resetStatButton clicked
    local function handleResetStat(event)
        if ("ended" == event.phase) then
                composer.setVariable( "wins", 0) 
                composer.setVariable( "loss", 0)
                composer.setVariable( "draws", 0)
                fileTask.saveScores(0, 0, 0)
                print("Stats Reset")
                mainScore()
        end
    end

    local resetStatButton = widget.newButton({
        x = centerX,
        y = centerY * 1.85,
        label = "Reset Score",
        fontSize = 10,
        onEvent = handleResetStat,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },

        shape = "roundedRect",
        width = 80,
        height =  25,
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    sceneGroup:insert(resetStatButton)

    local playerButton = widget.newButton({
        x = centerX,
        y = centerY+90,
        label = "Player vs Player",
        fontSize = 14,
        onEvent = handlePlayerEvent,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        
 
        shape = "roundedRect",
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(playerButton)

    local easyButton = widget.newButton({
        x = centerX-70,
        y = centerY + 150,
        label = "Easy Mode",
        fontSize = 14,
        onEvent = handleEasyEvent,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        width = 120,
        height =  50,
 
        shape = "roundedRect",
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(easyButton)

    local hardButton = widget.newButton({
        x = centerX+70,
        y = centerY+150,
        label = "Hard Mode",
        fontSize = 14,
        onEvent = handleHardEvent,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
 
        shape = "roundedRect",
        width = 120,
        height =  50,
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(hardButton)

end

-- show scene
-- called before the scene is show on the display, first time and when app switches back
function scene: show(event)
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
function scene: hide(event)
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
function scene: destroy(event)
    local sceneGroup = self.view
    --  code here runs prior to remobval of scene

    -- remove every item from scene group
    for displayObject = sceneGroup.numChildren,1 , -1 do
        sceneGroup[displayObject]: removeSelf()
        sceneGroup[displayObject] = nil
    end


end


-------------------------------------------------------------------------------------------------------
-- Scene event function listeners
    
scene: addEventListener( "create", scene )
scene: addEventListener( "show", scene )
scene: addEventListener( "hide", scene )
scene: addEventListener( "destroy", scene )

return scene





