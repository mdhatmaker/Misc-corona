------------------------------------------------------------------------------------
-- REQUIRE NEEDED MODULES/LIBRARIES
------------------------------------------------------------------------------------
local progressRing = require("progressRing")
local widget = require("widget")
local colorPicker = require("colorPicker")

display.setDefault("background", .85, .85, .85)

------------------------------------------------------------------------------------
-- SCREEN POSITIONING VARIABLES
------------------------------------------------------------------------------------
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenTop = display.screenOriginY
local screenLeft = display.screenOriginX
local screenBottom = display.screenOriginY+display.actualContentHeight
local screenRight = display.screenOriginX+display.actualContentWidth
local screenWidth = screenRight - screenLeft
local screenHeight = screenBottom - screenTop

------------------------------------------------------------------------------------
-- FORWARD DECLARE VARIABLES
------------------------------------------------------------------------------------
local group = display.newGroup()
local title, newRing, ring, dashboard, params, originalParams, ringListener

local bgColor = {.29, .29, .29, 1}
local ringColor = {243/255, 126/255, 48/255, 1}
local strokeColor = {1, 1, 1, 1}

------------------------------------------------------------------------------------
-- SET DEFAULT RING PARAMS
------------------------------------------------------------------------------------
params = {
	radius = math.floor(screenWidth*.4 + 50),
	ringColor = ringColor,
	bgColor = bgColor,
	ringDepth = 1,
	counterclockwise = false,
	strokeWidth = 10,
	strokeColor = strokeColor,
	time = 10000,
}

originalParams = {}
for k,v in pairs(params) do
	originalParams[k] = v
end


------------------------------------------------------------------------------------
-- RING EVENT LISTENER
------------------------------------------------------------------------------------
function ringListener(event)
	local target = event.target
	local position = event.position
	local alert = native.showAlert("ProgressRing Alert", "Rotation complete. Current ring position is "..position, {"OK"})
end

------------------------------------------------------------------------------------
-- UPDATE PROGRESS RING WITH NEW PARAMS
------------------------------------------------------------------------------------
function newRing(params)
	display.remove(ring)
	ring = nil
	
	ring = progressRing.new(params)
	
	if ring.bottomImage ~= nil then
		local scale = params.radius*3 / ring.bottomImage.width
		ring.bottomImage:scale(scale, scale)
	end
	
	if ring.topImage ~= nil then
		local scale = params.radius*1.5 / ring.topImage.width
		ring.topImage:scale(scale, scale)
	end
	
	ring.x, ring.y = centerX, screenTop + screenHeight*.3
	group:insert(1, ring)
	
	local function ringTap()
		if ring.position == 0 then
			ring:goTo(1)
		elseif ring.position == 1 then
			ring:goTo(0)
		end
	end
	
	ring:addEventListener("tap", ringTap)
	ring:addEventListener("rotationEnd", ringListener)
	ring:goTo(1)
end

------------------------------------------------------------------------------------
-- CREATE DASHBOARD
------------------------------------------------------------------------------------
dashboard = display.newGroup()
group:insert(dashboard)

local radiusSlider, radiusTitle, depthSlider, depthTitle, goButton, strokeSlider, strokeTitle, timeSlider, timeTitle, counterclockwiseBox, counterclockwiseTitle, hideBGBox, hideBGTitle, bgColorBox, bgColorTitle, ringColorBox, ringColorTitle, strokeColorBox, strokeColorTitle

local fontSize = screenWidth * .04

local bg = display.newRoundedRect(dashboard, centerX, screenBottom + 40, screenWidth + 20, screenHeight*.5, 80)
bg.anchorY = 1
bg.alpha = .8

local function sliderListener( event )
	local target = event.target
	local phase = event.phase
	local value = event.value
	
	if target == radiusSlider then
		params.radius = math.floor(50 + (value * screenWidth*.4 / 100))
		radiusTitle.text = "radius: "..params.radius
	elseif target == depthSlider then
		params.ringDepth = value*.01
		depthTitle.text = "ringDepth: "..params.ringDepth
	elseif target == strokeSlider then
		params.strokeWidth = math.floor(value*.1)
		strokeTitle.text = "strokeWidth: "..params.strokeWidth
	elseif target == timeSlider then
		params.time = math.floor(1000 + value*90)
		timeTitle.text = "time: "..params.time
    end
    
    if event.phase == "ended" then
    	newRing(params)
    end
end

local function buttonListener(event)
	local target = event.target
	
	if target == counterclockwiseBox then
		params.counterclockwise = target.isOn
	elseif target == hideBGBox then
		params.hideBG = target.isOn
	elseif target == bottomImageBox then
		if target.isOn then
			params.bottomImage = "backImage.png"
		else
			params.bottomImage = nil
		end
	elseif target == topImageBox then
		if target.isOn then
			params.topImage = "coronaLogo.png"
		else
			params.topImage = nil
		end
	end
	
	newRing(params)
end

radiusSlider = widget.newSlider({
    x = centerX,
    y = screenBottom - bg.height * .8,
    width = screenWidth*.8,
    value = 100,
    listener = sliderListener
})
dashboard:insert(radiusSlider)

radiusTitle = display.newText(dashboard, "radius: "..params.radius, radiusSlider.x - radiusSlider.width*.5, radiusSlider.y - radiusSlider.height*.25, native.systemFont, fontSize)
radiusTitle.anchorX, radiusTitle.anchorY = 0, 1
radiusTitle:setFillColor(0)

depthSlider = widget.newSlider({
    x = centerX,
    y = radiusSlider.y + screenHeight*.06,
    width = screenWidth*.8,
    value = 100,
    listener = sliderListener
})
dashboard:insert(depthSlider)

depthTitle = display.newText(dashboard, "ringDepth: "..params.ringDepth, depthSlider.x - depthSlider.width*.5, depthSlider.y - depthSlider.height*.25, native.systemFont, fontSize)
depthTitle.anchorX, depthTitle.anchorY = 0, 1
depthTitle:setFillColor(0)

strokeSlider = widget.newSlider({
    x = centerX,
    y = depthSlider.y + screenHeight*.06,
    width = screenWidth*.8,
    value = 100,
    listener = sliderListener
})
dashboard:insert(strokeSlider)

strokeTitle = display.newText(dashboard, "strokeWidth: "..params.strokeWidth, strokeSlider.x - strokeSlider.width*.5, strokeSlider.y - strokeSlider.height*.25, native.systemFont, fontSize)
strokeTitle.anchorX, strokeTitle.anchorY = 0, 1
strokeTitle:setFillColor(0)

timeSlider = widget.newSlider({
    x = centerX,
    y = strokeSlider.y + screenHeight*.06,
    width = screenWidth*.8,
    value = 100,
    listener = sliderListener
})
dashboard:insert(timeSlider)

timeTitle = display.newText(dashboard, "time: "..params.time, timeSlider.x - timeSlider.width*.5, timeSlider.y - timeSlider.height*.25, native.systemFont, fontSize)
timeTitle.anchorX, timeTitle.anchorY = 0, 1
timeTitle:setFillColor(0)

counterclockwiseBox = widget.newSwitch({
    x = centerX - screenWidth*.4,
    y = timeSlider.y + screenHeight*.04,
    initialSwitchState = params.counterClockwise,
    style = "checkbox",
    onRelease = buttonListener,
})

counterclockwiseTitle = display.newText(dashboard, "counter-clockwise", counterclockwiseBox.x + counterclockwiseBox.width*.75, counterclockwiseBox.y, native.systemFont, fontSize)
counterclockwiseTitle.anchorX = 0
counterclockwiseTitle:setFillColor(0)

hideBGBox = widget.newSwitch({
    x = centerX + screenWidth*.4,
    y = timeSlider.y + screenHeight*.04,
    initialSwitchState = params.hideBG,
    style = "checkbox",
    onRelease = buttonListener,
})

hideBGTitle = display.newText(dashboard, "hide background", hideBGBox.x - hideBGBox.width*.75, hideBGBox.y, native.systemFont, fontSize)
hideBGTitle.anchorX = 1
hideBGTitle:setFillColor(0)

bottomImageBox = widget.newSwitch({
    x = centerX - screenWidth*.4,
    y = counterclockwiseBox.y + screenHeight*.04,
    initialSwitchState = params.bottomImage,
    style = "checkbox",
    onRelease = buttonListener,
})

bottomImageTitle = display.newText(dashboard, "bottom image", bottomImageBox.x + bottomImageBox.width*.75, bottomImageBox.y, native.systemFont, fontSize)
bottomImageTitle.anchorX = 0
bottomImageTitle:setFillColor(0)

topImageBox = widget.newSwitch({
    x = centerX + screenWidth*.4,
    y = counterclockwiseBox.y + screenHeight*.04,
    initialSwitchState = params.topImage,
    style = "checkbox",
    onRelease = buttonListener,
})

topImageTitle = display.newText(dashboard, "top image", topImageBox.x - topImageBox.width*.75, topImageBox.y, native.systemFont, fontSize)
topImageTitle.anchorX = 1
topImageTitle:setFillColor(0)

local function bgColorListener(r, g, b, a)
	bgColor = {r, g, b, a}
	params.bgColor = bgColor
	bgColorBox:setFillColor(unpack(bgColor))
	newRing(params)
end

bgColorBox = display.newRect(dashboard, centerX - screenWidth * .3, topImageTitle.y + screenHeight*.08, screenWidth*.2, screenHeight*.04)
bgColorBox.isHitTestable = true
bgColorBox:setFillColor(unpack(bgColor))
bgColorBox:addEventListener("tap", function() colorPicker.show(bgColorListener, unpack(bgColor)) end)

bgColorTitle = display.newText(dashboard, "bgColor", bgColorBox.x, bgColorBox.y + screenHeight*.04, native.systemFont, fontSize)
bgColorTitle:setFillColor(0)

local function ringColorListener(r, g, b, a)
	ringColor = {r, g, b, a}
	params.ringColor = ringColor
	ringColorBox:setFillColor(unpack(ringColor))
	newRing(params)
end

ringColorBox = display.newRect(dashboard, centerX, topImageTitle.y + screenHeight*.08, screenWidth*.2, screenHeight*.04)
ringColorBox.isHitTestable = true
ringColorBox:setFillColor(unpack(ringColor))
ringColorBox:addEventListener("tap", function() colorPicker.show(ringColorListener, unpack(ringColor)) end)

ringColorTitle = display.newText(dashboard, "ringColor", ringColorBox.x, ringColorBox.y + screenHeight*.04, native.systemFont, fontSize)
ringColorTitle:setFillColor(0)

local function strokeColorListener(r, g, b, a)
	strokeColor = {r, g, b, a}
	params.strokeColor = strokeColor
	strokeColorBox:setFillColor(unpack(strokeColor))
	newRing(params)
end

strokeColorBox = display.newRect(dashboard, centerX + screenWidth * .3, topImageTitle.y + screenHeight*.08, screenWidth*.2, screenHeight*.04)
strokeColorBox.isHitTestable = true
strokeColorBox:setFillColor(unpack(strokeColor))
strokeColorBox:addEventListener("tap", function() colorPicker.show(strokeColorListener, unpack(strokeColor)) end)

strokeColorTitle = display.newText(dashboard, "strokeColor", strokeColorBox.x, strokeColorBox.y + screenHeight*.04, native.systemFont, fontSize)
strokeColorTitle:setFillColor(0)


newRing(params)