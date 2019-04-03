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

public class HeadItem {
    public GameObject gameObject;
    Text nameText;
    Image hpFontImage;
    Image mpFontImage;
    public BaseHero baseHero;

    public void Init(Transform trans)
    {
        gameObject = trans.gameObject;
        nameText = trans.Find("head/name").GetComponent<Text>();
        hpFontImage = trans.Find("HPProgress/font").GetComponent<Image>();
        mpFontImage = trans.Find("MPProgress/font").GetComponent<Image>();
    }

    public void InitData(Hero hero, BaseHero baseH)
    {
        baseHero = baseH;
        nameText.text = hero.Name;
        //hpFontImage.fillAmount = hero.Blood / hero.MaxBlood;
        //mpFontImage.fillAmount = hero.MP / hero.MaxMP;
    }

    public void Update()
    {
        if (baseHero != null)
        {
            hpFontImage.fillAmount = (float)(baseHero.hp / baseHero.maxHp);
            mpFontImage.fillAmount = (float)(baseHero.mp / baseHero.maxMp);
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
}
