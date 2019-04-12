local _M = class(ViewBase)

function _M:OnCreate()
    print("GroupMemberView oncreate  ~~~~~~~")
    

    self.bgObj = self.transform:Find("bg").gameObject
    self.bgObj:SetOnClick(function ()
        self:OnBackClick()
    end)

    self:InitData()
end

function _M:InitData()
    
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M