//===================================================
//作    者：周连康 
//创建时间：2019-04-03 11:34:23
//备    注：
//===================================================

using Msg;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class BattleView : MonoBehaviour {

    HeadItem[] headItems = new HeadItem[5];
    HeroItem[] friendHeroItems = new HeroItem[9];
    HeroItem[] enermyHeroItems = new HeroItem[9];
    GameObject selectItem;
    Text selectItemNameText;

    ArrayList m_skills;
    ArrayList m_heros;

    private void Awake()
    {
        for (int i = 0; i < friendHeroItems.Length; i++)
        {
            friendHeroItems[i] = new HeroItem();
            friendHeroItems[i].Init(transform.Find("friend/heros/" + (i + 1) + "/heroItem"));
        }

        for (int i = 0; i < enermyHeroItems.Length; i++)
        {
            enermyHeroItems[i] = new HeroItem();
            enermyHeroItems[i].Init(transform.Find("enermy/heros/" + (i + 1) + "/heroItem"));
        }

        for (int i=0; i<headItems.Length; i++)
        {
            headItems[i] = new HeadItem();
            headItems[i].Init(transform.Find("heads/item" + (i+1)));
        }

        selectItem = transform.Find("selectItem").gameObject;
        selectItemNameText = selectItem.transform.Find("name").GetComponent<Text>();
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		foreach(var headItem in headItems)
        {
            headItem.Update();
        }
        foreach (var heroItem in friendHeroItems)
        {
            heroItem.Update();
        }
        foreach (var heroItem in enermyHeroItems)
        {
            heroItem.Update();
        }
    }

    public void InitSkills(ArrayList skills)
    {
        m_skills = skills;

        ParseData();
    }

    public void InitItems(ArrayList items)
    {

    }

    public void InitHeros(ArrayList heros)
    {
        m_heros = heros;

        ParseData();
    }

    void ParseData()
    {
        if(m_heros == null || m_skills == null)
        {
            return;
        }

        int i = 0;
        foreach (Hero hero in m_heros)
        {
            BaseHero baseHero = ConvertMsgHeroToHero(hero);

            if (i == 0)
            {
                baseHero.group = Fix64.One;
                BaseSkill skill = ConvertMsgSkillToSkill((Skill)m_skills[0]);
                skill.level = 2;
                baseHero.skills.Add(skill);

                HeroItem item = friendHeroItems[0];
                item.InitData(hero, baseHero);

                headItems[0].InitData(hero, baseHero);
                headItems[0].Show();
            }
            else if (i == 1)
            {
                baseHero.group = Fix64.One * 2;

                HeroItem item = enermyHeroItems[0];
                item.InitData(hero, baseHero);
            }

            GameData.g_listHero.Add(baseHero);

            i++;
        }
    }

    BaseHero ConvertMsgHeroToHero(Hero h)
    {
        BaseHero hero = new BaseHero();
        hero.heroId = h.HeroId;
        hero.name = h.Name;
        hero.hp = new Fix64(h.Blood);
        hero.maxHp = new Fix64(h.MaxBlood);
        hero.mp = new Fix64(h.MP);
        hero.maxMp = new Fix64(h.MaxMP);
        hero.attackMin = new Fix64(h.AttackMin);
        hero.attackMax = new Fix64(h.AttackMax);
        return hero;
    }

    BaseSkill ConvertMsgSkillToSkill(Skill sk)
    {
        BaseSkill skill = BaseSkill.Create(sk.Id);
        skill.id = sk.Id;
        skill.name = sk.Name;
        skill.level = sk.Level;
        skill.type = (SkillType)sk.Type;
        skill.isOpen = sk.IsOpen;
        return skill;
    }
}
