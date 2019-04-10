//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 8,
//"Name"          : "复仇光环",
//"Level"         : 0,
//"Type"          : 2,
//"CoolTime" : [0, 0, 0, 0],
//"Desc"          : "复仇之魂的存在提高了附近友方单位的物理攻击力。",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 增加<color=#0F701CFF>12%</color>的基础攻击力。</color>",
//    "<color=#323232>等级 2:\n - 增加<color=#0F701CFF>20%</color>的基础攻击力。</color>",
//    "<color=#323232>等级 3:\n - 增加<color=#0F701CFF>28%</color>的基础攻击力。</color>",
//    "<color=#323232>等级 4:\n - 增加<color=#0F701CFF>36%</color>的基础攻击力。</color>"
//]

public class Skill008 : BaseSkill
{
    Fix64 giftAttackPercent = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (!InitData())
        {
            return false;
        }

        AttackToAll(from);

        return false;
    }

    bool InitData()
    {
        bool res = true;
        switch (level)
        {
            case 1:
                giftAttackPercent = (Fix64)12;
                break;
            case 2:
                giftAttackPercent = (Fix64)20;
                break;
            case 3:
                giftAttackPercent = (Fix64)28;
                break;
            case 4:
                giftAttackPercent = (Fix64)36;
                break;
            default:
                UnityTools.Log("技能等级异常 " + name + " level=" + level);
                res = false;
                break;
        }
        return res;
    }

    void AttackToAll(BaseHero from)
    {
        foreach (var hero in GameData.g_listHero)
        {
            if (hero.group != from.group)
            {
                continue;
            }

            //UnityTools.Log(from.name + " 使用 " + name + " 增加攻击比例 " + giftAttackPercent );

            Buff buff = new Buff();
            buff.type = BuffType.GiftAttackPercent;
            buff.start = now;
            buff.duration = Fix64.One * -1;
            buff.arg1 = giftAttackPercent;
            hero.AddBuff(buff);
        }
    }
}
