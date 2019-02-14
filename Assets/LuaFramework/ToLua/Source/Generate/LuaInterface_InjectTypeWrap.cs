//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaInterface_InjectTypeWrap
{
	public static void Register(LuaState L)
	{
		L.BeginEnum(typeof(LuaInterface.InjectType));
		L.RegVar("None", get_None, null);
		L.RegVar("After", get_After, null);
		L.RegVar("Before", get_Before, null);
		L.RegVar("Replace", get_Replace, null);
		L.RegVar("ReplaceWithPreInvokeBase", get_ReplaceWithPreInvokeBase, null);
		L.RegVar("ReplaceWithPostInvokeBase", get_ReplaceWithPostInvokeBase, null);
		L.RegFunction("IntToEnum", IntToEnum);
		L.EndEnum();
		TypeTraits<LuaInterface.InjectType>.Check = CheckType;
		StackTraits<LuaInterface.InjectType>.Push = Push;
	}

	static void Push(IntPtr L, LuaInterface.InjectType arg)
	{
		ToLua.Push(L, arg);
	}

	static bool CheckType(IntPtr L, int pos)
	{
		return TypeChecker.CheckEnumType(typeof(LuaInterface.InjectType), L, pos);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_None(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.None);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_After(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.After);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Before(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.Before);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Replace(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.Replace);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ReplaceWithPreInvokeBase(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.ReplaceWithPreInvokeBase);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ReplaceWithPostInvokeBase(IntPtr L)
	{
		ToLua.Push(L, LuaInterface.InjectType.ReplaceWithPostInvokeBase);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IntToEnum(IntPtr L)
	{
		int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
		LuaInterface.InjectType o = (LuaInterface.InjectType)arg0;
		ToLua.Push(L, o);
		return 1;
	}
}

