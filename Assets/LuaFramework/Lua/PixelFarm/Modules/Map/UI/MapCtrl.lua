local MapLogic = require "PixelFarm.Modules.Map.Logic.MapLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("_MapCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Map, MapViewNames.Map, PANEL_LOW(), self.args)
end

function _M:LoadMap()
    return MapLogic:LoadMap()
end

return _M