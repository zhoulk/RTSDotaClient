//===================================================
//作    者：周连康 
//创建时间：2019-04-08 12:00:37
//备    注：
//===================================================

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SkillItem{
    Text nameText;
    GameObject gameObject;

    public void Init(Transform trans)
    {
        gameObject = trans.gameObject;
        nameText = trans.Find("name").GetComponent<Text>();
    }

    //public void InitData(Skil hero, BaseHero baseH)
    //{
    //    baseHero = baseH;
    //    flagText.text = hero.Name;
    //    headImage.gameObject.SetActive(true);
    //}
}
