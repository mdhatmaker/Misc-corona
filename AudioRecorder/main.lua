-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local progressRing = require("progressRing")
local physics = require("physics")
physics.start()
physics.setGravity(0,0)

-- Import code into your class
appWarpClient = require "AppWarp.WarpClient"
-- Initialize SDK
appWarpClient .initialize("dd9258c6f35e0a5559fc208a3f281adc6ec9b88e78c25caa75425693afd38a40", "8b84b3924f0d05811ad0fbd0e9aa219ed67b9167d87408f7252020f1481eada5") 
 
-- [Background]
--local bg = display.newImage('background.png')
--local bg = display.newImage('faceA0001.png')
--bg.x = display.contentCenterX
--bg.y = display.contentCenterY

-- [Buttons]
--local stopBtn
--local recBtn
--local play
--local playAgain

-- Variables
local recording     --the recording object
local recPath
local recorded      --recorded audio
local audiofilename = 'myRecording.aif'
local ringObject
local radius = 100
local circlex = display.contentCenterX
local circley = display.contentCenterY
local big_circle
local small_circles = {}
local circle_count = 10
local beepOnSound
local beepOffSound
local swapSound
local big_circle_id
local xs, ys
local highlight_circle = {}

-- Functions
local Main = {}
local addListeners = {}
local startRec = {}
local stopRec = {}
local soundComplete = {}
local replay = {}
local deleteFile = {}
local main_circle = {}
local circular_xy = {}
local tap_small_circle = {}
local createRingObject = {}
local highlightSmallCircle = {}
local playMessage = {}
local myOnConnectDoneFunc = {}

-- Main Function
function Main()
    display.setStatusBar(display.HiddenStatusBar)

    big_circle = main_circle( 1, circlex, circley, radius )

    xs,ys = circular_xy(circlex, circley, radius+120, circle_count)
    for i = 1, circle_count do
        print(string.format("%d:  %d , %d", i, xs[i], ys[i]))
        --table.insert(circles, display.newCircle( xs[i], ys[i], 2 ))
        table.insert(small_circles, small_circle(i, xs[i], ys[i], radius/2))
        small_circles[i].id = i
    end

    beepOnSound = audio.loadSound( "sounds/beep_short_on.wav" )
    beepOffSound = audio.loadSound( "sounds/beep_short_off.wav" )
    swapSound = audio.loadSound( "sounds/pop_drip.wav" )

    --stopBtn = display.newImage('stopBtn.png', 170, 580)
    --recBtn = display.newImage('recBtn.png', 70, 580)
    --play = display.newImage('play.png', 116, 569)
    --play.isVisible = false
    --playAgain = display.newImage('playAgain.png', 130, 650)
    --playAgain.isVisible = false

    ringObject = createRingObject()

    addListeners()

    -- Connect to AppWarp server
    appWarpClient.connectWithUserName("Alice")

    --local path = system.pathForFile( audiofilename, system.DocumentsDirectory )
    --print("Sound File Path:" .. path)
end

function highlightSmallCircle(i, paint)
    local highlight_radius = 58
    highlight_circle[i] = display.newCircle(xs[i], ys[i], highlight_radius)
    --local paint = { 0, 0, 1}
    highlight_circle[i].stroke = paint
    highlight_circle[i].strokeWidth = 8
    small_circle(i, xs[i], ys[i], radius/2)
end

function clearHighlight(i)
    highlight_circle[i].isVisible = false
end

function isHighlighted(i)
    if highlight_circle ~= nil and highlight_circle[i] ~= nil and highlight_circle[i].isVisible == true then
        return true
    else
        return false
    end
end

function createRingObject()
    --ringObject = progressRing.new()
    -- radius of 100 pixels, gray background, green ring, ring depth of 33%,
    -- takes 15 seconds to make a full rotation:
    ringObject = progressRing.new({
     radius = 112,
     --bgColor = {1, 0, 0, 1},
     bgColor = {.5, .5, .5, 1},
     ringColor = {0, 1, 0, 1},
     ringDepth = .99,
     time = 15000,
     hideBG = true,
     --bottomImage = 'faceA0001.png'
     --position = 0,
    })
    ringObject.x = circlex
    ringObject.y = circley
    return ringObject
end

function circular_xy(cx, cy, r, count)
    local sin, cos = math.sin, math.cos
    local deg, rad = math.deg, math.rad
    math.sin = function (x) return sin(rad(x)) end
    math.cos = function (x) return cos(rad(x)) end
    local xs = {}
    local ys = {}
    local degree_mult = 360 / count
    for i = 0, count-1 do
        table.insert(xs, cx + r * math.cos(i * degree_mult))
        table.insert(ys, cy + r * math.sin(i * degree_mult))
    end
    return xs, ys
    --require 'pl.pretty'.dump(xs)
    --require 'pl.pretty'.dump(ys)
end

function main_circle(i, cx, cy, r)
    local circle = display.newCircle( cx, cy, r )
    -- Set the fill (paint) to use the bitmap image
    local paint = {
        type = "image",        
        filename = string.format("faces/face%04d.thumbnail.A.png", i)
    }
    -- Fill the circle
    circle.fill = paint
    big_circle_id = i
    return circle
end

function small_circle(i, cx, cy, r)
    local circle = display.newCircle( cx, cy, r )
    -- Set the fill (paint) to use the bitmap image
    local paint = {
        type = "image",        
        filename = string.format("faces/face%04d.thumbnail.B.png", i)
    }
    -- Fill the circle
    circle.fill = paint
    return circle
end

function small_circles:tap(e)
    local id = e.target.id
    print( "Tap event on: " .. id .. "  " .. big_circle_id)
    if isHighlighted(id) then
        playMessage(id)
        clearHighlight(id)
    end
    if big_circle_id ~= id then
        big_circle = main_circle( e.target.id, circlex, circley, radius )
        local swapChannel = audio.play( swapSound )
        ringObject = createRingObject()
    end
end

function touch_big_circle(e)
    --print(event.phase)
    if e.phase == "began" then
        print("You touched the big circle!")
        big_circle.xScale = 1.2
        big_circle.yScale = 1.2
        startRec(e)
        return true
    elseif e.phase == "ended" then
        print("You UNTOUCHED the big circle!")
        big_circle.xScale = 1.0
        big_circle.yScale = 1.0
        stopRec(e)
        return false
    end
end

function addListeners()
    --recBtn:addEventListener('tap', startRec)
    --playAgain:addEventListener('tap', replay)

    big_circle:addEventListener("touch", touch_big_circle)

    for i = 1,circle_count do
        small_circles[i]:addEventListener('tap', small_circles)
    end
    --ringObject:addEventListener('completed', ringUpdate)

    -- Add listeners
    appWarpClient.addRequestListener("onConnectDone", myOnConnectDoneFunc)
end

function deleteDocumentFile(f)
    local destDir = system.DocumentsDirectory  -- Location where the file is stored
    local result, reason = os.remove( system.pathForFile( f, destDir ) )
    
    if result then
        print( "File removed" )
    else
        print( "File does not exist", reason )  --> File does not exist    apple.txt: No such file or directory
    end
end

--function ringUpdate()
--    --print "Yoooooooooooooooooo!!!!"
--    ringObject:removeEventListener('completed', ringUpdate)
--    ringObject.ringColor = {1, 1, 0, 1}
--    ringObject:goTo(.75)
--end

function startRec(e)
    --stopBtn:addEventListener('tap', stopRec)   
    --deleteDocumentFile(audiofilename)
    recPath = system.pathForFile(audiofilename, system.DocumentsDirectory)
    recording = media.newRecording(recPath)    
    --recording:startTuner()
    recording:startRecording()    
    local beepOnChannel = audio.play( beepOnSound )
    --recBtn.isVisible = false

    ringObject:goTo(1)

    transition.to(stopBtn, {time=200, x=display.contentWidth * 0.5})
end

function stopRec(e)
    --stopBtn:removeEventListener('tap', stopRec)
    recording:stopRecording()
    --recording:stopTuner()
    local beepOffChannel = audio.play( beepOffSound )

    --stopBtn.isVisible = false
    --play.isVisible = true

    ringObject:reset()

    highlightSmallCircle(big_circle_id, {0, 0, 1})

    -- Play recorded file
    recorded = audio.loadStream('myRecording.aif', system.DocumentsDirectory)
    audio.play(recorded, {onComplete=soundComplete})
end

function playMessage(i)
    --highlightSmallCircle(i, {.61, .39, 0})
    highlight_circle[i].stroke = {.61, .39, 0}
    recorded = audio.loadStream('myRecording.aif', system.DocumentsDirectory)
    audio.play(recorded, {onComplete=soundComplete})
end

function soundComplete()
    audio.dispose(recorded)

    --recBtn.isVisible = true
    --stopBtn.isVisible = true
    --stopBtn.x = 217
    --play.isVisible = false
    --playAgain.isVisible = true
end

function replay()
    --recBtn.isVisible = false
    --stopBtn.isVisible = false
    audio.play(recorded, {onComplete=soundComplete})
end

            
-- Define listener callbacks
function myOnConnectDoneFunc(resultCode)    
   if(resultCode == WarpResponseResultCode.SUCCESS) then      
      print("Connected successfully")    
   else      
      print("Connect failed..")    
   end  
end 



Main()




