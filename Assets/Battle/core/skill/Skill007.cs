//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 7,
//"Name"          : "恐怖波动",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [15000, 15000, 15000, 15000],
//"Desc"          : "复仇之魂放出邪恶的嚎叫，削弱敌人的护甲并打开经过路径的视野。",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 减少<color=#0F701CFF>2</color>点的护甲并造成<color=#0F701CFF>30</color>点伤害。</color>",
//    "<color=#323232>等级 2:\n - 减少<color=#0F701CFF>3</color>点的护甲并造成<color=#0F701CFF>50</color>点伤害。</color>",
//    "<color=#323232>等级 3:\n - 减少<color=#0F701CFF>4</color>点的护甲并造成<color=#0F701CFF>70</color>点伤害。</color>",
//    "<color=#323232>等级 4:\n - 减少<color=#0F701CFF>5</color>点的护甲并造成<color=#0F701CFF>90</color>点伤害。</color>"
//]

//魔法消耗   40
//负面状态持续时间：8秒

public class Skill007 : BaseSkill
{
    Fix64 expend = (Fix64)40;
    Fix64 reduceArmor = Fix64.Zero;
    Fix64 attackHP = Fix64.Zero;
    Fix64 reduceDuration = (Fix64)8000;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(15000))
        {
            if (!InitData())
            {
                return false;
            }

            AttackToAll(from);

            return true;
        }
        return false;
    }

    bool InitData()
    {
        bool res = true;
        switch (level)
        {
            case 1:
                reduceArmor = (Fix64)200;
                attackHP = (Fix64)30;
                break;
            case 2:
                reduceArmor = (Fix64)300;
                attackHP = (Fix64)50;
                break;
            case 3:
                reduceArmor = (Fix64)500;
                attackHP = (Fix64)70;
                break;
            case 4:
                reduceArmor = (Fix64)700;
                attackHP = (Fix64)90;
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
        from.ReduceMP(expend);

        foreach (var hero in GameData.g_listHero)
        {
            if (hero.group == from.group)
            {
                continue;
            }

            hero.ReduceHP(attackHP);
            UnityTools.Log(from.name + " 使用 " + name + " 攻击 " + hero.name + " 造成 " + attackHP + " 点伤害，减甲" + reduceArmor + "，消耗 " + expend + "点MP");

            HeroAction treatAction1 = new HeroAction();
            treatAction1.action = HeroActionType.Skill;
            SkillAction skillAction1 = new SkillAction();
            skillAction1.action = SkillActionType.MiniHP;
            skillAction1.args = new object[] { attackHP };
            treatAction1.args = new object[] { from, hero, this, skillAction1 };
            hero.AddAction(treatAction1);

            Buff buff = new Buff();
            buff.type = BuffType.ReduceArmor;
            buff.start = now;
            buff.duration = reduceDuration;
            buff.arg1 = reduceArmor;
            hero.AddBuff(buff);
        }

        HeroAction treatAction = new HeroAction();
        treatAction.action = HeroActionType.Skill;
        treatAction.args = new object[] { from, null, this};
        from.AddAction(treatAction);
    }
}
