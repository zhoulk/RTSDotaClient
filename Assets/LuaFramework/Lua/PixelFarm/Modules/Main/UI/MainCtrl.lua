local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local LoginLogic = require "PixelFarm.Modules.Logic.LoginLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("_MainCtrl startView ~~~~~~~")
    ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_MID(), self.args)
end

function _M:CurrentPlayer(cb)
    local player = StoreLogic:CurrentPlayer()
    if cb then
        cb(player)
    end
end

function _M:ShowTavern()
    CtrlManager:OpenCtrl(MoudleNames.Tavern, TavernCtrlNames.Tavern)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowBattleArr()
    CtrlManager:OpenCtrl(MoudleNames.BattleArr, BattleArrCtrlNames.BattleArr)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowChallenge()
    CtrlManager:OpenCtrl(MoudleNames.Challenge, ChallengeCtrlNames.Challenge)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowChapter()
    CtrlManager:OpenCtrl(MoudleNames.Chapter, ChapterCtrlNames.Chapter)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowGroup()
    local player = StoreLogic:CurrentPlayer()
    StoreLogic:OwnGroup(player.UserId, function (group)
        print(tabStr(group))
        if group == nil then
            CtrlManager:OpenCtrl(MoudleNames.Group, GroupCtrlNames.GroupList)
        else
            CtrlManager:OpenCtrl(MoudleNames.Group, GroupCtrlNames.GroupMain, group)
            CtrlManager:CloseCtrl(MainCtrlNames.Main)
        end
    end)
end

function _M:ShowHeroList()
    CtrlManager:OpenCtrl(MoudleNames.Hero, HeroCtrlNames.HeroList)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowEquipList()
    CtrlManager:OpenCtrl(MoudleNames.Equip, EquipCtrlNames.EquipList)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

function _M:ShowItemList()
    CtrlManager:OpenCtrl(MoudleNames.Item, ItemCtrlNames.ItemList)
    CtrlManager:CloseCtrl(MainCtrlNames.Main)
end

return _M