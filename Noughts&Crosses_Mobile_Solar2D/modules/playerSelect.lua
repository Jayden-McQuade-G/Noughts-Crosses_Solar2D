local composer = require( "composer" )
 
local scene = composer.newScene()

composer.setVariable( "playerSelect", nil )
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local widget = require("widget")

--Set Centers to variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenWidth = display.contentWidth
local screenHeight = display.contentHeight
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    -- Code here runs when the scene is first created but has not yet appeared on screen
    sceneGroup = self.view

    
    -- Handle a button Click, on end click phase
    local function buttonXHandler(event)
        if ("ended" == event.phase) then
            composer.setVariable( "playerSelect", "X" )
            composer.gotoScene( "modules.gameScene" )
            composer.removeScene("modules.playerSelect")

        end
    end

    local function buttonOHandler(event)
        if ("ended" == event.phase) then
            composer.setVariable( "playerSelect", "O" )
            composer.gotoScene( "modules.gameScene" )
            composer.removeScene("modules.playerSelect")
    
        end
    end

    local function backHandler (event)
        if ("ended" == event.phase) then
            composer.gotoScene("modules.mainMenu")
            composer.removeScene("modules.playerSelect")
        end
    end

    --set background to white
    local background = display.newRect( centerX, centerY, screenWidth, screenHeight )
    sceneGroup:insert(background)

    --Heading
    local title = display.newText({
        text = "Choose Your Player!",
        x = centerX,
        y = 30,
        fontSize = 25
    })
    title:setFillColor( 0, 0, 0 )
    sceneGroup:insert(title)


    local buttonX = widget.newButton({
        x = centerX-70,
        y = centerY-40,
        label = "X",
        onEvent = buttonXHandler,
        fontSize = 30,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
 
        shape = "roundedRect",
        width = display.contentWidth/3,
        height =  display.contentHeight/4,
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(buttonX)

    local buttonO = widget.newButton({
        x = centerX+70,
        y = centerY-40,
        label = "O",
        onEvent = buttonOHandler,
        fontSize = 30,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
 
        shape = "roundedRect",
        width = display.contentWidth/3,
        height =  display.contentHeight/4,
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(buttonO)

    local descriptX = display.newText({
        text = 'Edgey and Fast\n"X" always goes\nfirst.',
        x = centerX-70,
        y = centerY+60,
        fontSize = 15
    })
    descriptX:setFillColor( 0, 0, 0 )
    sceneGroup:insert(descriptX)

    local descriptO = display.newText({
        parent = sceneGroup,
        text = 'Curvey and Patient\n"O" always goes\nsecond.',
        x = centerX+70,
        y = centerY+60,
        fontSize = 15
    })
    descriptO:setFillColor( 0, 0, 0 )
    sceneGroup:insert(descriptO)
    
    local backButton = widget.newButton({
        x = centerX / 3,
        y = centerY * 1.8,
        label = "Back",
        onEvent = backHandler,
        fontSize = 15,
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
 
        shape = "roundedRect",
        width = display.contentWidth/6,
        height =  display.contentHeight/11,
        fillColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0 } }
    })
    -- insert button into sceneGroup
    sceneGroup:insert(backButton)
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    -- remove every item from scene group
    for displayObject = sceneGroup.numChildren,1 , -1 do
        sceneGroup[displayObject]: removeSelf()
        sceneGroup[displayObject] = nil
    end



 
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