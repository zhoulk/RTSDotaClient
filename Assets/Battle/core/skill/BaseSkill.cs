using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public enum SkillType
{
    Active = 1,
    Passive = 2
}

public enum SkillActionType
{
    AddHP = 1,
    MiniHP = 2,
    AddMP = 3,
    MiniMP = 4
}

public class SkillAction
{
    public SkillActionType action;
    public object[] args;
}

public class BaseSkill : UnityObject
{
    public static BaseSkill Create(int id)
    {
        BaseSkill sk = null;
        switch (id)
        {
            case 1:
                sk = new Skill001();
                break;
            case 2:
                sk = new Skill002();
                break;
            case 3:
                sk = new Skill003();
                break;
            case 4:
                sk = new Skill004();
                break;
            case 6:
                sk = new Skill006();
                break;
            case 7:
                sk = new Skill007();
                break;
            case 8:
                sk = new Skill008();
                break;
            case 9:
                sk = new Skill009();
                break;
        }
        return sk;
    }

    public virtual bool Attack(BaseHero from)
    {
        return false;
    }

    Fix64 coolTimer = Fix64.Zero;
    protected bool CanAttack(int coolDuration)
    {
        Fix64 timer = now;
        if (coolTimer + coolDuration < timer)
        {
            coolTimer = timer;
            return true;
        }
        return false;
    }

    protected bool CanAttackFrom(Fix64 fromTimer, int coolDuration)
    {
        Fix64 timer = now;
        if (fromTimer + coolDuration < timer)
        {
            return true;
        }
        return false;
    }

    public Fix64 now
    {
        get
        {
            return GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        }
    }

    int m_id;
    public int id { get { return m_id; } set { m_id = value; } }

    int m_level;
    public int level { get { return m_level; } set { m_level = value; } }

    SkillType m_type;
    public SkillType type { get { return m_type; } set { m_type = value; } }

    bool m_isOpen;
    public bool isOpen { get { return m_isOpen; } set { m_isOpen = value; } }

    string m_name = "";
    public string name { get { return m_name; } set { m_name = value; } }

}