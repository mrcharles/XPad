XPad: The input helper library for Love2d
====================

XPad is a helper library for Love2D that provides a more useful set of input functions via a class `Pad` which is representative of a single controller. This also helps facilitate easy multiple-controller play schemes. Xpad also supports controller remapping, and button abstraction so you can refer to buttons either by their proper Xbox control pad representations ('a', 'x', 'lb', etc), or labels you provide yourself ('jump', 'action', 'use'). 

It also features preliminary support for controller normalization across [XInputLUA](https://github.com/mrcharles/XInputLUA) and the normal love.joystick module for Xbox 360 controllers (as much as is possible). Beyond that, it will eventually support button normalization assuming that `love.joystick.getName(i)` returns a unique string representing the controller which can be used to pick the input configuration.

You can see my [xbox 360 controller test app](https://github.com/mrcharles/love2d-x360-test) for examples. 

Usage
---------

### Xpad

`xpad = require('XPad')`

`xpad:init(inputmodule)`

Initialize the XPad library with the input module to use. I recommend using XInputLUA if you are on windows and using an xbox 360 controller.

`xpad:setButtonConfig(config)`

config: table with key/value pairs representing alias/button. ex: `{ action = "a" }`

Call this if you would like to use a controller mapping with XPad. 

`xpad:newplayer()`

returns: a Pad which represents the first found controller.

`xpad:getpad(number)`

number: player number

`xpad:update()`

You must call this at the beginning of love.update() for Pads to work correctly. Also, if you are using XInputLUA, you must call it *after* XInputLUA's update function.

### Pad

`pad:new(index, mapping, aliases)`

Creates a new pad to refer to the given controller index. Do not use if you want XPad to handle things for you directly.

`pad:setAliases(aliases)`

Use this if you want to set a mapping manually for this single controller. 

`pad:getAxis(name)`

Get the value of the named axis.

`pad:pressed(name)`

Check if the named button is currently down.

`pad:justPressed(name)`

Check if the named button was just pressed this frame. 

`pad:justReleased(name)`

Check if the named button was just released this frame.

`pad:setRumble(pct)`

Sets the rumble motor percentage. 

`pad:setVibrate(pct)`

Sets the vibrate motor percentage.

`pad:update(dt)`

No need to call this manually unless you are creating your own pads. 

Setup
-------

Copy XInputLUA.dll next to your love.exe. 

NOTE: This project now relies on the XPad library, which you can get from [here](https://github.com/mrcharles/XPad). Please make sure this library is present when you run the project. 


Run
---

That's it! You can see your input react to the libs, and you can explore the differences between XInputLUA and Love.Joystick. 

Hitting spacebar will toggle between raw input labels ("a", "x", "leftx", etc), and a mapped subset of command aliases ("action", "jump", etc)
