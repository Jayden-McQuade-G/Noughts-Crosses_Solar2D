-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

require("lunatest") --import the test framework
--require("modules.myFunctions") --import code to test
--require("modules.mainMenu")
require("tests.Mytests") --import the tests and run them
local composer = require("composer")

composer.gotoScene("modules.mainMenu")



