local _M = class(CtrlBase)

function _M:StartView()
    print("HeroSelectCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Hero, HeroViewNames.HeroSelect, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(HeroCtrlNames.HeroSelect)
end

return _M