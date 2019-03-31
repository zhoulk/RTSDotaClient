
local _M = class(ViewBase)

function _M:OnCreate()
    print("HeroSelectView oncreate  ~~~~~~~")
    
    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M