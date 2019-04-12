local Player = require "PixelFarm.Modules.Data.Entry.Player"
local Hero = require "PixelFarm.Modules.Data.Entry.Hero"
local Skill = require "PixelFarm.Modules.Data.Entry.Skill"
local Chapter = require "PixelFarm.Modules.Data.Entry.Chapter"
local GuanKa = require "PixelFarm.Modules.Data.Entry.GuanKa"
local Group = require "PixelFarm.Modules.Data.Entry.Group"

local HeroLogic = require "PixelFarm.Modules.Logic.HeroLogic"
local MapLogic = require "PixelFarm.Modules.Logic.MapLogic"
local GroupLogic = require "PixelFarm.Modules.Logic.GroupLogic"

local _StoreLogic = class()

function _StoreLogic:UpdateUid(uid)
    local player = self:CurrentPlayer()
    player.UserId = uid
    self:SavePlayer(player)
end

function _StoreLogic:CurrentPlayer()
    local player = self:LoadPlayer()
    if player == nil then
        player = Player.new()
        player:Init()
        self:SavePlayer(player)
    end
    return player
end

function _StoreLogic:AllHeros(cb)
    local heros = self:LoadHeros()
    if heros == nil or #heros == 0 then
        HeroLogic:AllHero(function(succeed, err, heros)
            if succeed then
                local _heros = {}
                if heros then
                    for i,hero in pairs(heros) do
                        local h = Hero.new()
                        h:Init(hero)
                        table.insert(_heros, h)
                    end
                end
                self:SaveHeros(_heros)
                if cb then
                    cb(_heros)
                end
            end
        end)
    else
        if cb then
            cb(heros)
        end
    end
end

function _StoreLogic:AllOwnHeros(userId, cb, force)
    local heros = self:LoadOwnHeros(userId)
    if force or heros == nil or #heros == 0 then
        HeroLogic:AllOwnHero(function(succeed, err, heros)
            if succeed then
                local _heros = {}
                if heros then
                    for i,hero in pairs(heros) do
                        local h = Hero.new()
                        h:Init(hero)
                        table.insert(_heros, h)
                    end
                end
                self:SaveOwnHeros(userId, _heros)
                if cb then
                    cb(_heros)
                end
            end
        end)
    else
        if cb then
            cb(heros)
        end
    end
end

function _StoreLogic:AllChapters(userId, cb, force)
    local chapters = self:LoadChapters(userId)
    if force or chapters == nil or #chapters == 0 then
        MapLogic:AllChapter(function(succeed, err, chapters)
            if succeed then
                local _chapters = {}
                if chapters then
                    for i,chapter in pairs(chapters) do
                        local c = Chapter.new()
                        c:Init(chapter)
                        table.insert(_chapters, c)
                    end
                end
                self:SaveChapters(userId, _chapters)
                if cb then
                    cb(_chapters)
                end
            end
        end)
    else
        if cb then
            cb(chapters)
        end
    end
end

function _StoreLogic:AllGuanKas(chapterId, cb, force)
    local guanKas = self:LoadGuanKas(chapterId)
    if force or guanKas == nil or #guanKas == 0 then
        MapLogic:AllGuanKa(function(succeed, err, guanKas)
            if succeed then
                local _guanKas = {}
                if guanKas then
                    for i,gk in pairs(guanKas) do
                        local c = GuanKa.new()
                        c:Init(gk)
                        table.insert(_guanKas, c)
                    end
                end
                self:SaveGuanKas(chapterId, _guanKas)
                if cb then
                    cb(_guanKas)
                end
            end
        end)
    else
        if cb then
            cb(guanKas)
        end
    end
end

function _StoreLogic:HeroSkills(heroId, cb, force)
    local skills = self:LoadHeroSkills(heroId)
    if force or skills == nil or #skills == 0 then
        HeroLogic:HeroSkills(heroId, function(succeed, err, skills)
            if succeed then
                local _skills = {}
                if skills then
                    for i,skill in pairs(skills) do
                        local s = Skill.new()
                        s:Init(skill)
                        table.insert(_skills, s)
                    end
                end
                self:SaveHeroSkills(heroId, _skills)
                if cb then
                    cb(_skills)
                end
            end
        end)
    else
        if cb then
            cb(skills)
        end
    end
end

function _StoreLogic:OwnGroup(userId, cb, force)
    local group = self:LoadOwnGroup(userId)
    if force or group == nil then
        GroupLogic:GroupOwn(function(succeed, err, gp)
            print(gp)
            if succeed then
                local _group = nil
                if gp then
                    _group = Group.new()
                    _group:Init(gp)
                    self:SaveOwnGroup(userId, _group)
                end
                if cb then
                    cb(_group)
                end
            end
        end)
    else
        if cb then
            cb(group)
        end
    end
end

function _StoreLogic:SavePlayer(player)
    LocalDataManager:Save("local_Player", player)
end
function _StoreLogic:LoadPlayer()
    local key = "local_Player"
    local playerTab = LocalDataManager:Load(key)
    local player = Player.new()
    player:Init(playerTab)
    return player
end

function _StoreLogic:SaveHeros(heros)
    LocalDataManager:Save("local_Heros", heros)
end
function _StoreLogic:LoadHeros()
    local key = "local_Heros"
    local herosTab = LocalDataManager:Load(key)
    local _heros = {}
    if herosTab then
        for i,hero in pairs(herosTab) do
            local _h = Hero.new()
            _h:Init(hero)
            table.insert(_heros, _h)
        end
    end
    return _heros
end

function _StoreLogic:SaveOwnHeros(userId, heros)
    LocalDataManager:Save("local_OwnHeros_" .. userId, heros)
end
function _StoreLogic:LoadOwnHeros(userId)
    local key = "local_OwnHeros_" .. userId
    local herosTab = LocalDataManager:Load(key)
    local _heros = {}
    if herosTab then
        for i,hero in pairs(herosTab) do
            local _h = Hero.new()
            _h:Init(hero)
            table.insert(_heros, _h)
        end
    end
    return _heros
end

function _StoreLogic:SaveHeroSkills(heroId, skills)
    LocalDataManager:Save("local_HeroSkills_" .. heroId, skills)
end
function _StoreLogic:LoadHeroSkills(heroId)
    local key = "local_HeroSkills_" .. heroId
    local skillsTab = LocalDataManager:Load(key)
    local _skills = {}
    if skillsTab then
        for i,skill in pairs(skillsTab) do
            local _s = Skill.new()
            _s:Init(skill)
            table.insert(_skills, _s)
        end
    end
    return _skills
end

function _StoreLogic:SaveChapters(userId, chapters)
    LocalDataManager:Save("local_Chapters_" .. userId, chapters)
end
function _StoreLogic:LoadChapters(userId)
    local key = "local_Chapters_" .. userId
    local chaptersTab = LocalDataManager:Load(key)
    local _chapters = {}
    if chaptersTab then
        for i,chapter in pairs(chaptersTab) do
            local _s = Chapter.new()
            _s:Init(chapter)
            table.insert(_chapters, _s)
        end
    end
    return _chapters
end

function _StoreLogic:SaveGuanKas(chapterId, guanKas)
    LocalDataManager:Save("local_GuanKas_" .. chapterId, guanKas)
end
function _StoreLogic:LoadGuanKas(chapterId)
    local key = "local_GuanKas_" .. chapterId
    local guanKasTab = LocalDataManager:Load(key)
    local _guanKas = {}
    if guanKasTab then
        for i,gk in pairs(guanKasTab) do
            local _s = GuanKa.new()
            _s:Init(gk)
            table.insert(_guanKas, _s)
        end
    end
    return _guanKas
end

function _StoreLogic:SaveOwnGroup(userId, group)
    LocalDataManager:Save("local_OwnGroup_" .. userId, group)
end

function _StoreLogic:LoadOwnGroup(userId)
    local key = "local_OwnGroup_" .. userId
    local groupTab = LocalDataManager:Load(key)
    local _group = nil
    if groupTab then
        print(tabStr(groupTab))
        _group = Group.new()
        _group:Init(groupTab)
    end
    return _group
end

return _StoreLogic