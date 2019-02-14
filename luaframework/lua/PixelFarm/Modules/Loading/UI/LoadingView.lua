
local _LoadingView = class(ViewBase)

function _LoadingView:OnCreate()
    print("loadingView oncreate  ~~~~~~~")
    self.progressSlider = self.transform:Find("progress"):GetComponent("Slider")

    self.timerCo = nil
    self:LoadingRes()
end

function _LoadingView:LoadingRes()
    self.timerCo = coroutine.start(function ()
        coroutine.wait(1)
        self:UpdateProgress(1)
    end)
end

function _LoadingView:UpdateProgress(progress)
    self.progressSlider.value = progress

    if progress >= 1 then
        self.iCtrl:ShowMainView()
    end
end

function _LoadingView:OnDestroy()
    if self.timerCo then
        coroutine.stop(self.timerCo)
        self.timerCo = nil
    end
end

return _LoadingView