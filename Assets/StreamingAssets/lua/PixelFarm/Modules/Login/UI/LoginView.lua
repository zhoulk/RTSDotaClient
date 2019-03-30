
local _LoginView = class(ViewBase)

function _LoginView:OnCreate()
    print("_LoginView oncreate  ~~~~~~~")

    self.zoneBlock = self:InitZoneBlock(self.transform, "zone")
    self.zoneListBlock = self:InitZoneListBlock(self.transform, "zoneList")
    self.loginBlock = self:InitLoginBlock(self.transform, "login")
    self.exchangeBtn = self.transform:Find("exchange").gameObject
    self.exchangeBtn:SetOnClick(function ()
        self:OnExchangeBtnClick()
    end)
    self.enterBtn = self.transform:Find("enter").gameObject
    self.enterBtn:SetOnClick(function ()
        self:OnEnterBtnClick()
    end)

    self.iCtrl:AllZones(function (zones)
        self:InitZones(zones)
    end)

    self.player = self.iCtrl:CurrentUser()
    if self.player and #self.player.UserId > 0 then
        self.enterBtn:SetActive(true)
    else
        self.enterBtn:SetActive(false)
    end
end

function _LoginView:InitZones(zones)
    if zones and #zones > 0 then
        local zone = zones[#zones]
        self.zoneBlock.serverText.text = zone.Name
        self.zoneBlock.newFlagObj:SetActive(zone.IsNew)
        self.zoneBlock.hotFlagObj:SetActive(not zone.IsNew)

        local sortedZones = reverseTable(zones)
        for i,zone in pairs(sortedZones) do
            local zoneObj = newObject(self.zoneListBlock.zoneItem)
            zoneObj.transform:SetParent(self.zoneListBlock.allZoneList.content, false)
            zoneObj.transform.localScale = Vector3(1,1,1)
            zoneObj:SetActive(true)

            zoneObj.transform:Find("label"):GetComponent("Text").text = zone.Name
            zoneObj.transform:Find("newFlag").gameObject:SetActive(zone.IsNew)
            zoneObj.transform:Find("hotFlag").gameObject:SetActive(not zone.IsNew)
        end
    end
end

function _LoginView:InitZoneBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.gameObject = transform.gameObject
    block.serverText = transform:Find("label"):GetComponent("Text")
    block.newFlagObj = transform:Find("newFlag").gameObject
    block.hotFlagObj = transform:Find("hotFlag").gameObject

    block.gameObject:SetOnClick(function ()
        self:OnAllZoneClick()
    end)

    return block
end

function _LoginView:InitZoneListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.gameObject = transform.gameObject
    block.recentZoneList = transform:Find("recentZone"):GetComponent("ScrollRect")
    block.zoneItem = transform:Find("item").gameObject
    block.allZoneList = transform:Find("allZone"):GetComponent("ScrollRect")

    block.closeBtn = transform:Find("closeBtn").gameObject
    block.closeBtn:SetOnClick(function ()
        block.gameObject:SetActive(false)
    end)

    return block
end

function  _LoginView:InitLoginBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.login = {}
    block.login.gameObject = transform:Find("login").gameObject
    block.login.accountInput = transform:Find("login/part1/input"):GetComponent("InputField")
    block.login.passwordInput = transform:Find("login/part2/input"):GetComponent("InputField")

    block.login.fastLoginBtn = transform:Find("login/btns/fastLoginBtn").gameObject
    block.login.loginBtn = transform:Find("login/btns/loginBtn").gameObject
    block.login.wxBtn = transform:Find("login/btns/weChatBtn").gameObject
    block.login.registeBtn = transform:Find("login/btns/registeBtn").gameObject

    block.registe = {}
    block.registe.gameObject = transform:Find("registe").gameObject
    block.registe.accountInput = transform:Find("registe/part1/input"):GetComponent("InputField")
    block.registe.passwordInput = transform:Find("registe/part2/input"):GetComponent("InputField")
    block.registe.secondPasswordInput = transform:Find("registe/part3/input"):GetComponent("InputField")

    block.registe.tipsText = transform:Find("registe/tips"):GetComponent("Text")

    block.registe.closeBtn = transform:Find("registe/closeBtn").gameObject
    block.registe.enterBtn = transform:Find("registe/enterBtn").gameObject

    block.login.loginBtn:SetOnClick(function ()
        self:OnLoginBtnClick()
    end)
    block.login.fastLoginBtn:SetOnClick(function ()

    end)
    block.login.wxBtn:SetOnClick(function ()

    end)
    block.login.registeBtn:SetOnClick(function ()
        block.login.gameObject:SetActive(false)

        block.registe.tipsText.gameObject:SetActive(false)
        block.registe.accountInput.text = ""
        block.registe.passwordInput.text = ""
        block.registe.secondPasswordInput.text = ""
        block.registe.gameObject:SetActive(true)
    end)
    block.registe.closeBtn:SetOnClick(function ()
        block.login.gameObject:SetActive(true)
        block.registe.gameObject:SetActive(false)
    end)
    block.registe.enterBtn:SetOnClick(function ()
        self:OnRegisterEnterClick()
    end)
    
    return block
end

function _LoginView:OnExchangeBtnClick()
    print("OnExchangeBtnClick ~~~~~")
    self.loginBlock.login.gameObject:SetActive(true)
    self.loginBlock.registe.gameObject:SetActive(false)
    self.loginBlock.gameObject:SetActive(true)
end

function _LoginView:OnEnterBtnClick()
    print("OnEnterBtnClick ~~~~~")
    self.iCtrl:Login(self.player.UserId, "")
end

function _LoginView:OnAllZoneClick()
    print("OnAllZoneClick ~~~~~")
    self.zoneListBlock.gameObject:SetActive(true)
end

function _LoginView:OnLoginBtnClick()
    print("OnLoginBtnClick ~~~~~")
    local accout = self.loginBlock.login.accountInput.text
    local password = self.loginBlock.login.passwordInput.text
    self.iCtrl:Login(accout, password)
end

function _LoginView:OnRegisterEnterClick()
    print("OnRegisterEnterClick ~~~~~")
    local accout = self.loginBlock.registe.accountInput.text
    local password = self.loginBlock.registe.passwordInput.text
    local secondPassword = self.loginBlock.registe.secondPasswordInput.text
    if password ~= secondPassword then
        self.loginBlock.registe.tipsText.gameObject:SetActive(true)
    else
        self.iCtrl:Registe(accout, password)
    end
end

function _LoginView:OnDestroy()
    
end

return _LoginView