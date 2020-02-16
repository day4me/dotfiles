local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local modkey = "Mod4"

local s = awful.screen.focused()

local todo = wibox({width=400, height=400, visible = false, type = "normal", screen = s})
--awful.placement.maximize(todo)




-- Minimal TodoList
local todo_textbox = wibox.widget.textbox() -- to store the prompt
local history_file = os.getenv("HOME").."/.todoslist"

local todo_max = 6
local todos = {
  ttexts = {},
  tbuttons = {},
  del_line = {},
  tlayout = {}
}

local function update_history()
  local i = 1
  local history = io.open(history_file, "r")
  if history == nil then return end
  for line in history:lines() do
    local text = line or ""
    todos.ttexts[i].markup = helpers.colorize_text(text, beautiful.fg_primary)
    i = i+1
  end
  history:close()

  if i < todo_max then -- clear the rest
    for o = i, todo_max do
      todos.ttexts[o].markup = helpers.colorize_text("", beautiful.fg_primary)
    end
  end
end

local function exec_prompt()
  awful.prompt.run {
    prompt = " New task: ",
    fg = beautiful.fg_grey ,
    history_path = os.getenv("HOME").."/.history_todo",
    textbox = todo_textbox,
    exe_callback = function(input)
      if not input or #input == 0 then return end
      local command = "echo "..input.." >> "..history_file
      awful.spawn.easy_async_with_shell(command, function()
        update_history()
      end)
    end
  }
end

local function remove_todo(line)
  local line = line or 0
  local command = "[ -f "..history_file.." ] && sed -i "..line.."d "..history_file
  awful.spawn.easy_async_with_shell(command, function()
    update_history()
  end)
end

for i=1, todo_max do
  todos.ttexts[i] = widget.base_text('left')
  todos.del_line[i] = function() remove_todo(i) end -- serve to store the actual line
  todos.tbuttons[i] = button.create("x ", beautiful.alert_light, beautiful.alert, todos.del_line[i], 10)
  todos.tlayout[i] = widget.box('horizontal', { todos.tbuttons[i], todos.ttexts[i] })
end
update_history()
local todo_new = button.create("", beautiful.primary_light, beautiful.primary, exec_prompt, 10)
local todo_widget = widget.box("horizontal", { todo_new, todo_textbox })
local todo_list = widget.box("vertical", todos.tlayout)


todo:set_widget(todo_widget)


todo:buttons(gears.table.join(awful.button({modkey}, 1, function () awful.mouse.wibox.move(todo) end)))

function todo_show()
    todo.visible = true
end

function todo_hide()
    todo.visible = false
end
