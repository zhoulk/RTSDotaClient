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

public class NetWork : MonoBehaviour {

    NetworkManager networkManager;
    // Use this for initialization
    void Start () {
        networkManager = transform.GetComponent<NetworkManager>();
        networkManager.SendConnect();

        LoginRequest loginRequest = new LoginRequest();
        loginRequest.Account = "123";
        ByteBuffer buffer = new ByteBuffer();
        buffer.WriteBytes(loginRequest.ToByteArray());
        networkManager.SendMessage(buffer);
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
