local _M = class()
LocalDataManager = _M.Instance()

-- LocalDataKey = {
--     PLAYER_UID = "player_uid"
-- }

-- -- 获取本地用户ID
-- function _M:GetUid()
--     if PlayerPrefs.HasKey(LocalDataKey.PLAYER_UID) then
--         return PlayerPrefs.GetString(LocalDataKey.PLAYER_UID)
--     else
--         return ""
--     end
-- end

-- function _M:SaveUid(uid)
--     if uid and #uid > 0 then
--         PlayerPrefs.SetString(LocalDataKey.PLAYER_UID, uid)
--     else
--         print("[LocalDataManager] SaveUid error!  uid = " .. uid)
--     end
-- end

function _M:Save(key, data)
    local str = tabStr(data)
    print("[LocalDataManager.Save] str = " .. str)

    PlayerPrefs.SetString(key, str)
end

function _M:Load(key)
    local str = PlayerPrefs.GetString(key)
    print("[LocalDataManager.Load] str = " .. str)
    if str == nil or #str == 0 then
        return nil
    else
        return strTab(str)
    end
end