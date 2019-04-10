//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 9,
//"Name"          : "移形换位",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [45000, 45000, 45000],
//"Desc"          : "与一个目标英雄瞬间交换位置，无论敌我。移形换位打断目标的持续施法。 可用神杖升级。 如果你将目标移形换位到一个不可到达的区域，该目标将拥有5秒无视地形的能力 神杖效果：使大招CD时间由45秒变为10秒。",
//"LevelDesc" : [
//    "<color=#323232>等级 1\n - 施法距离<color=#0F701CFF>700</color>。</color>",
//    "<color=#323232>等级 2\n - 施法距离<color=#0F701CFF>950</color>。</color>",
//    "<color=#323232>等级 3\n - 施法距离<color=#0F701CFF>1200</color>。</color>"
//]
//魔法消耗：100/150/200点

public class Skill009 : BaseSkill
{
    Fix64 expend = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(45000))
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
                expend = (Fix64)100;
                break;
            case 2:
                expend = (Fix64)150;
                break;
            case 3:
                expend = (Fix64)200;
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
        UnityTools.Log(from.name + " 使用 " + name + " 攻击 " + hero.name + " 消耗 " + expend + "点MP");

        HeroAction treatAction = new HeroAction();
        treatAction.action = HeroActionType.Skill;
        treatAction.args = new object[] { from, hero, this };
        from.AddAction(treatAction);

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        treatAction1.args = new object[] { from, hero, this };
        hero.AddAction(treatAction1);

        Buff buff = new Buff();
        buff.type = BuffType.Focus;
        buff.start = now;
        buff.duration = Fix64.One * -1;
        hero.AddBuff(buff);
    }
}
