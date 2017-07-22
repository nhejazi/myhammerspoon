--[[
#######===========================#######
####### Hammerspoon configuration #######
#######===========================#######
--]]


-- Turn off dumb animation shit
hs.window.animationDuration = 0


-- Get list of screens and refresh list whenever screens are plugged/unplugged
local screens = hs.screen.allScreens()
local screenwatcher = hs.screen.watcher.new(function()
  screens = hs.screen.allScreens()
end)
screenwatcher:start()


-- Toggle an application between being frontmost app and hidden
function toggle_application(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        hs.application.launchOrFocus(_app)
    end
    local mainwin = app:mainWindow()
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
        end
    end
end


-- Perform tasks to configure the system for my home WiFi network
function home_arrived()
    hs.audiodevice.defaultOutputDevice():setVolume(25)
    hs.notify.new({
          title='Hammerspoon',
            informativeText='at home...volume unmuted'
        }):send()
end


-- Perform tasks to configure the system for any WiFi network other than my home
function home_departed()
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.notify.new({
          title='Hammerspoon',
            informativeText='away from home...volume muted'
        }):send()
end


-- variables for hotkey smash
local smash = {"cmd", "alt", "ctrl"}
local altsmash = {"cmd", "alt", "shift"}
local nudgekey = {"alt", "ctrl"}
local pushkey = {"cmd", "ctrl"}


-- basic function for window movement (using NetHack key definitions)
hs.hotkey.bind(smash, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "U", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "B", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)


-- Move a window a number of pixels in x and y
function nudge(xpos, ypos)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  f.x = f.x + xpos
  f.y = f.y + ypos
  win:setFrame(f)
end

-- Movement hotkeys
hs.hotkey.bind(nudgekey, 'down', function() nudge(0, 100) end)  --down
hs.hotkey.bind(nudgekey, "up", function() nudge(0, -100) end)   --up
hs.hotkey.bind(nudgekey, "right", function() nudge(100, 0) end) --right
hs.hotkey.bind(nudgekey, "left", function() nudge(-100,0) end)  --left


-- For x and y: use 0 to expand fully in that dimension, 0.5 to expand halfway
-- For w and h: use 1 for full, 0.5 for half
function push(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w*x)
  f.y = max.y + (max.h*y)
  f.w = max.w*w
  f.h = max.h*h
  win:setFrame(f)
end

-- Push to screen edge
hs.hotkey.bind(pushkey, "down", function() push(0, 0.5, 1, 0.5) end)  --down
hs.hotkey.bind(pushkey, "up", function() push(0, 0, 1, 0.5) end)      --up
hs.hotkey.bind(pushkey, "right", function() push(0.5, 0, 0.5, 1) end) -- right
hs.hotkey.bind(pushkey, "left", function() push(0, 0, 0.5, 1) end)    -- left


-- window tiling: splitting panes right/left for productivity
hs.hotkey.bind(smash, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind(smash, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- automated re-loading of configuration file when updated
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start() 
hs.alert.show("Config loaded")

-- replacement for Mac Caffeine utility
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    local result
    if state then
        caffeine:setIcon("images/caffeine-on.pdf")
    else
        caffeine:setIcon("images/caffeine-off.pdf")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- reactions to WiFi network changes
local wifiWatcher = nil
local homeSSID = "DialupForLyfe112" --MAY NEED UPDATING
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    print("ssidChangedCallback: old:"..(lastSSID or "nil").." new:"..(newSSID or "nil"))
    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        home_arrived()
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        home_departed()
    end

    lastSSID = newSSID
end


-- launch shortcuts for useful applications/functions
hs.hotkey.bind(smash, "=", function() hs.application.launchOrFocus("Hyper") end)

-- use toggle_applications for Atom, since it behaves kinda weird
hs.hotkey.bind(smash, "-", function() toggle_application("Atom") end)

hs.hotkey.bind(smash, "0", function()
  hs.application.launchOrFocus("MacVim")
end)

hs.hotkey.bind(smash, "space", function()
  hs.spotify.displayCurrentTrack()
end)

hs.hotkey.bind(smash, "P", function()
  hs.application.launchOrFocus("Preview")
end)

hs.hotkey.bind(smash, "]", function()
  hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind(smash, "[", function()
  hs.application.launchOrFocus("Safari")
end)

hs.hotkey.bind(smash, "N", function()
  hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind(smash, "M", function()
  hs.application.launchOrFocus("Kiwi for Gmail")
end)

hs.hotkey.bind(smash, ",", function() hs.application.launchOrFocus("iTerm") end)

hs.hotkey.bind(smash, ".", function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(smash, "/", function()
  hs.application.launchOrFocus("Firefox")
end)

hs.hotkey.bind(smash, ";", function()
  hs.application.launchOrFocus("RStudio")
end)

hs.hotkey.bind(smash, "'", function()
  hs.application.launchOrFocus("Rodeo")
end)

hs.hotkey.bind(smash, "O", function()
  hs.application.launchOrFocus("Calendar")
end)

hs.hotkey.bind(smash, "I", function()
  hs.application.launchOrFocus("Simplenote")
end)

hs.hotkey.bind(smash, "Y", function()
  hs.application.launchOrFocus("Caprine")
end)

hs.hotkey.bind(smash, "T", function()
  hs.application.launchOrFocus("Messages")
end)

-- hints for shortcuts assigned
--[[ hs.hotkey.bind({"cmd", "alt", "ctrl"}, ";", function()
  hs.hotkey.showHotkeys()
end) --]]


-- use information about changing Wifi networks
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()


-- Make sure we have the right location settings
if hs.wifi.currentNetwork() == homeSSID then
    home_arrived()
else
    home_departed()
end
