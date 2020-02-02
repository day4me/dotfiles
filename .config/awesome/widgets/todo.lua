local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local modkey = "Mod4"

local s = awful.screen.focused()

todo = wibox({width=400, height=400, visible = false, type = "normal", screen = s})
--awful.placement.maximize(todo)

todo:buttons(gears.table.join(awful.button({}, 1, function () awful.mouse.client.move(todo) end)))

function todo_show()
    todo.visible = true
end

function todo_hide()
    todo.visible = false
end

return todo
