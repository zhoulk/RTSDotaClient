local StorageLogic = require "PixelFarm.Modules.Storage.Logic.StorageLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("StorageCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Storage, StorageViewNames.Storage, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(StorageCtrlNames.Storage)
end

function _M:GetGoodsList()
    return StorageLogic:GetGoodsList()
end

return _M