--Buildin Table
Protocal = {
	Connect		= '11';	--连接服务器
	Exception   = '12';	--异常掉线
	Disconnect  = '13';	--正常断线   
	Message		= '14';	--接收消息
}

local _msgInfo = {}

function Protocal.Registe(key, requestName)
	_msgInfo[requestName] = key
end

function Protocal.KeyOf(requestName)
	return _msgInfo[requestName]
end