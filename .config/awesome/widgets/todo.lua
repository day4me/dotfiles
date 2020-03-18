local gtable = require("gears.table")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Minimal TodoList
local todo_textbox = wibox.widget.textbox() -- to store the prompt
local todo_file = os.getenv("HOME").."/.todoslist"

local todo_max = 6
local todos = {
  ttexts = {},
  tbuttons = {},
  del_line = {},
  tlayout = {}
}

local function update_history()
  local i = 1
  local todo_list = io.open(todo_file, "r")
  if todo_list == nil then return end
  for line in todo_list:lines() do
    local text = line or ""
    todos.ttexts[i].markup = text
    i = i+1
  end
  todo_list:close()

  if i < todo_max then -- clear the rest
    for o = i, todo_max do
      todos.ttexts[o].markup = ""
    end
  end
end

--local function exec_prompt()
--  awful.prompt.run {
--    prompt = " New task: ",
--    fg = beautiful.fg_grey ,
--    history_path = os.getenv("HOME").."/.history_todo",
--    textbox = todo_textbox,
--    exe_callback = function(input)
--      if not input or #input == 0 then return end
--      local command = "echo "..input.." >> "..history_file
--      awful.spawn.easy_async_with_shell(command, function()
--        update_history()
--      end)
--    end
--  }
--end

local function remove_todo(line)
  local line = line or 0
  local command = "[ -f "..todo_file.." ] && sed -i "..line.."d "..todo_file
  awful.spawn.easy_async_with_shell(command, function()
    update_history()
  end)
end

function button_create(cmd)
  local w = wibox.widget.textbox
  w.buttons(gtable.join(button({}, 1, function() cmd() end)))
  return w
end

function widgets_box(l, widgets, space)
  local spacing = space or 0
  local _layout = wibox.layout.fixed.horizontal -- default horiz
  if l == "vertical" then _layout = wibox.layout.fixed.vertical end

  local w = wibox.widget { layout = _layout, spacing = dpi(spacing) } -- init a widget
  for _, widget in ipairs(widgets) do
    w:add(widget)
  end

  return w
end


for i=1, todo_max do
  todos.ttexts[i] = wibox.widget { align  = "left", valign = "left", widget = wibox.widget.textbox }
  todos.del_line[i] = function() remove_todo(i) end -- serve to store the actual line
  todos.tbuttons[i] = button_create(todos.del_line[i])
  todos.tlayout[i] = widget_box('horizontal', { todos.tbuttons[i], todos.ttexts[i] })
end

update_history()

local todo_new = button.create("", beautiful.primary_light, beautiful.primary, exec_prompt, 10)
local todo_widget = widget.box("horizontal", { todo_new, todo_textbox })
local todo_l = widget_box("vertical", todos.tlayout)

local td = wibox({visible=false, type="normal"})

local function td_show()
td.visible=true
end

td:setup(todo_widget)
