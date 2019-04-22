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

class GoodsItem
{
    public GameObject gameObject;
    public Text nameText;
    public Text numText;
}

public class ResultItem {
    public GameObject gameObject;

    Text titleText;
    Text starText;

    Text goldText;
    Text expText;
    Text levelText;
    Image levelFontImage;
    Text levelPercentText;

    GoodsItem[] goods = new GoodsItem[5];

    public Earn m_earn;
    public int m_result;

    public void Init(Transform trans)
    {
        gameObject = trans.gameObject;

        titleText = trans.Find("title").GetComponent<Text>();
        starText = trans.Find("star").GetComponent<Text>();

        goldText = trans.Find("gift/gold").GetComponent<Text>();
        expText = trans.Find("gift/exp").GetComponent<Text>();
        levelText = trans.Find("gift/level").GetComponent<Text>();
        levelFontImage = trans.Find("gift/lvPercent/font").GetComponent<Image>();
        levelPercentText = trans.Find("gift/lvPercent/label").GetComponent<Text>();

        for(int i=0; i<goods.Length; i++)
        {
            GoodsItem item = new GoodsItem();
            item.gameObject = trans.Find("items/list/item" + (i + 1)).gameObject;
            item.nameText = item.gameObject.transform.Find("battleResultItem/label").GetComponent<Text>();
            item.numText = item.gameObject.transform.Find("battleResultItem/num").GetComponent<Text>();
            goods[i] = item;
        }
    }

    public void InitData(int result, Earn earn, int level, int exp, int levelUpExp)
    {
        m_result = result;
        m_earn = earn;

        if (m_result > 0)
        {
            titleText.text = "战斗胜利";

            if (m_result == 1)
            {
                starText.text = "星级评价:1星   (多余1名武将死亡)";
            }
            else if (m_result == 1)
            {
                starText.text = "星级评价:2星   (有1名武将死亡)";
            }
            else if (m_result == 1)
            {
                starText.text = "星级评价:3星   (没有武将死亡)";
            }
        }
        else
        {
            titleText.text = "战斗失败";
            starText.text = "星级评价:无";
        }

        goldText.text = "金币 " + m_earn.Gold;
        expText.text = "经验 " + m_earn.PlayerExp;
        levelText.text = "LV." + level;
        Debug.Log(exp + "  " + levelUpExp);
        float percent = (float)exp / levelUpExp;
        levelFontImage.fillAmount = percent;
        levelPercentText.text = string.Format("{0:F0}", percent * 100) + "%";

        for(int i=0; i< m_earn.ItemIds.Count; i++)
        {
            foreach(Item item in GameData.g_items)
            {
                if(item.Id+"" == m_earn.ItemIds[i])
                {
                    goods[i].nameText.text = item.Name;
                    goods[i].numText.text = "1";
                    goods[i].gameObject.SetActive(true);
                }
            }
        }
        for (int i= m_earn.ItemIds.Count; i<goods.Length; i++)
        {
            goods[i].gameObject.SetActive(false);
        }
    }
}
