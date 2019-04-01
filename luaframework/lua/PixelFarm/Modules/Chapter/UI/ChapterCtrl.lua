local StoreLogic = require "PixelFarm.Modules.Logic.StoreLogic"

local _M = class(CtrlBase)

function _M:StartView()
    print("ChapterCtrl startView ~~~~~~~")
    self.hero = self.args[2]

	ViewManager:Start(self, MoudleNames.Chapter, ChapterViewNames.Chapter, PANEL_HIGH(), self.args)
end

function _M:Close()
    CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    CtrlManager:CloseCtrl(ChapterCtrlNames.Chapter)
end

function _M:AllChapters(cb)
    local player = StoreLogic:CurrentPlayer()
    StoreLogic:AllChapters(player.UserId, function (chapters)
        if cb then
            cb(chapters)
        end
    end)
end

function _M:ShowChapterDetail(chapter)
    CtrlManager:OpenCtrl(MoudleNames.Chapter, ChapterCtrlNames.ChapterDetail, chapter)
    CtrlManager:CloseCtrl(ChapterCtrlNames.Chapter)
end

return _M