--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "eventlib"

local Event = {}
local events = {}

function Event.AddListener(event,handler)
	if type(event) == "number" then
		event = tostring(event)
	end
	if not event or type(event) ~= "string" then
		print("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		print("handler parameter in addlistener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		--create the Event with name
		events[event] = EventLib:new(event)
	end

	--conn this handler
	events[event]:connect(handler)
end

function Event.Brocast(event,...)

	if type(event) == "number" then
		event = tostring(event)
	end
	if not event or type(event) ~= "string" then
		print("event parameter in addlistener function has to be string, " .. type(event) .. " not right.")
	end

	if not events[event] then
		print("brocast " .. event .. " has no event.")
	else
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if type(event) == "number" then
		event = tostring(event)
	end
	if not event or type(event) ~= "string" then
		print("event parameter in RemoveListener function has to be string, " .. type(event) .. " not right.")
	end
	if not handler or type(handler) ~= "function" then
		print("handler parameter in RemoveListener function has to be function, " .. type(handler) .. " not right")
	end

	if not events[event] then
		print("remove " .. event .. " has no event.")
	else
		events[event]:Disconnect(handler)
	end
end

return Event