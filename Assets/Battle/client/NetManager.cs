//===================================================
//作    者：周连康 
//创建时间：2019-04-02 20:42:45
//备    注：
//===================================================

using Google.Protobuf;
using LuaFramework;
using Msg;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetManager : MonoBehaviour {

    NetworkManager networkManager;
    // Use this for initialization
    void Start () {
        AppFacade.Instance.RegisterCommand(NotiConst.DISPATCH_MESSAGE, typeof(CSSocketCommand));

        networkManager = AppFacade.Instance.GetManager<NetworkManager>(ManagerName.Network);

        //networkManager.SendConnect();
        loadData();
    }

    public void SendRecord()
    {
        BattleResultRequest battleResultRequest = new BattleResultRequest();
        battleResultRequest.BattleId = GameData.g_battleId;
        battleResultRequest.Result = 1;
        ByteBuffer buffer = new ByteBuffer();
        buffer.WriteShort(134);
        buffer.WriteBytes(battleResultRequest.ToByteArray());
        networkManager.SendMessage(buffer);
    }

    void loadData()
    {
        BattleStartRequest battleStartRequest = new BattleStartRequest();
        battleStartRequest.BattleId = GameData.g_battleId;
        ByteBuffer buffer = new ByteBuffer();
        buffer.WriteShort(132);
        buffer.WriteBytes(battleStartRequest.ToByteArray());
        networkManager.SendMessage(buffer);

        SkillRequest skillRequest = new SkillRequest();
        ByteBuffer skillBuffer = new ByteBuffer();
        skillBuffer.WriteShort(110);
        skillBuffer.WriteBytes(skillRequest.ToByteArray());
        networkManager.SendMessage(skillBuffer);

        ItemRequest itemRequest = new ItemRequest();
        ByteBuffer itemBuffer = new ByteBuffer();
        itemBuffer.WriteShort(112);
        itemBuffer.WriteBytes(itemRequest.ToByteArray());
        networkManager.SendMessage(itemBuffer);
    }

    public void OnSocket(int key, ByteBuffer byteBuffer)
    {
        UnityTools.Log(key);
        if(key == 11)
        {
            loadData();
        }
        else if(key == 133)
        {
            byteBuffer.ReadShort();
            BattleStartResponse battleStartResponse = new BattleStartResponse();
            battleStartResponse.MergeFrom(byteBuffer.ReadBytes());
            foreach(var hero in battleStartResponse.Heros)
            {
                UnityTools.Log(hero.ToString());
            }
            GameData.g_battleView.InitHeros(battleStartResponse.Heros.ToArrayList());
        }
        else if (key == 135)
        {
            byteBuffer.ReadShort();
            BattleResultResponse battleResultResponse = new BattleResultResponse();
            battleResultResponse.MergeFrom(byteBuffer.ReadBytes());
            UnityTools.Log(battleResultResponse.Earn);

            GameData.g_battleView.ShowResult(battleResultResponse.Earn);
        }
        else if (key == 111)
        {
            byteBuffer.ReadShort();
            SkillResponse skillResponse = new SkillResponse();
            skillResponse.MergeFrom(byteBuffer.ReadBytes());
            foreach (var skill in skillResponse.Skills)
            {
                UnityTools.Log(skill.ToString());
            }
            GameData.g_battleView.InitSkills(skillResponse.Skills.ToArrayList());
        }
        else if (key == 113)
        {
            byteBuffer.ReadShort();
            ItemResponse itemResponse = new ItemResponse();
            itemResponse.MergeFrom(byteBuffer.ReadBytes());
            foreach (var item in itemResponse.Items)
            {
                UnityTools.Log(item.ToString());
            }
            GameData.g_battleView.InitItems(itemResponse.Items.ToArrayList());
        }
    }

    // Update is called once per frame
    void Update () {
		
	}

    private void OnDestroy()
    {
        //AppFacade.Instance.RemoveCommand(NotiConst.DISPATCH_MESSAGE);
        AppFacade.Instance.RegisterCommand(NotiConst.DISPATCH_MESSAGE, typeof(SocketCommand));
    }
}

public class CSSocketCommand : ControllerCommand
{
    public override void Execute(IMessage message)
    {
        object data = message.Body;
        if (data == null) return;
        KeyValuePair<int, ByteBuffer> buffer = (KeyValuePair<int, ByteBuffer>)data;
        switch (buffer.Key)
        {
            default:
                GameData.g_netManager.OnSocket(buffer.Key, buffer.Value);
                break;
        }
    }
}
