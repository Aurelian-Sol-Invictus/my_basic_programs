-- I wanted a better version of the shift + o command for mpv
-- Mainly for the purpose of using with ffmpeg to get exact times/frames

local mp = require 'mp'

-- If you want the script to always start with mpv change to true
local enabled = false

local function format_time(t)
	if not t then return "00:00:00.000" end
	local h = math.floor(t / 3600) 
	local m = math.floor((t % 3600) / 60)
	local s = t % 60
	return string.format("%02d:%02d:%06.3f", h, m, s)
end

local function update_osd()
	if not enabled then return end

	local time = mp.get_property_number("time-pos")
	local duration = mp.get_property_number("duration")
	local percent = mp.get_property_number("percent-pos")
	local frame = mp.get_property_number("estimated-frame-number")

	local text = string.format(

-- This is the actual text that appears which you can edit to your liking
		"Time: %s / %s (%.2f%%)\nFrame: %d",

		format_time(time),
		format_time(duration),
		percent or 0,
		frame or 0
	)

	mp.osd_message(text, 0.1)
end

-- edit 0.1 if you want the display of the numbers to occur faster or slower
mp.add_periodic_timer(0.1, update_osd)

-- Here you can change the key binding for the script
-- default for script is set to "O" to replace mpv's default
-- "better-O" is the name of the keybinding for mpv to recognize it as
mp.add_key_binding("O", "better-O",
	function()
		enabled = not enabled
		if not enabled then
			mp.osd_message("")
		end
	end
)
