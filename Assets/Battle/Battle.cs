//===================================================
//作    者：周连康 
//创建时间：2019-04-02 17:19:02
//备    注：
//===================================================

using LuaFramework;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace Battle
{
    public class Battle : MonoBehaviour
    {
        BattleLogic battleLogic = new BattleLogic();

        private void Awake()
        {
            UnityTools.Log("battle Awake");

            GameData.g_battleId = "1234567890";
            AppConst.SocketAddress = "127.0.0.1";
            AppConst.SocketPort = 7000;
            UnityTools.Log("battleId ==== " + GameData.g_battleId);

            GameData.g_netManager = transform.GetComponent<NetManager>();
            GameData.g_battleView = GameObject.Find("Canvas/BattleView").transform.GetComponent<BattleView>();
            GameData.g_battleLogic = battleLogic;
            UnityTools.Log(GameData.g_battleView);
        }

        // Use this for initialization
        void Start()
        {
#if _CLIENTLOGIC_
            battleLogic.init();
            //battleLogic.startBattle();
#else
            GameData.g_uGameLogicFrame = 0;
            GameData.g_bRplayMode = true;
            battleLogic.init();
            battleLogic.updateLogic();
#endif
        }

        // Update is called once per frame
        void Update()
        {
#if _CLIENTLOGIC_
        battleLogic.updateLogic();
#endif
        }
    }
}
