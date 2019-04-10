//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 2,
//"Name"          : "无光之盾",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [12000, 10000, 8000, 6000],
//"Desc"          : "用黑暗能量创造一个盾牌来保护友方的单位，在盾牌消失前吸收一定量的伤害。在盾牌被摧毁或持续时间到后，会给周围500范围内的敌方单位造成伤害。施放时移除目标身上的负面魔法效果。",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 总共能吸收<color=#0F701CFF>110</color>点的伤害。</color>",
//    "<color=#323232>等级 2:\n - 总共能吸收<color=#0F701CFF>140</color>点的伤害。</color>",
//    "<color=#323232>等级 3:\n - 总共能吸收<color=#0F701CFF>170</color>点的伤害。</color>",
//    "<color=#323232>等级 4:\n - 总共能吸收<color=#0F701CFF>200</color>点的伤害。</color>"
//]
//施法间隔：12/10/8/6秒
//魔法消耗：100/105/110/115点

public class Skill002 : BaseSkill
{
    Fix64 expend = Fix64.Zero;
    Fix64 converDuration = Fix64.Zero;
    Fix64 converDamage = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(Duration()))
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

    int Duration()
    {
        int duration = 12000;
        switch (level)
        {
            case 1:
                duration = 12000;
                break;
            case 2:
                duration = 10000;
                break;
            case 3:
                duration = 8000;
                break;
            case 4:
                duration = 6000;
                break;
        }
        return duration;
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
        hero.AddAction(treatAction1);

        Buff buff = new Buff();
        buff.type = BuffType.Cover1;
        buff.start = now;
        buff.duration = converDuration;
        buff.arg1 = Fix64.Zero;
        buff.arg2 = converDamage;
        hero.AddBuff(buff);
    }
}
