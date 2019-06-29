-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--[[
This is comment
spans
several lines.
]]

print("Hello World!");

display.newText("Hello World!", 50, 0, native.systemFont, 16);

local num1 = 3 + 3;
display.newText(num1, 10, 100, native.systemFont, 32);

local photo1 = display.newImage("images/logo1.jpg", 160, 300);


display.setStatusBar(display.HiddenStatusBar);
--display.setStatusBar(display.DefaultStatusBar);
--display.setStatusBar(display.DarkStatusBar);
--display.setStatusBar(display.TranslucentStatusBar);

local x = 90;
local y = 475;
local rect1 = display.newRect(x, y, 150, 50);
rect1:setFillColor(51, 255, 0);

rect1.strokeWidth = 8;
rect1:setStrokeColor(80, 200, 130);


