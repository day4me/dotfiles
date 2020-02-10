local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local modkey = "Mod4"

local s = awful.screen.focused()

local todo = wibox({width=400, height=400, visible = false, type = "normal", screen = s})
--awful.placement.maximize(todo)

local w = wibox.widget{
    markup = 'This <i>is</i> a <b>textbox</b>!!!',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

todo:set_widget(w)

todo:buttons(gears.table.join(awful.button({modkey}, 1, function () awful.mouse.wibox.move(todo) end)))

function todo_show()
    todo.visible = true
end

function todo_hide()
    todo.visible = false
end

return todo
