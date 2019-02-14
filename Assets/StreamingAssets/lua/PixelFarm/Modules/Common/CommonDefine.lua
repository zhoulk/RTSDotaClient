CommonCtrlNames = {
    Toast = "ToastCtrl"
}

CommonViewNames = {
    Toast = "ToastView"
}


CtrlNames[MoudleNames.Common] = CtrlNames[MoudleNames.Common] or CommonCtrlNames
ViewNames[MoudleNames.Common] = ViewNames[MoudleNames.Common] or CommonViewNames


-- 吐司
function Toast(msg)
    CtrlManager:GetCtrl(CommonCtrlNames.Toast):ShowToast(msg)
end