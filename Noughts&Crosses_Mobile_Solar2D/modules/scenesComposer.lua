-- Access the composer library
local composer = require("composer")

-- Create a current Scene
local scene = composer.newScene()

-- --------------------------------------------------------------------------------------
-- code outside of scene event functions will on be executed ONCE unless scene is removed entirly via composer.removeScene()
-- ----------------------------------------------------------------------------------------------------------------



-- --------------------------------------------------------------------------------------
-- scene event Functions
-- --------------------------------------------------------------------------------------

-- create new scene, runs when a scene is created but not yet viewed on screen.
function scene: create(event)
    -- easy reference, allows to insert display objects in the Display Group, allows the onjects to moved on and off the screen with the scene
    local sceneGroup = self.view
    
    local rect = display.newRect(160, 240, 200, 200)
    rect: setFillColour(0.5,0.5,0.5)
    sceneGroup: insert( rect )

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
function scene: delete(event)
    local sceneGroup = self.view
    --  code here runs prior to remobval of scene

end


-------------------------------------------------------------------------------------------------------
-- Scene event function listeners
    
scene: addEventListener( "create", scene )
scene: addEventListener( "show", scene )
scene: addEventListener( "hide", scene )
scene: addEventListener( "delete", scene )

return scene

