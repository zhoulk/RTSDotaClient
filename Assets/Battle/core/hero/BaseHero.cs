using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public enum HeroActionType
{
    Attack = 1,
    Hurt = 2,
    Skill = 3,
}

public class HeroAction
{
    public HeroActionType action;
    public object[] args;
}

public enum BuffType
{
    Dizzy = 1, // 眩晕
    Cover1 = 2, // 无光之盾
    Slow1 = 3, // 霜之哀伤
    LiftSpeed = 4, // 提升攻速
    Change1 = 5, // 回光返照
    ReduceArmor = 6, // 减甲
    GiftAttackPercent = 7, // 比例增加攻击
    Focus = 8, // 集火
}

public class Buff
{
    public BuffType type;
    public Fix64 start;
    public Fix64 duration;
    public Fix64 duration2;
    public Fix64 arg1;
    public Fix64 arg2;
}

public class BaseHero : UnityObject
{
    Queue<HeroAction> actions = new Queue<HeroAction>();

    public List<BaseSkill> skills = new List<BaseSkill>();

    List<Buff> buffs = new List<Buff>();

    public static Fix64 BASE_BAT = (Fix64)1700;

    // 
    // @return none
    virtual public void updateLogic()
    {
        CheckBuff();

        EffectBuff();

        if (!CanAttack())
        {
            return;
        }

        if (SkillAttack())
        {
            return;
        }
        if (CanNormalAttack())
        {
            normalAttack();
        }
    }

    void CheckBuff()
    {
        Fix64 timer = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        for (int i= buffs.Count-1; i>=0; i--)
        {
            Buff buff = buffs[i];
            if (buff.duration > Fix64.Zero && buff.start + buff.duration <= timer)
            {
                buffs.Remove(buff);
            }
        }
    }

    void EffectBuff()
    {
        Fix64 slowPercent = Fix64.Zero;
        Fix64 giftPercent = Fix64.Zero;
        Fix64 effectArmor = Fix64.Zero;
        Fix64 attackPercent = Fix64.Zero;
        for (int i = buffs.Count - 1; i >= 0; i--)
        {
            Buff buff = buffs[i];
            switch(buff.type)
            {
                case BuffType.Slow1:
                    slowPercent += buff.arg1;
                    break;
                case BuffType.LiftSpeed:
                    giftPercent += buff.arg1;
                    break;
                case BuffType.ReduceArmor:
                    effectArmor -= buff.arg1;
                    break;
                case BuffType.GiftAttackPercent:
                    attackPercent += buff.arg1;
                    break;
            }
        }

        BAT = BASE_BAT * (100 - slowPercent + giftPercent) / 100;
        armor = originArmor + effectArmor;
        attackMin = originAttackMin * (Fix64.One + attackPercent / 100);
        attackMax = originAttackMax * (Fix64.One + attackPercent / 100);
    }

    bool CanAttack()
    {
        bool res = true;
        for (int i = buffs.Count - 1; i >= 0; i--)
        {
            Buff buff = buffs[i];
            switch (buff.type)
            {
                case BuffType.Dizzy:
                    //UnityTools.Log(name + "被眩晕");
                    res = false;
                    break;
            }
        }
        return res;
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
    bool CanNormalAttack()
    {
        Fix64 timer = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        if(coolTimer + BAT < timer)
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
            action.action = HeroActionType.Attack;
            action.args = new object[] { target };
            actions.Enqueue(action);

            uint randAttack = GameData.g_srand.Next((uint)(attackMax - attackMin));
            Fix64 reduce = (attackMin + randAttack) / 100;

            if (armor >= Fix64.Zero)
            {
                Fix64 percent = (target.armor / 100 * 6) / (100 + target.armor / 100 * 6);
                reduce = reduce * (Fix64.One - percent);
            }
            else
            {
                Fix64 deeper = (Fix64)2 - Fix64.Pow((Fix64)0.94, (int)(Fix64.Abs(target.armor) / 100));
                reduce = reduce * deeper;
            }

            target.ReduceHP(reduce);
            target.BeAttack(this);
        }
    }

    public void BeAttack(BaseHero from)
    {
        for (int i = buffs.Count - 1; i >= 0; i--)
        {
            Buff buff = buffs[i];
            switch (buff.type)
            {
                case BuffType.Slow1:

                    Buff liftBuff = new Buff();
                    liftBuff.type = BuffType.LiftSpeed;
                    liftBuff.start = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
                    liftBuff.duration = buff.duration2;
                    liftBuff.arg1 = buff.arg2;
                    from.AddBuff(liftBuff);

                    break;
            }
        }
    }

    public void AddBuff(Buff buff)
    {
        foreach (var buf in buffs)
        {
            if (buf.type == buff.type)
            {
                return;
            }
        }

        buffs.Add(buff);
    }

    public void AddAction(HeroAction action)
    {
        if (action.action == HeroActionType.Skill && action.args.Length > 2)
        {
            foreach (var act in actions)
            {
                if (act.action == HeroActionType.Skill)
                {
                    if (act.args.Length > 2)
                    {
                        BaseSkill skill = (BaseSkill)act.args[2];
                        BaseSkill skill2 = (BaseSkill)action.args[2];
                        if (skill.type == skill2.type)
                        {
                            return;
                        }
                    }
                }
            }
        }

        actions.Enqueue(action);
    }

    public int ActionCnt()
    {
        return actions.Count;
    }

    public HeroAction GetAction()
    {
        return actions.Dequeue();
    }

    public void ReduceHP(Fix64 offset, bool force = false)
    {
        if (!force)
        {
            for (int i = buffs.Count - 1; i >= 0; i--)
            {
                Buff buff = buffs[i];
                switch (buff.type)
                {
                    case BuffType.Cover1:
                        buff.arg1 += offset;
                        if (buff.arg1 >= buff.arg2)
                        {
                            offset = buff.arg1 - buff.arg2;
                            buffs.Remove(buff);
                            foreach (var hero in GameData.g_listHero)
                            {
                                if (hero.group != group)
                                {
                                    hero.ReduceHP(buff.arg2 / 5);
                                }
                            }
                        }
                        else
                        {
                            offset = Fix64.Zero;
                        }
                        break;
                    case BuffType.Change1:
                        offset = offset * -1;
                        break;
                }
            }
        }
        
        hp -= offset;

        HeroAction hurtAction = new HeroAction();
        hurtAction.action = HeroActionType.Hurt;
        hurtAction.args = new object[] { offset };
        actions.Enqueue(hurtAction);

        if (hp <= Fix64.Zero)
        {
            UnityTools.Log("hp ======= " + hp);
            IsDied = true;
        }
    }

    public void AddHP(Fix64 offset)
    {
        hp += offset;
    }

    public void ReduceMP(Fix64 offset)
    {
        mp -= offset;
    }

    public void AddMP(Fix64 offset)
    {
        mp += offset;
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

    Fix64 m_originArmor = Fix64.Zero;
    public Fix64 originArmor { get { return m_originArmor; } set { m_originArmor = value; } }

    Fix64 m_attackMin = Fix64.Zero;
    public Fix64 attackMin { get { return m_attackMin; } set { m_attackMin = value; } }

    Fix64 m_attackMax = Fix64.Zero;
    public Fix64 attackMax { get { return m_attackMax; } set { m_attackMax = value; } }

    Fix64 m_originAttackMin = Fix64.Zero;
    public Fix64 originAttackMin { get { return m_originAttackMin; } set { m_originAttackMin = value; } }

    Fix64 m_originAttackMax = Fix64.Zero;
    public Fix64 originAttackMax { get { return m_originAttackMax; } set { m_originAttackMax = value; } }

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

    Fix64 m_BAT = BASE_BAT;
    public Fix64 BAT { get { return m_BAT; } set { m_BAT = value; } }

    string m_heroId = "";
    public string heroId { get { return m_heroId; } set { m_heroId = value; } }

    string m_name = "";
    public string name { get { return m_name; } set { m_name = value; } }

    bool m_IsDied = false;
    public bool IsDied { get { return m_IsDied; } set { m_IsDied = value; } }
}
