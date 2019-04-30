local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"
local BattleLogic = require "PixelFarm.Modules.Logic.BattleLogic"
local MapLogic = require "PixelFarm.Modules.Logic.MapLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("ChapterDetailCtrl startView ~~~~~~~")
    self.chapter = self.args[1]

	ViewManager:Start(self, MoudleNames.Chapter, ChapterViewNames.ChapterDetail, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Chapter, ChapterCtrlNames.Chapter)
    CtrlManager:CloseCtrl(ChapterCtrlNames.ChapterDetail)
end

function _M:AllGuanKas(chapterId, cb)
    StoreLogic:AllGuanKas(chapterId, function (guanKas)
        if cb then
            cb(guanKas)
        end
    end, true)
end

function _M:ShowBattle(guanKa)
    BattleLogic:BattleCreate(1,{guanKa.Id}, function (succeed, err, battelId)
        if succeed then
            gameMgr:InitGameData(battelId)

            -- CtrlManager:OpenCtrl(MoudleNames.Battle, BattleCtrlNames.Battle)
            -- CtrlManager:CloseCtrl(ChapterCtrlNames.ChapterDetail)
        
            SceneManager.LoadSceneAsync("battle", LoadSceneMode.Additive)
        else
            toast(err.msg)
        end
    end)
end

local guankaInfoHandler
local chapterInfoHandler

function _M:ListenGuanKaUpdate(cb)
    if guankaInfoHandler == nil then
        guankaInfoHandler = function ()
            StoreLogic:AllGuanKas(self.chapter.Id, function (guanKas)
                if cb then
                    cb(guanKas)
                end
            end)
        end
    end
    Event.AddListener(EventType.GuanKaInfoChanged,guankaInfoHandler)
end

function _M:RemoveGuanKaListen()
    Event.RemoveListener(EventType.GuanKaInfoChanged,guankaInfoHandler)
end

function _M:ListenChapterUpdate(cb)
    if chapterInfoHandler == nil then
        chapterInfoHandler = function ()
            StoreLogic:FindChapter(self.chapter.Id, function (chapter)
                if cb then
                    cb(chapter)
                end
            end)
        end
    end
    Event.AddListener(EventType.ChapterInfoChanged,chapterInfoHandler)
end

function _M:RemoveChapterListen()
    Event.RemoveListener(EventType.GuanKaInfoChanged,chapterInfoHandler)
end

function _M:FindItems(itemIds, cb)
    StoreLogic:FindItems(itemIds,function (items)
        if cb then
            cb(items)
        end
    end)
end

return _M