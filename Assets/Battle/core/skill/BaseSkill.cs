using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class BaseSkill : UnityObject
{
    int m_id;
    public int id { get { return m_id; } set { m_id = value; } }

    int m_level;
    public int level { get { return m_level; } set { m_level = value; } }

    int m_type;
    public int type { get { return m_type; } set { m_type = value; } }

    bool m_isOpen;
    public bool isOpen { get { return m_isOpen; } set { m_isOpen = value; } }

}