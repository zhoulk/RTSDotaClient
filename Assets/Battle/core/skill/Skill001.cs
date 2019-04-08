using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

//"Id"            : 1,
//"Name"          : "死亡缠绕",
//"Level"         : 0,
//"Type"          : 1,
//"CoolTime" : [5000, 5000, 5000, 5000],
//"Desc"          : "以自身生命为祭，通过死亡缠绕伤害/治疗一个敌方/友方单位。",
//"LevelDesc" : [
//    "<color=#323232>等级 1 以自身<color=#ff0000>75</color>点生命的代价，伤害/治疗一个敌方/友方单位<color=#0F701CFF>100</color>点的生命。</color>",
//    "<color=#323232>等级 2 以自身<color=#ff0000>100</color>点生命的代价，伤害/治疗一个敌方/友方单位<color=#0F701CFF>150</color>点的生命。</color>",
//    "<color=#323232>等级 3 以自身<color=#ff0000>125</color>点生命的代价，伤害/治疗一个敌方/友方单位<color=#0F701CFF>200</color>点的生命。</color>",
//    "<color=#323232>等级 4 以自身<color=#ff0000>150</color>点生命的代价，伤害/治疗一个敌方/友方单位<color=#0F701CFF>250</color>点的生命。</color>"
//]

    // 治疗血量小于 10% 的己方单位
    // 攻击血量最少的敌方单位

public class Skill001 : BaseSkill
{
    Fix64 expend = Fix64.Zero;
    Fix64 treatHP = Fix64.Zero;
    Fix64 attackHP = Fix64.Zero;

    public override bool Attack(BaseHero from)
    {
        if (CanAttack(5000))
        {
            if (!InitData())
            {
                return false;
            }

            BaseHero needTreatHero = FindTreatHero(from);
            if (needTreatHero != null)
            {
                TreatTo(from, needTreatHero);
                return true;
            }
            BaseHero attackHero = FindAttackHero(from);
            if(attackHero != null)
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
                expend = (Fix64)75;
                treatHP = (Fix64)100;
                attackHP = (Fix64)100;
                break;
            case 2:
                expend = (Fix64)100;
                treatHP = (Fix64)150;
                attackHP = (Fix64)150;
                break;
            case 3:
                expend = (Fix64)125;
                treatHP = (Fix64)200;
                attackHP = (Fix64)200;
                break;
            case 4:
                expend = (Fix64)150;
                treatHP = (Fix64)250;
                attackHP = (Fix64)250;
                break;
            default:
                UnityTools.Log("技能等级异常 " + name + " level=" + level);
                res = false;
                break;
        }
        return res;
    }

    BaseHero FindTreatHero(BaseHero from)
    {
        BaseHero target = null;
        foreach (var hero in GameData.g_listHero)
        {
            if (from.group != hero.group || from.heroId == hero.heroId)
            {
                continue;
            }

            if (target == null)
            {
                target = hero;
            }
            else
            {
                if (hero.hp / hero.maxHp * 100 < target.hp / target.maxHp * 100)
                {
                    target = hero;
                }
            }
        }
        if (target != null && target.hp / target.maxHp * 100 > (Fix64)10)
        {
            target = null;
        }

        return target;
    }

    BaseHero FindAttackHero(BaseHero from)
    {
        BaseHero target = null;
        foreach(var hero in GameData.g_listHero)
        {
            if(hero.group == from.group)
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

    void TreatTo(BaseHero from, BaseHero hero)
    {
        from.hp = from.hp - expend;
        hero.hp = hero.hp + treatHP;
        UnityTools.Log(from.name + " 使用 " + name + " 治愈 " + hero.name + " 造成 " + attackHP + " 点补给，消耗 " + expend + "点血量");

        HeroAction treatAction = new HeroAction();
        treatAction.action = HeroActionType.Skill;
        SkillAction skillAction = new SkillAction();
        skillAction.action = SkillActionType.MiniHP;
        skillAction.args = new object[] {expend};
        treatAction.args = new object[] {from, hero, this, skillAction};
        from.actions.Enqueue(treatAction);

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        SkillAction skillAction1 = new SkillAction();
        skillAction1.action = SkillActionType.AddHP;
        skillAction1.args = new object[] { treatHP };
        treatAction1.args = new object[] { from, hero, this, skillAction1 };
        hero.actions.Enqueue(treatAction1);
    }

    void AttackTo(BaseHero from, BaseHero hero)
    {
        from.hp = from.hp - expend;
        hero.hp = hero.hp + attackHP;
        UnityTools.Log(from.name + " 使用 " + name + " 攻击 " + hero.name + " 造成 " + attackHP + " 点伤害，消耗 " + expend + "点血量");

        HeroAction treatAction = new HeroAction();
        treatAction.action = HeroActionType.Skill;
        SkillAction skillAction = new SkillAction();
        skillAction.action = SkillActionType.MiniHP;
        skillAction.args = new object[] { expend };
        treatAction.args = new object[] { from, hero, this, skillAction };
        from.actions.Enqueue(treatAction);

        HeroAction treatAction1 = new HeroAction();
        treatAction1.action = HeroActionType.Skill;
        SkillAction skillAction1 = new SkillAction();
        skillAction1.action = SkillActionType.MiniHP;
        skillAction1.args = new object[] { attackHP };
        treatAction1.args = new object[] { from, hero, this, skillAction1 };
        hero.actions.Enqueue(treatAction1);
    }
}
