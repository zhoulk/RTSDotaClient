require "Common.protocal"

local _NetManager = class()

NetManager = _NetManager.Instance()

function _NetManager:Init()
    Protocal.Registe(100, "LoginRequest")
    Protocal.Registe(101, "LoginResponse")
    Protocal.Registe(102, "RegisteRequest")
    Protocal.Registe(103, "RegisteResponse")
    Protocal.Registe(104, "HeroRequest")
    Protocal.Registe(105, "HeroResponse")
    Protocal.Registe(106, "HeroRandomRequest")
    Protocal.Registe(107, "HeroRandomResponse")
    Protocal.Registe(108, "HeroOwnRequest")
    Protocal.Registe(109, "HeroOwnResponse")
    Protocal.Registe(110, "SkillRequest")
    Protocal.Registe(111, "SkillResponse")
    Protocal.Registe(112, "ItemRequest")
    Protocal.Registe(113, "ItemResponse")
    Protocal.Registe(114, "ChapterRequest")
    Protocal.Registe(115, "ChapterResponse")
    Protocal.Registe(116, "GuanKaRequest")
    Protocal.Registe(117, "GuanKaResponse")
end
