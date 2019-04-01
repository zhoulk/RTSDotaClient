
local _M = class(ViewBase)

function _M:OnCreate()
    print("ChapterView oncreate  ~~~~~~~")

    self.backBtn = self.transform:Find("backBtn").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.chapterBlock = self:InitChapterBlock(self.transform, "chapters")

    self:InitData()
end

function _M:InitData()
   self.iCtrl:AllChapters(function (chapters)
       self:UpdateChapterList(chapters)
   end)
end

function _M:InitChapterBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform

    block.chapterItem = transform:Find("item").gameObject
    block.chapterList = transform:GetComponent("ScrollRect")

    return block
end


function _M:UpdateChapterList(chapters)
    if chapters then
        for i,chapter in pairs(chapters) do
            local chapterObj = newObject(self.chapterBlock.chapterItem)
            chapterObj.transform:SetParent(self.chapterBlock.chapterList.content, false)
            chapterObj.transform.localScale = Vector3(1,1,1)
            chapterObj:SetActive(true)

            chapterObj.transform:Find("bg/name"):GetComponent("Text").text = chapter.Name
            chapterObj.transform:Find("bg/status"):GetComponent("Text").text = chapter:StatusStr()

            chapterObj:SetOnClick(function ()
                self:OnChapterClick(chapter)
            end)
        end
    end
end

function _M:OnChapterClick(chapter)
    
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()

end

return _M