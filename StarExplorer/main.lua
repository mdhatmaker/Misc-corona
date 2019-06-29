-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)
-- By default, the physics engine simulates standard Earth gravity which causes
-- objects to fall toward the bottom of the screen. To change this, we use the
-- physics.setGravity() command.

-- Seed the random number generator
math.randomseed(os.time())

-- An "image sheet" allows you to load multiple images/frames from a single larger
-- image file. Image sheets are also used for animated sprites, where frames for
-- the sprite are pulled from the sheet and assembled into an animated sequence.

-- Configure image sheet
local sheetOptions = 
{
    frames =
    {        
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
-- Load the image sheet into memory with the graphics.newImageSheet() command
local objectSheet = graphics.newImageSheet("gameObjects.png", sheetOptions)

-- Initialize variables
local lives = 3
local score = 0
local died = false

local asteroidsTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

-- The "stage" is essentially the core layer/group in which all display objects exist.

-- In this game, we'll insert objects into distinct display groups for more controlled
-- layering and organization. Basically, a display group is a special kind of display
-- object which can contain other display objects and even other display groups.
-- Imagine it as a blank sheet of paper on which you "draw" images, text, shapes,
-- and animated sprites.

-- Set up display groups
local backGroup = display.newGroup()    -- Display group for the background image
local mainGroup = display.newGroup()    -- Display group for the ship, asteroids, lasers, etc.
local uiGroup = display.newGroup()      -- Display group for UI objects like the score
-- The most important aspect here is the order in which the groups are created. In the
-- previous chapter, you learned that images loaded in succession will stack from back
-- to front in terms of visual layering. This same principle applies to display groups:
-- not only will display objects inserted into a display group stack/layer in this
-- back-to-front manner, but you can also layer display groups one atop the other by
-- creating them in similar succession.

-- Load the background
local background = display.newImageRect(backGroup, "background.png", 800, 1400)
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Loading an individual image from an image sheet is similar to loading it from a
-- file. Instead of supplying an image name, however, we specify a reference to the
-- image sheet along with a frame number. Add the following highlighted line to your
-- project code:
ship = display.newImageRect(mainGroup, objectSheet, 4, 98, 79)  -- 4th frame of an image sheet (objectSheet)
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody(ship, { radius=30, isSensor=true })
ship.myName = "ship"
-- Essentially, sensor objects detect collisions with other physical objects but they
-- do not produce a physical response.

-- Display lives and scores
livesText = display.newText(uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36)
scoreText = display.newText(uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36)

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end






