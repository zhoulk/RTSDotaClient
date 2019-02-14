
local _M = class(ViewBase)

function _M:OnCreate()
    print("TownView oncreate  ~~~~~~~")

    self.townCenterBtn = self.transform:Find("content/Scroll View/Viewport/Content/part1/townCenter").gameObject
    self.storageBtn = self.transform:Find("content/Scroll View/Viewport/Content/part2/storage").gameObject
    self.luckyRoomBtn = self.transform:Find("content/Scroll View/Viewport/Content/part2/luckyRoom").gameObject
    self.marketBtn = self.transform:Find("content/Scroll View/Viewport/Content/part3/market").gameObject
    self.labRoomBtn = self.transform:Find("content/Scroll View/Viewport/Content/part3/labRoom").gameObject
    self.industryRoomBtn = self.transform:Find("content/Scroll View/Viewport/Content/part4/industryRoom").gameObject
    self.museumBtn = self.transform:Find("content/Scroll View/Viewport/Content/part4/museum").gameObject

    self.townCenterBtn:SetOnClick(function ()
        self:OnTownCenterClick()
    end)
    self.storageBtn:SetOnClick(function ()
        self:OnStorageClick()
    end)
    self.luckyRoomBtn:SetOnClick(function ()
        self:OnLuckyRoomClick()
    end)
    self.marketBtn:SetOnClick(function ()
        self:OnMarketClick()
    end)
    self.labRoomBtn:SetOnClick(function ()
        self:OnLabRoomClick()
    end)
    self.industryRoomBtn:SetOnClick(function ()
        self:OnIndustryRoomClick()
    end)
    self.museumBtn:SetOnClick(function ()
        self:OnMuseumClick()
    end)
end

function _M:OnTownCenterClick()
    
end

function _M:OnStorageClick()
    self.iCtrl:ShowStorage()
end

function _M:OnLuckyRoomClick()
    
end

function _M:OnMarketClick()
    
end

function _M:OnLabRoomClick()
    
end

function _M:OnIndustryRoomClick()
    
end

function _M:OnMuseumClick()
    
end

function _M:OnDestroy()
    
end

return _M