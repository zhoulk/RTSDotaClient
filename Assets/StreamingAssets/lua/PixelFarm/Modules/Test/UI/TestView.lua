local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"
local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"

local _M = class(ViewBase)

function _M:OnCreate()
    self.item = self.transform:Find("bg/btnList/item").gameObject
    self.btnList = self.transform:Find("bg/btnList/Viewport/Content").gameObject
    self.requestText = self.transform:Find("bg/request/Viewport/Content/text"):GetComponent("Text")
    self.responseText = self.transform:Find("bg/response/Viewport/Content/text"):GetComponent("Text")
    self.requestText.text = ""
    self.responseText.text = ""

    self.strs = {
        login = function() self:Login() end,
        registe = function() self:Registe() end,
        allHero = function() self:AllHero() end,
        randomHero = function() self:RandomHero() end,
        ownHero = function() self:OwnHero() end,
    }

    for k,v in pairs(self.strs) do
        local obj = newObject(self.item)
        obj.transform:SetParent(self.btnList.transform, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)

        obj.transform:Find("Text"):GetComponent("Text").text = k

        obj:GetComponent("Button").onClick:AddListener(function ()
            self:OnRequestClick(k)
        end)
    end

 
end

function _M:OnRequestClick(str)
    print("click  " .. str)
    self.strs[str]()
end

function _M:Login()
    _name = "zhoulk"
    _pwd = "123456"
    self.requestText.text = "name : " .. _name .. "\n" .. "pwd : " .. _pwd
    LoginLogic:Login(_name, _pwd, function (succeed, err)
        self.responseText.text = tostring(succeed) .. "\nerr : " .. tostring(err)
    end)
end

function _M:Registe()
    _name = "zhoulk"
    _pwd = "123456"
    self.requestText.text = "name : " .. _name .. "\n" .. "pwd : " .. _pwd
    LoginLogic:Registe(_name, _pwd, function (succeed, err)
        self.responseText.text = tostring(succeed) .. "\nerr : " .. tostring(err)
    end)
end

function _M:RandomHero()
    _level = "GOOD"
    self.requestText.text = "level : " .. _level .. "\n"
    HeroLogic:RandomHero(_level, function (succeed, err)
        local str = ""
        self.responseText.text = tostring(succeed) .. "\nerr : " .. self:ErrStr(err)
    end)
end

function _M:OwnHero()
    self.requestText.text = "null"
    HeroLogic:AllOwnHero(function (succeed, err, heros)
        local str = ""
        if heros then
            for i,hero in pairs(heros) do
                str = str .. "\n{Id : " .. hero.Id
                str = str .. ", Name : " .. hero.Name
                str = str .. ", Level : " .. hero.Level
                str = str .. ", Strength : " .. hero.Strength
                str = str .. ", Agility : " .. hero.Agility
                str = str .. ", Intelligence : " .. hero.Intelligence
                str = str .. ", Armor : " .. hero.Armor
                str = str .. ", Attack : " .. hero.Attack
                str = str .. ", Blood : " .. hero.Blood
                str = str .. "},"
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. tostring(err) .. "\nheros : " .. str
    end)
end

function _M:AllHero()
    self.requestText.text = "null"
    HeroLogic:AllHero(function (succeed, err, heros)
        local str = ""
        if heros then
            for i,hero in pairs(heros) do
                str = str .. "\n{Id : " .. hero.Id
                str = str .. ", Name : " .. hero.Name
                str = str .. ", Level : " .. hero.Level
                str = str .. ", Strength : " .. hero.Strength
                str = str .. ", Agility : " .. hero.Agility
                str = str .. ", Intelligence : " .. hero.Intelligence
                str = str .. ", Armor : " .. hero.Armor
                str = str .. ", Attack : " .. hero.Attack
                str = str .. ", Blood : " .. hero.Blood
                str = str .. "},"
            end
        end
        self.responseText.text = tostring(succeed) .. "\nerr : " .. tostring(err) .. "\nheros : " .. str
    end)
end

function _M:ErrStr(err)
    local str = ""
    if err then
        str = str .. "\n{ code = " .. err.code .. " , msg = " .. err.msg .. "}"
    end
    return str
end

function _M:OnDestroy()
    
end

return _M