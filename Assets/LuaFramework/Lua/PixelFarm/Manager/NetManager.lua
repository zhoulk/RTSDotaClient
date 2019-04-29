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
    Protocal.Registe(112, "EquipRequest")
    Protocal.Registe(113, "EquipResponse")
    Protocal.Registe(114, "ChapterRequest")
    Protocal.Registe(115, "ChapterResponse")
    Protocal.Registe(116, "GuanKaRequest")
    Protocal.Registe(117, "GuanKaResponse")
    Protocal.Registe(118, "BattleGuanKaRequest")
    Protocal.Registe(119, "BattleGuanKaResponse")
    Protocal.Registe(120, "HeroSelectRequest")
    Protocal.Registe(121, "HeroSelectResponse")
    Protocal.Registe(122, "HeroUnSelectRequest")
    Protocal.Registe(123, "HeroUnSelectResponse")
    Protocal.Registe(124, "HeroSkillsRequest")
    Protocal.Registe(125, "HeroSkillsResponse")
    Protocal.Registe(126, "HeroEquipsRequest")
    Protocal.Registe(127, "HeroEquipsResponse")
    Protocal.Registe(128, "SkillUpgradeRequest")
    Protocal.Registe(129, "SkillUpgradeResponse")
    Protocal.Registe(130, "ZoneRequest")
    Protocal.Registe(131, "ZoneResponse")
    Protocal.Registe(136, "GroupOwnRequest")
	Protocal.Registe(137, "GroupOwnResponse")
	Protocal.Registe(138, "GroupListRequest")
	Protocal.Registe(139, "GroupListResponse")
	Protocal.Registe(140, "GroupCreateRequest")
	Protocal.Registe(141, "GroupCreateResponse")
	Protocal.Registe(142, "GroupMembersRequest")
    Protocal.Registe(143, "GroupMembersResponse")
    Protocal.Registe(144, "BattleCreateRequest")
    Protocal.Registe(145, "BattleCreateResponse")
    Protocal.Registe(146, "HeroLotteryRequest")
    Protocal.Registe(147, "HeroLotteryResponse")
    Protocal.Registe(148, "ItemRequest")
    Protocal.Registe(149, "ItemResponse")

    Protocal.Registe(1000, "ChapterUpdateNotify")
    Protocal.Registe(1001, "GuanKaUpdateNotify")
end
