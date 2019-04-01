local _M = class()

function _M:Init(c)
    c = c or {}
    self.Id = c.Id or 0
	self.Name = c.Name or ""
    self.IsOpen = c.IsOpen or false
	self.Star = c.Star or 0
	self.Status = c.Status or 1
	self.GuanKaNum = c.GuanKaNum or 0
end

function _M:StatusStr()
    return chapterStatusStr(self.Status)
end

-- ChapterStatusLock    int32 = 1
-- ChapterStatusNormal  int32 = 2
-- ChapterStatusCleared int32 = 3
function chapterStatusStr(type)
    local m = {"未解锁", "未通关", "通关"}
    type = type or 0
    if type < 1 or type > 3 then
        return ""
    end
    return m[type]
end

return _M