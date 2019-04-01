
local _M = class(ViewBase)

function _M:OnCreate()
    print("BattleArrView oncreate  ~~~~~~~")
    self.posItemCache = {}

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.posListBlock = self:InitPosListBlock(self.transform, "posList")
    self.heroBlock = self:InitHeroBlock(self.transform, "hero")

    self:InitData()
end

function _M:InitData()
    self.iCtrl:AllOwnHeros(function (heros)
        local selectHeros = {}
        for i,hero in pairs(heros) do
            if hero.Pos > 0 then
                table.insert(selectHeros, hero)
            end
        end

        self:UpdatePosList(selectHeros)
        if #self.posItemCache == 0 then
            self:UpdateHero(nil, 1)
        else
            self:SelectPos(1)
        end
    end)
end

function _M:InitPosListBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.posItem = transform:Find("item").gameObject
    block.posList = transform:GetComponent("ScrollRect")

    for i=1,5,1 do
        local posItem = {}

        local posObj = newObject(block.posItem)
        posObj.transform:SetParent(block.posList.content, false)
        posObj.transform.localScale = Vector3(1,1,1)
        posObj:SetActive(true)

        posItem.nameText = posObj.transform:Find("head/label"):GetComponent("Text")
        posItem.selectObj = posObj.transform:Find("select").gameObject
        posItem.selectObj:SetActive(false)

        posObj:SetOnClick(function ()
            self:SelectPos(i)
        end)

        table.insert(self.posItemCache, posItem)
    end

    return block
end

function _M:InitHeroBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.roleObj = transform:Find("role").gameObject
    block.roleImage = transform:Find("role"):GetComponent("Image")
    block.roleTipObj = transform:Find("role/label").gameObject
    block.nameText = transform:Find("name"):GetComponent("Text")
    block.levelText = transform:Find("level"):GetComponent("Text")
    block.powerText = transform:Find("power"):GetComponent("Text")
    block.attr = self:InitAttrBlock(transform, "extend/bg/attr")
    block.skill = self:InitSkillBlock(transform, "extend/bg/skill")
    block.equip = self:InitEquipBlock(transform, "equip")

    return block
end

function _M:InitAttrBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.hpText = transform:Find("hp/label"):GetComponent("Text")
    block.mpText = transform:Find("mp/label"):GetComponent("Text")
    block.attackText = transform:Find("attack/label"):GetComponent("Text")
    block.armorText = transform:Find("armor/label"):GetComponent("Text")
    block.strengthText = transform:Find("strength/label"):GetComponent("Text")
    block.agilityText = transform:Find("agility/label"):GetComponent("Text")
    block.intelligentText = transform:Find("intelligent/label"):GetComponent("Text")

    return block
end

function _M:InitSkillBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.skills = {}
    for i=1,4,1 do
        block.skills[i] = self:InitOneSkillBlock(transform, i)
    end

    return block
end

function _M:InitOneSkillBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.nameText = transform:Find("bg/image/label"):GetComponent("Text")
    
    return block
end

function _M:InitEquipBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.equips = {}
    for i=1,6,1 do
        block.equips[i] = self:InitOneEquipBlock(transform, i)
    end

    return block
end

function _M:InitOneEquipBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.gameObject = transform.gameObject

    block.nameText = transform:Find("bg/image/label"):GetComponent("Text")
    
    return block
end

function _M:UpdatePosList(heros)
    if heros then
        table.sort(heros, function (a, b)
            return a.Pos < b.Pos
        end)

        for i,hero in pairs(heros) do
            local posItem = self.posItemCache[hero.Pos]
            posItem.data = hero
            posItem.nameText.text = hero.Name
        end
    end
end

function _M:UpdateHero(hero, pos)
    if hero then
        self.heroBlock.nameText.text = hero.Name
        self.heroBlock.levelText.text = "等级 " .. hero.Level
        self.heroBlock.powerText.text = "战力 " .. 0
        self.heroBlock.attr.hpText.text = hero.MaxBlood
        self.heroBlock.attr.mpText.text = hero.MaxMP
        self.heroBlock.attr.attackText.text = hero.AttackMin / 100 .. "~" .. hero.AttackMax / 100
        self.heroBlock.attr.armorText.text = hero.Armor / 100
        self.heroBlock.attr.strengthText.text = hero.Strength / 100 .. "(+" .. hero.StrengthStep / 100 .. ")"
        self.heroBlock.attr.agilityText.text = hero.Agility / 100 .. "(+" .. hero.AgilityStep / 100 .. ")"
        self.heroBlock.attr.intelligentText.text = hero.Intelligence / 100 .. "(+" .. hero.IntelligenceStep / 100 .. ")"

        self.iCtrl:HeroSkills(hero.HeroId, function (skills)
            if skills then
                for i, sk in pairs(skills) do
                    print(skillStr(sk))
                    local skillBlock = self.heroBlock.skill.skills[i]
                    skillBlock.nameText.text = sk.Name
                    skillBlock.gameObject:SetOnClick(function ()
                        self:ShowSkill(sk, hero)
                    end)
                end
            end
        end)

        for i,equipBlock in pairs(self.heroBlock.equip.equips) do
            equipBlock.gameObject:SetOnClick(function ()
                self:ShowEquip(equipBlock.data)
            end)
        end

        self.heroBlock.roleTipObj:SetActive(false)
        self.heroBlock.roleObj:SetOnClick(function ()
            
        end)
    else
        self.heroBlock.roleTipObj:SetActive(true)
        self.heroBlock.roleObj:SetOnClick(function ()
            self.iCtrl:ShowHeroSelect(pos, function ()
                self:InitData()
                self:SelectPos(pos)
            end)
        end)
    end
end

function _M:SelectPos(pos)
    print("select Pos " .. pos)
    for i, posItem in pairs(self.posItemCache) do
        if i == pos then
            posItem.selectObj:SetActive(true)
            self:UpdateHero(posItem.data, pos)
        else
            posItem.selectObj:SetActive(false)
        end
    end
end

function _M:ShowEquip(equip)
    self.iCtrl:ShowEquip(equip)
end

function _M:ShowSkill(skill, hero)
    self.iCtrl:ShowSkill(skill, hero)
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M