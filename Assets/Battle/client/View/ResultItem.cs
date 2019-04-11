//===================================================
//作    者：周连康 
//创建时间：2019-04-11 09:34:20
//备    注：
//===================================================

using Msg;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ResultItem {
    public GameObject gameObject;
    Text goldText;
    Text expText;
    Text levelText;
    Image levelFontImage;
    Text levelPercentText;

    public Earn earn;

    public void Init(Transform trans)
    {
        gameObject = trans.gameObject;
        goldText = trans.Find("gift/gold").GetComponent<Text>();
        expText = trans.Find("gift/exp").GetComponent<Text>();
        levelText = trans.Find("gift/level").GetComponent<Text>();
        levelFontImage = trans.Find("gift/lvPercent/font").GetComponent<Image>();
        levelPercentText = trans.Find("gift/lvPercent/label").GetComponent<Text>();
    }

    public void InitData(Earn _earn)
    {
        earn = _earn;

        goldText.text = "金币 " + earn.Gold;
        expText.text = "经验 " + earn.PlayerExp;
    }
}
