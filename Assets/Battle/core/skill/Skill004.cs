//===================================================
//作    者：周连康 
//创建时间：2019-04-08 15:15:53
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//"Id"            : 4,
//"Name"          : "回光返照",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [60000, 50000, 40000],
//"Desc"          : "启动时，移除身上负面的魔法效果，期间所有受到的伤害转而治疗你。如果你当前的生命值低于400而技能不在CD过程中，则技能会自动启动。",
//"LevelDesc" : [
//    "<color=#323232>等级 1:\n - 持续<color=#0F701CFF>4</color>秒。</color>",
//    "<color=#323232>等级 2:\n - 持续<color=#0F701CFF>5</color>秒。</color>",
//    "<color=#323232>等级 3:\n - 持续<color=#0F701CFF>6</color>秒。</color>"
//]

public class Skill004 : BaseSkill
{
    Fix64 changeDuration = Fix64.Zero;

    Fix64 lastAttackTimer = Fix64.One * -100000;

    public override bool Attack(BaseHero from)
    {
        if (from.hp < from.maxHp * (Fix64)20 / 100 && CanAttackFrom(lastAttackTimer, Duration()))
        {
            lastAttackTimer = now;
            if (!InitData())
            {
                return false;
            }

            if (from != null)
            {
                ChangeTo(from);
                return true;
            }
        }
        return false;
    }

    int Duration()
    {
        int duration = 60000;
        switch (level)
        {
            case 1:
                duration = 60000;
                break;
            case 2:
                duration = 50000;
                break;
            case 3:
                duration = 40000;
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
                changeDuration = (Fix64)4000;
                break;
            case 2:
                changeDuration = (Fix64)5000;
                break;
            case 3:
                changeDuration = (Fix64)6000;
                break;
            default:
                UnityTools.Log("技能等级异常 " + name + " level=" + level);
                res = false;
                break;
        }
        return res;
    }

    void ChangeTo(BaseHero from)
    {
        UnityTools.Log(from.name + " 对 " + from.name + " 使用 " + name);

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        treatAction1.args = new object[] { from, null, this };
        from.AddAction(treatAction1);

        Buff buff = new Buff();
        buff.type = BuffType.Change1;
        buff.start = now;
        buff.duration = changeDuration;
        from.AddBuff(buff);
    }
}
