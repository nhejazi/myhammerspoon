-- OSX config file (Hammerspoon + Lua); LAST UPDATED: JANUARY 3, 2016

-- simple "Hello World!" example
--[[ hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World!"}):send()
end) --]]

-- basic function for window movement (using NetHack key definitions)
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "K", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "U", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "B", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "N", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)

-- window tiling: splitting panes right/left for productivity
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
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

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
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
local homeSSID = "Blake House Blues" --may need updating
local lastSSID = hs.wifi.currentNetwork()

function ssidChangedCallback()
    newSSID = hs.wifi.currentNetwork()

    if newSSID == homeSSID and lastSSID ~= homeSSID then
        -- We just joined our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(25)
    elseif newSSID ~= homeSSID and lastSSID == homeSSID then
        -- We just departed our home WiFi network
        hs.audiodevice.defaultOutputDevice():setVolume(0)
    end

    lastSSID = newSSID
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()

-- controlling Spotify (add iTunes later on)
hs.hotkey.bind({"cmd", "alt", "shift"}, "1", function()
	hs.spotify.play()
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "`", function()
	hs.spotify.pause()
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "3", function()
	hs.spotify.next()
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "2", function()
	hs.spotify.previous()
end)

hs.hotkey.bind({"cmd", "alt", "shift"}, "4", function()
	hs.spotify.displayCurrentTrack()
end)

-- launch shortcuts for useful applications
-- NOTE {"cmd", "alt", "ctrl"}, '4' reserved for dash global key
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "0", function () 
	hs.application.launchOrFocus("iTerm") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "9", function () 
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "-", function () 
	hs.application.launchOrFocus("Atom") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "M", function () 
	hs.application.launchOrFocus("Kiwi for Gmail") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function () 
	hs.application.launchOrFocus("Preview") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "V", function () 
	hs.application.launchOrFocus("MacVim") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function () 
	hs.application.launchOrFocus("RStudio") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "S", function () 
	hs.application.launchOrFocus("Spotify") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "F", function () 
	hs.application.launchOrFocus("Messenger") 
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "T", function () 
	hs.application.launchOrFocus("Messages") 
end)

-- hints for shortcuts assigned
--[[ hs.hotkey.bind("ctrl", ";", function()
	hs.hotkey.showHotkeys()
end) --]]
