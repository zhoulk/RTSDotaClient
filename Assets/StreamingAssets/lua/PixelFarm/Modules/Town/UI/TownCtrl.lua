
local _M = class(CtrlBase)

function _M:StartView()
    print("TownCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Town, TownViewNames.Town, PANEL_LOW(), self.args)
end

-- 显示仓库
function _M:ShowStorage()
    CtrlManager:OpenCtrl(MoudleNames.Storage, StorageCtrlNames.Storage)
end

return _M