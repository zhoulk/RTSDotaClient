local BuildingLogic = require "PixelFarm.Modules.Building.Logic.BuildingLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("BuildingCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Building, BuildingViewNames.Building, PANEL_MID(), self.args)
end

function _M:GetBuildings()
    return BuildingLogic:GetBuildings()
end

return _M