
local _ViewManager = class()
ViewManager = _ViewManager.Instance()

function _ViewManager:Init()
end

-- 加载界面
function _ViewManager:Start(ctrl, moduleName, viewName, parent, args)
    local viewClass = require(AppName .. "/Modules/" .. moduleName .. "/" .. "UI" .. "/" .. viewName)
    if viewClass then
        local view = viewClass.new(moduleName, viewName, parent, unpack(args))
        view.iCtrl = ctrl
        ctrl.view = view
        view.OpenViewCallback = ctrl.OpenViewCallback
        view:Create()
    else
        print('CreateView ' .. viewName .. " not find!") 
    end
end

