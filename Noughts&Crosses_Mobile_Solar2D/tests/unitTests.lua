module(..., package.seeall) -- need this to make things visible
local playComputer = require("modules.playComputer")
local myFunctions = require("modules.myFunctions")

--recursivley compares tables of dynamic depths to detirmine if they hold the same values
local function tableCompare(table1, table2)
    -- check if tables are same length
    if #table1 ~= #table2 then
        return false
    end
    -- visit each index
    for index =  1, #table1 do
        local value1 = table1[index]
        local value2 = table2[index]
        -- check if both values of the tables are also tables
        if type(value1) == "table" and type(value2) == "table" then
            --recursivly compare nested tables
            if not tableCompare(value1, value2) then
                return false
            end
        -- check if they are not tables and not equal
        elseif value1 ~= value2 then
            return false
        end
    end
    return true 
end

--------------------------------------------------------------------------------------------------------------------

-- test if given available squares the bot chooses one
function testEasyOpp1()
    assert_equal(playComputer.easyOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,"X"},
            {"tr",3, w60,h40,w80,h20,"O"},
            
            {"ml", 4, w20, h60, w40, h40,"X"},
            {"mm",5, w40,h60,w60,h40,"O"},
            {"mr",6, w60,h60,w80,h40,"O"},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,"O"},
            {"br",9, w60,h80,w80,h60,"x"}
        }),
    --Results
    7 -- choose the last available square
    )
end

-- test if no squares are available what the bot chooses to do.
function testEasyOpp2()
    assert_equal(playComputer.easyOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,"O"},
            {"tr",3, w60,h40,w80,h20,"X"},
            
            {"ml", 4, w20, h60, w40, h40,"X"},
            {"mm",5, w40,h60,w60,h40,"O"},
            {"mr",6, w60,h60,w80,h40,"O"},
            
            {"bl", 7, w20, h80, w40, h60,"O"},
            {"bm",8, w40,h80,w60,h60,"X"},
            {"br",9, w60,h80,w80,h60,"X"}
        }),
    --Results
    nil -- expecting no available squares
    )
end


-----------------------------------------------------------------------------------------------------------------------


--Tests if there are two in a row the bot places in the third
function testHardOpp1()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,"X"},
            {"tr",3, w60,h40,w80,h20,0},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,"O"},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,0}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5}),
    --Results
    3
    )
end

--Tests if theres a move that create two lines of two, The bot places there
function testHardOpp2()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"O"},
            {"tm",2, w40,h40,w60,h20,0},
            {"tr",3, w60,h40,w80,h20,0},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,"X"},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,"O"}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5}),
    --Results
    3
    )
end

-- tests if the centre is free the bot places there
function testHardOpp3()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,0},
            {"tr",3, w60,h40,w80,h20,0},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,0},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,0}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5}),
    --Results
    5
    )
end

--tests if player has played in a corner the bot places in the opposite corner
function testHardOpp4()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,0},
            {"tr",3, w60,h40,w80,h20,0},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,"X"},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,0}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5, 1}),
    --Results
    9
    )
end

-- tests if their is a free corner place there
function testHardOpp5()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,0},
            {"tr",3, w60,h40,w80,h20,0},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,"X"},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,0},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,"O"}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5, 1}),
    --Results
    3
    )
end

-- tests if the bot plays on empty square.
function testHardOpp6()
    assert_equal(playComputer.hardOpp(
        --inputs
        "O",
        {
            {"tl", 1, w20, h40, w40, h20,"X"},
            {"tm",2, w40,h40,w60,h20,0},
            {"tr",3, w60,h40,w80,h20, "O"},
            
            {"ml", 4, w20, h60, w40, h40,0},
            {"mm",5, w40,h60,w60,h40,"X"},
            {"mr",6, w60,h60,w80,h40,0},
            
            {"bl", 7, w20, h80, w40, h60,"X"},
            {"bm",8, w40,h80,w60,h60,0},
            {"br",9, w60,h80,w80,h60,"O"}
        },
        {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}},
        {5, 1}),
    --Results
    2
    )
end

------------------------------------------------------------------------------------------------------------------
    
-- test the swap function to change the player value
function testSwapTurn1()
    assert_equal(myFunctions.swapTurn("O"), "X")
end

function testSwapTurn2()
    assert_equal(myFunctions.swapTurn("X"), "O")
end
    

-----------------------------------------------------------------------------------------------------------------
-- Check full board, full board, should output true if accurate
function testFullBoardFull()
    assert_equal(myFunctions.checkFullBoard({
        {"tl", 1, w20, h40, w40, h20, "X"},
        {"tm", 2, w40, h40, w60, h20, "X"},
        {"tr", 3, w60, h40, w80, h20, "O"},
        {"ml", 4, w20, h60, w40, h40, "X"},
        {"mm", 5, w40, h60, w60, h40, "X"},
        {"mr", 6, w60, h60, w80, h40, "O"},
        {"bl", 7, w20, h80, w40, h60, "X"},
        {"bm", 8, w40, h80, w60, h60, "X"},
        {"br", 9, w60, h80, w80, h60, "O"}
    }), true) 
end


-- Check full board, empty board should output false if accurate
function testFullBoardEmpty()
    assert_equal(myFunctions.checkFullBoard(
        {{"tl", 1, w20, h40, w40, h20, 0},
            {"tm", 2, w40, h40, w60, h20, 0},
            {"tr", 3, w60, h40, w80, h20, 0},
            {"ml", 4, w20, h60, w40, h40, 0},
            {"mm", 5, w40, h60, w60, h40, 0},
            {"mr", 6, w60, h60, w80, h40, 0},
            {"bl", 7, w20, h80, w40, h60, 0},
            {"bm", 8, w40, h80, w60, h60, 0},
            {"br", 9, w60, h80, w80, h60, 0}}
    ), false)
end

    -- Check full board, half full board should output false if accurate
    function testFullBoardHalfFull()
    assert_equal(myFunctions.checkFullBoard(
        {{"tl", 1, w20, h40, w40, h20, 0},
            {"tm", 2, w40, h40, w60, h20, "X"},
            {"tr", 3, w60, h40, w80, h20, 0},
            {"ml", 4, w20, h60, w40, h40, 0},
            {"mm", 5, w40, h60, w60, h40, "X"},
            {"mr", 6, w60, h60, w80, h40, "O"},
            {"bl", 7, w20, h80, w40, h60, 0},
            {"bm", 8, w40, h80, w60, h60, "X"},
            {"br", 9, w60, h80, w80, h60, 0}}
    ), false)
end


-------------------------------------------------------------------------------------------------------------

-- testing for a horizontal win scenario, should output true
function testCheckWinHorizontal()
local board = {
    {"tl", 1, w20, h40, w40, h20, "X"},
    {"tm", 2, w40, h40, w60, h20, "X"},
    {"tr", 3, w60, h40, w80, h20, "X"},
    {"ml", 4, w20, h60, w40, h40, "O"},
    {"mm", 5, w40, h60, w60, h40, "O"},
    {"mr", 6, w60, h60, w80, h40, "O"},
    {"bl", 7, w20, h80, w40, h60, "0"},
    {"bm", 8, w40, h80, w60, h60, "0"},
    {"br", 9, w60, h80, w80, h60, "0"}
}
local winningSet = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}}

assert_equal(myFunctions.checkWin("X", board, winningSet), true)
end

-- Testing for a vertical win scenario, should output true  
function testCheckWinVertical()
local board = {
    {"tl", 1, w20, h40, w40, h20, "X"},
    {"tm", 2, w40, h40, w60, h20, "O"},
    {"tr", 3, w60, h40, w80, h20, "O"},
    {"ml", 4, w20, h60, w40, h40, "X"},
    {"mm", 5, w40, h60, w60, h40, "O"},
    {"mr", 6, w60, h60, w80, h40, "O"},
    {"bl", 7, w20, h80, w40, h60, "X"},
    {"bm", 8, w40, h80, w60, h60, "0"},
    {"br", 9, w60, h80, w80, h60, "0"}
}
local winningSet = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}}

assert_equal(myFunctions.checkWin("X", board, winningSet), true)
end

-- testing for a diagonal win scenario, should output true
function testCheckWinDiagonal()
    local board = {
        {"tl", 1, w20, h40, w40, h20, "X"},
        {"tm", 2, w40, h40, w60, h20, "O"},
        {"tr", 3, w60, h40, w80, h20, "O"},
        {"ml", 4, w20, h60, w40, h40, "0"},
        {"mm", 5, w40, h60, w60, h40, "X"},
        {"mr", 6, w60, h60, w80, h40, "O"},
        {"bl", 7, w20, h80, w40, h60, "0"},
        {"bm", 8, w40, h80, w60, h60, "0"},
        {"br", 9, w60, h80, w80, h60, "X"}
    }
    local winningSet = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}}
    
    assert_equal(myFunctions.checkWin("X", board, winningSet), true)
    end


-- testing for a no win scenario
function testCheckWinNoWin()
local board = {
    {"tl", 1, w20, h40, w40, h20, "X"},
    {"tm", 2, w40, h40, w60, h20, "O"},
    {"tr", 3, w60, h40, w80, h20, "O"},
    {"ml", 4, w20, h60, w40, h40, "X"},
    {"mm", 5, w40, h60, w60, h40, "O"},
    {"mr", 6, w60, h60, w80, h40, "0"},
    {"bl", 7, w20, h80, w40, h60, "0"},
    {"bm", 8, w40, h80, w60, h60, "X"},
    {"br", 9, w60, h80, w80, h60, "0"}
}
local winningSet = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9 }, {3, 5, 7}}

assert_equal(myFunctions.checkWin("X", board, winningSet), false)
end

-------------------------------------------------------------------------------
-- one has no moves one has only 1
function testCheckPreviousList4()
local turnsX = {{1}}
local turnsO = {}
local expectedResult = {{"X", 1}}

local result =  myFunctions.savePreviousMoves(turnsX, turnsO)
assert_equal(tableCompare(result,expectedResult), true)
end

-- No one has made any moves
function testCheckPreviousList3()
local turnsX = {}
local turnsO = {}
local expectedResult = {}

local result =  myFunctions.savePreviousMoves(turnsX, turnsO)
assert_equal(tableCompare(result,expectedResult), true)
end

------------------------------------------------------------------------------
-- player x has made more moves 
function testCheckPreviousList2()
local turnsX = {{1}, {3}, {5}, {6}}
local turnsO = {{2}, {4}}
local expectedResult = {{"X", 1}, {"O", 2}, {"X", 3}, {"O", 4}, {"X", 5}, {"X", 6}}

local result =  myFunctions.savePreviousMoves(turnsX, turnsO)
assert_equal(tableCompare(result,expectedResult), true)
end

-- Both players made even number of moves
function testCheckPreviousList1()
local turnsX = {{1}, {3}, {5}}
local turnsO = {{2}, {4}, {6}}
local expectedResult = {{"X", 1}, {"O", 2}, {"X", 3}, {"O", 4}, {"X", 5}, {"O", 6}}

local result =  myFunctions.savePreviousMoves(turnsX, turnsO)
assert_equal(tableCompare(result,expectedResult), true)
end


----------------------------------------------------------------------------
-- Both tables are the same, should return true
function testTableCompare1()
    local table1 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
    local table2 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
    
    assert_equal(tableCompare(table1, table2), true)
end

-- These tables have 1 value different, they should return false
function testTableCompare2()
    local table1 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
    local table2 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 8}, {3, 5, 7}}

    assert_equal(tableCompare(table1, table2), false)
end

-- Both tables are different, have differnt size nested tables with different values should be false
function testTableCompare3()
    local table1 = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}, {1, 4, 7}, {2, 5, 8}, {3, 6, 9}, {1, 5, 9}, {3, 5, 7}}
    local table2 = {{1, 2}, {4, 5}, {7, 8}, {1, 4}, {2, 5}, {3, 6}, {1, 5}, {3, 5}}
    
    assert_equal(tableCompare(table1, table2), false)
end

-- Both tables are empty should be true
function testTableCompare4()
    local table1 = {}
    local table2 = {}

    assert_equal(tableCompare(table1, table2), true)
end

-- one table is empty one is not
function testTableCompare5()
    local table1 = {{1, 2, 3}}
    local table2 = {}
    
    assert_equal(tableCompare(table1, table2), false)
end

-- one table has the same values as strings and are attached to a convert to number function
-- , this is an experiment. i predicted it would of been true but found it resulted in false
function testTableCompare6()
    local table1 = {{1, tonumber("2"), 3}, {4, 5, tonumber("2")}}
    local table2 = {{1, 2, 3}, {4, 5, 6}}

    assert_equal(tableCompare(table1, table2), false)
end