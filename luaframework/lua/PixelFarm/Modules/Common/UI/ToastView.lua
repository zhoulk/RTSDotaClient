
local _ToastView = class(ViewBase)

function _ToastView:OnCreate()
    print("ToastView oncreate  ~~~~~~~")

    self.bgObj = self.transform:Find("bg").gameObject
    self.text = self.transform:Find("bg/text"):GetComponent("Text")

    self.bgObj:SetActive(false)

    self.timerCo = nil
end

function _ToastView:Show(txt, delay)
    self.text.text = txt
    self.bgObj:SetActive(true)

    local _delay = delay or 1.5
    self.timerCo = coroutine.start(function ()
        coroutine.wait(_delay)
        self:Hide()
    end)
end

function _ToastView:Hide()
    self.bgObj:SetActive(false)
end

function _ToastView:OnDestroy()
    
end

return _ToastView