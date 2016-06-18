--[[
#######===========================#######
####### my OSX Hammerspoon config #######
####### controls hot keys for OSX #######
#######===========================#######
--]]

-- Toggle an application between being frontmost app and hidden
function toggle_application(_app)
    local app = hs.appfinder.appFromName(_app)
    if not app then
        -- FIXME: This should really launch _app
        return
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
            informativeText='unmuted volume'
        }):send()
end


-- Perform tasks to configure the system for any WiFi network other than my home
function home_departed()
    hs.audiodevice.defaultOutputDevice():setVolume(0)
    hs.notify.new({
          title='Hammerspoon',
            informativeText='muted volume'
        }):send()
end


-- variables for hotkey smash
local smash = {"cmd", "alt", "ctrl"}
local altsmash = {"cmd", "alt", "shift"}

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

-- multi-window layout for communication/entertainment productivity
--[[ local laptopScreen = "Color LCD"
    local windowLayout = {
        {"Spotify", nil, laptopScreen, hs.layout.left50, nil, nil},
        {"Kiwi for Gmail", nil, laptopScreen, hs.layout.right50, nil, nil},
        {"Messages", nil, laptopScreen, hs.layout.maximized, nil, nil},
        {"Messenger", nil, laptopScreen, nil, nil, hs.geometry.rect(0, -48, 400, 48)},
    }
    hs.layout.apply(windowLayout) --]]

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
    if state then
        caffeine:setTitle("AWAKE!")
    else
        caffeine:setTitle("SLEEPY")
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
local homeSSID = "Knock_On_101" --NEEDS UPDATING
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


-- controlling Spotify (iTunes has dedicated buttons on Mac)
hs.hotkey.bind(altsmash, "2", function() hs.spotify.play() end)

hs.hotkey.bind(altsmash, "`", function() hs.spotify.pause() end)

hs.hotkey.bind(altsmash, "3", function() hs.spotify.next() end)

hs.hotkey.bind(altsmash, "1", function() hs.spotify.previous() end)

hs.hotkey.bind(altsmash, "4", function() hs.spotify.displayCurrentTrack() end)

-- launch shortcuts for useful applications
-- NOTE {"cmd", "alt", "ctrl"}, '4' reserved for dash global key

hs.hotkey.bind(smash, "-", function() hs.application.launchOrFocus("iTerm") end)

-- use toggle_applications for Atom, since it behaves kinda weird
hs.hotkey.bind(smash, "=", function() toggle_application("Atom") end)

hs.hotkey.bind(smash, "[", function()
  hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(smash, "]", function()
  hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind(smash, "M", function()
  hs.application.launchOrFocus("Kiwi for Gmail")
end)

hs.hotkey.bind(smash, "P", function()
  hs.application.launchOrFocus("Preview")
end)

hs.hotkey.bind(smash, "V", function()
  hs.application.launchOrFocus("MacVim")
end)

hs.hotkey.bind(smash, "R", function()
  hs.application.launchOrFocus("RStudio")
end)

hs.hotkey.bind(smash, "S", function()
  hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind(smash, "F", function()
  hs.application.launchOrFocus("Messenger")
end)

hs.hotkey.bind(smash, "T", function()
  hs.application.launchOrFocus("Messages")
end)

-- hints for shortcuts assigned
--[[ hs.hotkey.bind({"cmd", "alt", "ctrl"}, ";", function()
  hs.hotkey.showHotkeys()
end) --]]


-- use information about changing Wifi networks
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback())
wifiWatcher:start()


-- Make sure we have the right location settings
if hs.wifi.currentNetwork() == homeSSID then
    home_arrived()
else
    home_departed()
end
