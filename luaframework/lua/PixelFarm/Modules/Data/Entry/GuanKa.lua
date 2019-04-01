local _M = class()

function _M:Init(g)
    g = g or {}
    self.Id = g.Id or 0
	self.Name = g.Name or ""
    self.IsOpen = g.IsOpen or false
    self.ChapterId = g.ChapterId
	-- self.Star = c.Star or 0
	-- self.Status = c.Status or 1
	-- self.GuanKaNum = c.GuanKaNum or 0
end

function _M:StatusStr()
    return guanKaStatusStr(self.Status)
end

-- ChapterStatusLock    int32 = 1
-- ChapterStatusNormal  int32 = 2
-- ChapterStatusCleared int32 = 3
function guanKaStatusStr(type)
    local m = {"未解锁", "未通关", "通关"}
    type = type or 0
    if type < 1 or type > 3 then
        return ""
    end
    return m[type]
end

return _M