--
-- Abstract: Storyboard Api Sample using AppWarp
--
--
-- Demonstrates use of the AppWarp API (connect, disconnect, joinRoom, subscribeRoom, chat )
--

display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"
local widget = require "widget"

-- load first scene
storyboard.gotoScene( "ConnectScene", "fade", 300 )

-- Replace these with the values from AppHQ dashboard of your AppWarp app
API_KEY = "dd9258c6f35e0a5559fc208a3f281adc6ec9b88e78c25caa75425693afd38a40"
SECRET_KEY = "8b84b3924f0d05811ad0fbd0e9aa219ed67b9167d87408f7252020f1481eada5"

-- create global warp client and initialize it
appWarpClient = require "AppWarp.WarpClient"
appWarpClient.initialize(API_KEY, SECRET_KEY)

--appWarpClient.enableTrace(true)

-- IMPORTANT! loop WarpClient. This is required for receiving responses and notifications
local function gameLoop(event)
  appWarpClient.Loop()
end

Runtime:addEventListener("enterFrame", gameLoop)