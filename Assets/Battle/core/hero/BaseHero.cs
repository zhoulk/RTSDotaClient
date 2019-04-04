using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public enum ActionType
{
    Attack = 1,
    Hurt = 2
}

public class HeroAction
{
    public ActionType action;
    public object[] args;
}

public class BaseHero : UnityObject
{
    public Queue<HeroAction> actions = new Queue<HeroAction>();

    public List<BaseSkill> skills = new List<BaseSkill>();

    //- Ã¿Ö¡Ñ­»·
    // 
    // @return none
    virtual public void updateLogic()
    {
        if (SkillAttack())
        {
            return;
        }
        if (CanAttack())
        {
            normalAttack();
        }
    }

    bool SkillAttack()
    {
        bool attack = false;
        foreach (var skill in skills)
        {
            attack = skill.Attack(this);
        }
        return attack;
    }

    Fix64 coolTimer = Fix64.Zero;
    bool CanAttack()
    {
        Fix64 timer = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        if(coolTimer + 1700 < timer)
        {
            coolTimer = timer;
            return true;
        }
        return false;
    }

    void normalAttack()
    {
        BaseHero target = null;
        foreach(BaseHero hero in GameData.g_listHero)
        {
            if (hero.group != group)
            {
                target = hero;
            }
        }
        if (target != null)
        {
            HeroAction action = new HeroAction();
            action.action = ActionType.Attack;
            action.args = new object[] { target };
            actions.Enqueue(action);

            uint randAttack = GameData.g_srand.Next((uint)(attackMax - attackMin));
            Fix64 reduce = (attackMin + randAttack) / 100;
            target.hp = target.hp - reduce;

            HeroAction hurtAction = new HeroAction();
            hurtAction.action = ActionType.Hurt;
            hurtAction.args = new object[] { reduce };
            target.actions.Enqueue(hurtAction);
        }
    }

    Fix64 m_level = Fix64.Zero;
    public Fix64 level { get { return m_level; } set { m_level = value; } }

    Fix64 m_strength = Fix64.Zero;
    public Fix64 strength { get { return m_strength; } set { m_strength = value; } }

    Fix64 m_agility = Fix64.Zero;
    public Fix64 agility { get { return m_agility; } set { m_agility = value; } }

    Fix64 m_intelligence = Fix64.Zero;
    public Fix64 intelligence { get { return m_intelligence; } set { m_intelligence = value; } }

    Fix64 m_armor = Fix64.Zero;
    public Fix64 armor { get { return m_armor; } set { m_armor = value; } }

    Fix64 m_attackMin = Fix64.Zero;
    public Fix64 attackMin { get { return m_attackMin; } set { m_attackMin = value; } }

    Fix64 m_attackMax = Fix64.Zero;
    public Fix64 attackMax { get { return m_attackMax; } set { m_attackMax = value; } }

    Fix64 m_hp = Fix64.Zero;
    public Fix64 hp { get { return m_hp; } set { m_hp = value; } }

    Fix64 m_maxHp = Fix64.Zero;
    public Fix64 maxHp { get { return m_maxHp; } set { m_maxHp = value; } }

    Fix64 m_mp = Fix64.Zero;
    public Fix64 mp { get { return m_mp; } set { m_mp = value; } }

    Fix64 m_maxMp = Fix64.Zero;
    public Fix64 maxMp { get { return m_maxMp; } set { m_maxMp = value; } }

    Fix64 m_pos = Fix64.Zero;
    public Fix64 pos { get { return m_pos; } set { m_pos = value; } }

    Fix64 m_group = Fix64.Zero;
    public Fix64 group { get { return m_group; } set { m_group = value; } }

    string m_heroId = "";
    public string heroId { get { return m_heroId; } set { m_heroId = value; } }

    string m_name = "";
    public string name { get { return m_name; } set { m_name = value; } }
}
