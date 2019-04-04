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
        Fix64 timer = GameData.g_uGameLogicFrame * GameData.g_fixFrameLen * 1000;
        if (coolTimer + coolDuration < timer)
        {
            coolTimer = timer;
            return true;
        }
        return false;
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