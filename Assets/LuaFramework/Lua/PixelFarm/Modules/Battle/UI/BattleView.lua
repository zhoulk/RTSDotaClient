local _M = class(ViewBase)

function _M:OnCreate()
    print("BattleView oncreate  ~~~~~~~")

    self.pauseBlock = self:InitPauseBlock(self.transform, "pauseView")

    self.pauseBtn = self.transform:Find("pauseBtn").gameObject
    self.pauseBtn:SetOnClick(function ()
        self:OnPauseClick()
    end)

end

function _M()
    
end

function _M:OnPauseClick()
    
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M