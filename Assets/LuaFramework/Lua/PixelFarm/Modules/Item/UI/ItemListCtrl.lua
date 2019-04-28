
local _M = class(CtrlBase)

function _M:StartView()
    print("ItemListCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Item, ItemViewNames.ItemList, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(ItemCtrlNames.ItemList)
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
end

return _M