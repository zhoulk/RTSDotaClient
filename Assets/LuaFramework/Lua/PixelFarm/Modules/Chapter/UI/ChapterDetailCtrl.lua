local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("ChapterDetailCtrl startView ~~~~~~~")
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
    end)
end

function _M:ShowBattle(guanKa)
    gameMgr:InitGameData("1234567890")

    -- CtrlManager:OpenCtrl(MoudleNames.Battle, BattleCtrlNames.Battle)
    -- CtrlManager:CloseCtrl(ChapterCtrlNames.ChapterDetail)

    SceneManager.LoadSceneAsync("battle", LoadSceneMode.Additive)
end

return _M