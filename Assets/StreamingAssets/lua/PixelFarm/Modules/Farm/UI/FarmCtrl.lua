local FarmLogic = require "PixelFarm.Modules.Farm.Logic.FarmLogic"
local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"
local ConfigInterface = require "PixelFarm.Modules.Config.Interface.ConfigInterface"

local _M = class(CtrlBase)

function _M:StartView()
    print("FarmCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Farm, FarmViewNames.Farm, PANEL_LOW(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(FarmCtrlNames.Farm)
end

function _M:GetLandList()
    return  FarmLogic:GetLandList()
end

function _M:GetPlantList()
    return FarmLogic:GetPlantList()
end

function _M:GetToolList()
    return FarmLogic:GetToolList()
end

function _M:GetTotalLand()
    return ConfigInterface:MaxFarmLand()
end

function _M:CheckCoin(coin)
    return PlayerInterface:CheckCoin(coin)
end

function _M:OperComplete(plant, grow, gain)
    FarmLogic:OperComplete(plant, grow, gain)
end

return _M