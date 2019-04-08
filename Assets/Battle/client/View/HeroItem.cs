//===================================================
//作    者：周连康 
//创建时间：2019-04-03 11:39:07
//备    注：
//===================================================

using Msg;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HeroItem {
    public GameObject gameObject;
    Text flagText;
    Image headImage;
    Text upText;
    Text skillText;
    Animator animator;
    Text[] skills = new Text[4];

    BaseHero baseHero;

    public void Init(Transform trans)
    {
        gameObject = trans.gameObject;
        flagText = trans.Find("flag").GetComponent<Text>();
        headImage = trans.Find("head").GetComponent<Image>();
        upText = trans.Find("up").GetComponent<Text>();
        skillText = trans.Find("skill").GetComponent<Text>();
        animator = trans.GetComponent<Animator>();
        for(int i=0; i<skills.Length; i++)
        {
            skills[i] = trans.Find("skills/skill" + (i+1) + "/name").GetComponent<Text>();
        }
    }

    public void InitData(Hero hero, BaseHero baseH)
    {
        baseHero = baseH;
        flagText.text = hero.Name;
        headImage.gameObject.SetActive(true);

    }

    public void Update()
    {
        if (baseHero != null)
        {
            if (baseHero.actions.Count > 0)
            {
                HeroAction action = baseHero.actions.Dequeue();
                if (action != null)
                {
                    switch (action.action)
                    {
                        case HeroActionType.Attack:
                            Attack();
                            break;
                        case HeroActionType.Hurt:
                            Fix64 reduce = (Fix64)action.args[0];
                            ShowUp("-" + (int)reduce);
                            //Hurt();
                            break;
                        case HeroActionType.Skill:
                            Skill(action.args);
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }

    void Attack()
    {
        //UnityTools.Log("Attack ");
        animator.Play("attack", 0, 0);
    }

    void Hurt()
    {
        //UnityTools.Log("Hurt ");
        animator.Play("hurt", 0, 0);
    }

    void ShowUp(string str)
    {
        //UnityTools.Log("ShowUp " + str);
        upText.text = str;
        upText.fontSize = 32;
        animator.Play("show_up", 1, 0);
    }

    void ShowSkill(string str)
    {
        skillText.text = str;
        skillText.fontSize = 32;
        animator.Play("skill", 2, 0);
    }

    void Skill(object[] args)
    {
        BaseHero from = (BaseHero)args[0];
        BaseHero to = (BaseHero)args[1];
        BaseSkill skill = (BaseSkill)args[2];
        SkillAction skillAction = (SkillAction)args[3];

        if (from.heroId == baseHero.heroId)
        {
            //UnityTools.Log(from.heroId + " == " + baseHero.heroId);
            ShowSkill(skill.name);
        }
    }

    public void Show()
    {
        gameObject.SetActive(true);
    }

    public void Hide()
    {
        gameObject.SetActive(false);
    }

    public bool IsIn(Vector3 pos)
    {
        //UnityTools.Log("gameObject.transform.position = " + gameObject.transform.position + " " +pos);

        if (pos.x >= gameObject.transform.position.x - 0.5f && pos.x <= gameObject.transform.position.x + 0.5f &&
            pos.y >= gameObject.transform.position.y - 0.5f && pos.y <= gameObject.transform.position.y + 0.5f)
        {
            return true;
        }

        return false;
    }
}
