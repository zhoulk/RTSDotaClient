
local _M = class(ViewBase)

function _M:OnCreate()
    print("_MainView oncreate  ~~~~~~~")

    self.ctrlBtn = self.transform:Find("ctrlBtn").gameObject
    self.ctrlBtnText = self.transform:Find("ctrlBtn/text"):GetComponent("Text")
    self.ctrlBtn:SetOnClick(function ()
        self:OnCtrlClick()
    end)
    self.townCenterBtn = self.transform:Find("townCenterBtn").gameObject
    self.townCenterBtn:SetOnClick(function ()
        self:OnTownCenterClick()
    end)

    self.ctrlBlock = self:InitCtrlBlock(self.transform, "ctrlGroup")
    self.playerBlock = self:InitPlayerBlock(self.transform, "LT")
    self.coinBlock = self:InitCoinBlock(self.transform, "RT")

    self:InitData()

    self.iCtrl:ShowTownCenter()
end

function _M:InitData()
    local player = self.iCtrl:CurrentPlayer()

    print(tabStr(player))
    self.playerBlock.lvText.text = player.level
    self:UpdateExpUI(player)
    self:UpdatePeopleUI(player)
    self:UpdateCoinUI(player)
end

function _M:InitPlayerBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.headImage = transform:Find("head"):GetComponent("Image")
    block.lvText = transform:Find("head/lv/text"):GetComponent("Text")
    block.expBgRect = transform:Find("exp"):GetComponent("RectTransform")
    block.expFontRect = transform:Find("exp/font"):GetComponent("RectTransform")
    block.peopleBgRect = transform:Find("people"):GetComponent("RectTransform")
    block.peopleFontRect = transform:Find("people/font"):GetComponent("RectTransform")
    block.peoplePercentText = transform:Find("people/percent"):GetComponent("Text")
    return block
end

function _M:InitCoinBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.coinText = transform:Find("coin/text"):GetComponent("Text")
    block.lvChaoText = transform:Find("lvChao/text"):GetComponent("Text")
    block.diamondText = transform:Find("diamond/text"):GetComponent("Text")
    return block
end

function _M:InitCtrlBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.buildingBtn = transform:Find("buildingBtn").gameObject
    block.farmBtn = transform:Find("farmBtn").gameObject
    block.factoryBtn = transform:Find("factoryBtn").gameObject
    block.techBtn = transform:Find("techBtn").gameObject
    block.jettyBtn = transform:Find("jettyBtn").gameObject
    block.mineBtn = transform:Find("mineBtn").gameObject
    block.zooBtn = transform:Find("zooBtn").gameObject
    block.airportBtn = transform:Find("airportBtn").gameObject
    block.trainBtn = transform:Find("trainBtn").gameObject

    block.buildingBtn:SetOnClick(function ()
        self:OnBuildingClick()
        self.ctrlBlock.transform.gameObject:SetActive(false)
    end)

    block.farmBtn:SetOnClick(function ()
        self:OnFarmClick()
        self.ctrlBlock.transform.gameObject:SetActive(false)
    end)

    block.factoryBtn:SetOnClick(function ()
        self:OnFactoryClick()
    end)

    block.techBtn:SetOnClick(function ()
        self:OnTechClick()
    end)

    block.jettyBtn:SetOnClick(function ()
        self:OnJettyClick()
    end)

    block.mineBtn:SetOnClick(function ()
        self:OnMineClick()
    end)

    block.zooBtn:SetOnClick(function ()
        self:OnZooClick()
    end)

    block.airportBtn:SetOnClick(function ()
        self:OnAirportClick()
    end)

    block.trainBtn:SetOnClick(function ()
        self:OnTrainClick()
    end)

    return block
end

function _M:OnCtrlClick()
    self.ctrlBlock.transform.gameObject:SetActive(not self.ctrlBlock.transform.gameObject.activeSelf)
    if self.ctrlBlock.transform.gameObject.activeSelf then
        self.ctrlBtnText.text = "《"
    else
        self.ctrlBtnText.text = "》"
    end
end

function _M:OnTownCenterClick()
    self.iCtrl:ShowTownCenter()
    self.townCenterBtn:SetActive(false)
end

function _M:OnBuildingClick()
    self.iCtrl:ShowBuilding()
end

function _M:OnFarmClick()
    self.iCtrl:ShowFarm()
    self.townCenterBtn:SetActive(true)
end

function _M:OnFactoryClick()
    self.iCtrl:ShowFactory()
end

function _M:OnTechClick()
    self.iCtrl:ShowTech()
end

function _M:OnJettyClick()
    self.iCtrl:ShowJetty()
end

function _M:OnMineClick()
    self.iCtrl:ShowMine()
end

function _M:OnZooClick()
    self.iCtrl:ShowZoo()
end

function _M:OnAirportClick()
    self.iCtrl:ShowAirport()
end

function _M:OnTrainClick()
    self.iCtrl:ShowTrain()
end

function _M:UpdateExpUI(player)
    local levelUpExp = player.levelUpExp
    if levelUpExp == 0 then
        levelUpExp = 1
    end
    local expPercent = player.exp / levelUpExp
    local expBgSize = self.playerBlock.expBgRect.sizeDelta
    self.playerBlock.expFontRect.offsetMax = Vector2(-expBgSize.x * (1 - expPercent), 0)
end

function _M:UpdatePeopleUI(player)
    local maxPeople = player.maxPeople
    if maxPeople == 0 then
        maxPeople = 1
    end
    local peoplePercent = player.people / maxPeople
    local expBgSize = self.playerBlock.peopleBgRect.sizeDelta
    self.playerBlock.peopleFontRect.offsetMax = Vector2(-expBgSize.x * (1 - peoplePercent), 0)
    self.playerBlock.peoplePercentText.text = player.people .. "/" .. maxPeople
end

function _M:UpdateCoinUI(player)
    self.coinBlock.coinText.text = player.coin
    self.coinBlock.lvChaoText.text = player.lvChao
    self.coinBlock.diamondText.text = player.baoShi
end

function _M:OnDestroy()
    
end

return _M