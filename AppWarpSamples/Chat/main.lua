--
-- Abstract: Storyboard Chat Sample using AppWarp
--
--
-- Demonstrates use of the AppWarp API (connect, disconnect, joinRoom, subscribeRoom, chat )
--

display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"
local widget = require "widget"

-- load first scene
storyboard.gotoScene( "ConnectScene", "fade", 400 )

-- Replace these with the values from AppHQ dashboard of your AppWarp app
API_KEY = "cd5fdf0e2a0a912191d17056383d971999594bbbcd1eb524dbc94d74c14de58d"
SECRET_KEY = "96c4d63b2a58449acffb2efdd51005d8e0a30e19b3ef5962df3f6180b51db0db"
STATIC_ROOM_ID = "Room666"

-- create global warp client and initialize it
appWarpClient = require "AppWarp.WarpClient"
appWarpClient.initialize(API_KEY, SECRET_KEY)

--appWarpClient.enableTrace(true)

-- IMPORTANT! loop WarpClient. This is required for receiving responses and notifications
local function gameLoop(event)
  appWarpClient.Loop()
end

Runtime:addEventListener("enterFrame", gameLoop)