//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 6,
//"Name"          : "魔法箭",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [10000, 10000, 10000, 10000],
//"Desc"          : "向一个敌方单位射出魔法箭，眩晕并造成伤害。",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 造成<color=#0F701CFF>100</color>点的伤害，晕眩<color=#0F701CFF>1.45</color>秒。施法消耗:<color=#ff0000>110</color>点魔法</color>",
//    "<color=#323232>等级 2:\n - 造成<color=#0F701CFF>175</color>点的伤害，晕眩<color=#0F701CFF>1.55</color>秒。施法消耗:<color=#ff0000>120</color>点魔法</color>",
//    "<color=#323232>等级 3:\n - 造成<color=#0F701CFF>250</color>点的伤害，晕眩<color=#0F701CFF>1.65</color>秒。施法消耗:<color=#ff0000>130</color>点魔法</color>",
//    "<color=#323232>等级 4:\n - 造成<color=#0F701CFF>325</color>点的伤害，晕眩<color=#0F701CFF>1.75</color>秒。施法消耗:<color=#ff0000>140</color>点魔法</color>"
//]

public class Skill006 : BaseSkill
{
    Fix64 expend = Fix64.Zero;
    Fix64 dizzDuration = Fix64.Zero;
    Fix64 attackHP = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(10000))
        {
            if (!InitData())
            {
                return false;
            }

            BaseHero attackHero = FindAttackHero(from);
            if (attackHero != null)
            {
                AttackTo(from, attackHero);
                return true;
            }
        }
        return false;
    }

    bool InitData()
    {
        bool res = true;
        switch (level)
        {
            case 1:
                expend = (Fix64)110;
                dizzDuration = (Fix64)1450;
                attackHP = (Fix64)100;
                break;
            case 2:
                expend = (Fix64)120;
                dizzDuration = (Fix64)1550;
                attackHP = (Fix64)175;
                break;
            case 3:
                expend = (Fix64)130;
                dizzDuration = (Fix64)1650;
                attackHP = (Fix64)250;
                break;
            case 4:
                expend = (Fix64)140;
                dizzDuration = (Fix64)1750;
                attackHP = (Fix64)325;
                break;
            default:
                UnityTools.Log("技能等级异常 " + name + " level=" + level);
                res = false;
                break;
        }
        return res;
    }

    BaseHero FindAttackHero(BaseHero from)
    {
        BaseHero target = null;
        foreach (var hero in GameData.g_listHero)
        {
            if (hero.group == from.group)
            {
                continue;
            }

            if (target == null)
            {
                target = hero;
            }
            else
            {
                if (hero.attackMax > target.attackMax)
                {
                    target = hero;
                }
            }
        }
        return target;
    }

    void AttackTo(BaseHero from, BaseHero hero)
    {
        from.ReduceMP(expend);
        hero.ReduceHP(attackHP);
        UnityTools.Log(from.name + " 使用 " + name + " 攻击 " + hero.name + " 造成 " + attackHP + " 点伤害，眩晕" + dizzDuration +"毫秒，消耗 " + expend + "点MP");

        HeroAction treatAction = new HeroAction();
        treatAction.action = HeroActionType.Skill;
        SkillAction skillAction = new SkillAction();
        skillAction.action = SkillActionType.MiniMP;
        skillAction.args = new object[] { expend };
        treatAction.args = new object[] { from, hero, this, skillAction };
        from.AddAction(treatAction);

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        SkillAction skillAction1 = new SkillAction();
        skillAction1.action = SkillActionType.MiniHP;
        skillAction1.args = new object[] { attackHP };
        treatAction1.args = new object[] { from, hero, this, skillAction1 };
        hero.AddAction(treatAction1);

        Buff buff = new Buff();
        buff.type = BuffType.Dizzy;
        buff.start = now;
        buff.duration = dizzDuration;
        hero.AddBuff(buff);
    }
}
