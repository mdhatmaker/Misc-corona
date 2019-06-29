-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local tapCount = 0

local background = display.newImageRect("background.png", 360, 570)
background.x = display.contentCenterX
background.y = display.contentCenterY

local tapText = display.newText(tapCount, display.contentCenterX, 20, native.systemFont, 40)
tapText:setFillColor(0, 0, 0)       -- red, green, blue, alpha (alpha defaults to 1)

local platform = display.newImageRect("platform.png", 300, 50)
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local balloon = display.newImageRect("balloon.png", 112, 112)
balloon.x = display.contentCenterX
balloon.y = display.contentCenterY
balloon.alpha = 0.8

-- load the Box2D physics engine (and start it)
local physics = require("physics")
physics.start()

-- addBody converts images/objects into "physical" objects
physics.addBody(platform, "static")                             -- "static" = NOT affected by gravity
physics.addBody(balloon, "dynamic", { radius=50, bounce=0.3 })  -- "dynamic" (the default) IS affected
-- The bounce value can be any non-negative decimal or integer value.
-- A value of 0 means that the balloon has no bounce, while a value of 1 will
-- make it bounce back with 100% of its collision energy. A value of 0.3, as
-- seen above, will make it bounce back with 30% of its energy.

-- A bounce value greater than 1 will make an object bounce back with more
-- than 100% of its collision energy. Be careful if you set values above 1 since
-- the object may quickly gain momentum beyond what is typical or expected.

-- Even if you change the balloon's bounce property to 0, it will still bounce
-- off the platform object because, by default, objects have a bounce value of 0.2.
-- To completely remove bouncing in this game, set both the balloon and the
-- platform to bounce=0.

local function pushBalloon()
    balloon:applyLinearImpulse(0, -0.75, balloon.x, balloon.y)    
    tapCount = tapCount + 1
    tapText.text = tapCount
end
-- balloon:applyLinearImpulse is a really cool command. When applied to a dynamic
-- physical object like the balloon, it applies a "push" to the object in any direction.
-- The parameters that we pass tell the physics engine how much force to apply (both
-- horizontally and vertically) and also where on the object's body to apply the force.

-- Detect event type "tap" for balloon object (and call pushBalloon function when fired)
balloon:addEventListener("tap", pushBalloon)








