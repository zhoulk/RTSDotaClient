//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 3,
//"Name"          : "霜之哀伤",
//"Level"         : 0,
//"Type"          : 2,
//"CoolTime" : [10000, 10000, 10000, 10000],
//"Desc"          : "地狱领主使用传说之剑霜之哀伤的极寒力量使目标减速，持续2.5秒。任何攻击被减速目标的单位得到速度的提升，持续4.5秒",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 降低目标<color=#0F701CFF>5%/5%</color>攻击/移动速度，提升攻击者<color=#0F701CFF>10%/15%</color>攻击/移动速度。</color>",
//    "<color=#323232>等级 2:\n - 降低目标<color=#0F701CFF>10%/10%</color>攻击/移动速度，提升攻击者<color=#0F701CFF>20%/15%</color>攻击/移动速度。</color>",
//    "<color=#323232>等级 3:\n - 降低目标<color=#0F701CFF>15%/15%</color>攻击/移动速度，提升攻击者<color=#0F701CFF>30%/15%</color>攻击/移动速度。</color>",
//    "<color=#323232>等级 4:\n - 降低目标<color=#0F701CFF>20%/20%</color>攻击/移动速度，提升攻击者<color=#0F701CFF>40%/15%</color>攻击/移动速度。</color>"
//]

public class Skill003 : BaseSkill
{
    Fix64 expend = Fix64.Zero;
    Fix64 converDuration = Fix64.Zero;
    Fix64 converDamage = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(10000))
        {
            if (!InitData())
            {
                return false;
            }

            BaseHero converHero = FindCoverHero(from);
            if (converHero != null)
            {
                CoverTo(from, converHero);
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
                expend = (Fix64)100;
                converDuration = (Fix64)15000;
                converDamage = (Fix64)110;
                break;
            case 2:
                expend = (Fix64)105;
                converDuration = (Fix64)15000;
                converDamage = (Fix64)140;
                break;
            case 3:
                expend = (Fix64)110;
                converDuration = (Fix64)15000;
                converDamage = (Fix64)170;
                break;
            case 4:
                expend = (Fix64)115;
                converDuration = (Fix64)15000;
                converDamage = (Fix64)200;
                break;
            default:
                UnityTools.Log("技能等级异常 " + name + " level=" + level);
                res = false;
                break;
        }
        return res;
    }

    BaseHero FindCoverHero(BaseHero from)
    {
        BaseHero target = null;
        foreach (var hero in GameData.g_listHero)
        {
            if (hero.group != from.group)
            {
                continue;
            }

            if (target == null)
            {
                target = hero;
            }
            else
            {
                if (hero.hp < target.hp)
                {
                    target = hero;
                }
            }
        }
        return target;
    }

    void CoverTo(BaseHero from, BaseHero hero)
    {
        from.ReduceMP(expend);
        UnityTools.Log(from.name + " 对 " + hero.name + " 使用 " + name + "消耗 " + expend + "点MP");

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        treatAction1.args = new object[] { from, hero, this };
        hero.actions.Enqueue(treatAction1);

        Buff buff = new Buff();
        buff.type = BuffType.Cover1;
        buff.start = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        buff.duration = converDuration;
        buff.arg1 = Fix64.Zero;
        buff.arg2 = converDamage;
        hero.buffs.Add(buff);
    }
}
