using LuaFramework;
using LuaInterface;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using static UGUIEventListener;
using Component = UnityEngine.Component;

public static class Extensions
{
    #region Transform

    public static void SetPositionX(this Transform t, float newX)
    {
        t.position = new Vector3(newX, t.position.y, t.position.z);
    }

    public static void SetPositionY(this Transform t, float newY)
    {
        t.position = new Vector3(t.position.x, newY, t.position.z);
    }

    public static void SetPositionZ(this Transform t, float newZ)
    {
        t.position = new Vector3(t.position.x, t.position.y, newZ);
    }

    public static void SetLocalPositionX(this Transform t, float newX)
    {
        t.localPosition = new Vector3(newX, t.localPosition.y, t.localPosition.z);
    }

    public static void SetLocalPositionY(this Transform t, float newY)
    {
        t.localPosition = new Vector3(t.localPosition.x, newY, t.localPosition.z);
    }

    public static void SetLocalPositionZ(this Transform t, float newZ)
    {
        t.localPosition = new Vector3(t.localPosition.x, t.localPosition.y, newZ);
    }

    public static float GetPositionX(this Transform t)
    {
        return t.position.x;
    }

    public static float GetPositionY(this Transform t)
    {
        return t.position.y;
    }

    public static float GetPositionZ(this Transform t)
    {
        return t.position.z;
    }

    /// <summary>
    /// 自动 脚本 控制
    /// Gets or add a component. Usage example:
    /// BoxCollider boxCollider = transform.GetOrAddComponent<BoxCollider>();
    /// </summary>
    public static T GetOrAddComponent<T>(this Component child) where T : Component
    {
        T result = child.GetComponent<T>();
        if (result == null)
        {
            try
            {
                result = child.gameObject.AddComponent<T>();
            }
            catch (Exception exception)
            {
                Debug.LogWarning("GetOrAddComponent=" + exception);
            }
        }
        return result;
    }

    public static string GetPath(this Transform current)
    {
        if (current.parent == null)
            return "/" + current.name;
        return current.parent.GetPath() + "/" + current.name;
    }

    /// <summary>
    /// 转换成屏幕坐标
    /// </summary>
    /// <param name="myPos"></param>
    /// <returns></returns>
    public static Vector3 ToScreenPoint(this Vector3 myPos)
    {
        return Camera.main.WorldToScreenPoint(myPos);
    }

    public static Vector3 ToViewPortPoint(this Vector3 myPos)
    {
        return Camera.main.WorldToViewportPoint(myPos);
    }

    /// <summary>
    /// 由于层次的关系，世界z轴和spibling不匹配，改成更具z轴排序spibling
    /// </summary>
    /// <param name="rectTr"></param>
    public static void SortSpiblingByZ(this Transform rectTr)
    {
        List<Transform> tempChildren = new List<Transform>();

        foreach (Transform childTr in rectTr)
        {
            tempChildren.Add(childTr);
        }

        tempChildren.Sort(new Comparison<Transform>((transform1, transform2) =>
        {
            if (!transform1) return -1;
            if (!transform2) return 1;

            if (transform1.position.z > transform2.position.z)
            {
                return 1;
            }
            if (transform1.position.z == transform2.position.z)
            {
                return 0;
            }
            return -1;
        }));
        //z轴大的放在最后面，所以翻转一下
        tempChildren.Reverse();
        int i = 0;
        foreach (var tempChild in tempChildren)
        {
            tempChild.SetSiblingIndex(i++);
        }
    }

    /// <summary>
    /// ugui 重新按照z轴排序sibling，
    /// </summary>
    /// <param name="rectTr"></param>
    /// <param name="addChild"></param>
    public static void AddChildSiblingByZ(this Transform rectTr, Transform addChild)
    {
        addChild.SetParent(rectTr);
        rectTr.SortSpiblingByZ();
    }

    /// <summary>
    /// 新生成一个子RectTransform控件，ugui
    /// </summary>
    /// <param name="parentObj"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    public static GameObject AddRectChild(this Transform parentObj, string name = "gameObject")
    {
        GameObject go = new GameObject(name);
        go.AddComponent<RectTransform>();
        go.transform.SetParent(parentObj.transform);
        go.transform.ResetTr();
        return go;
    }

    /// <summary>
    /// 新生成一个子控件
    /// </summary>
    /// <param name="parentObj"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    public static GameObject AddChild(this Transform parentObj, string name = "gameObject")
    {
        GameObject go = new GameObject(name);
        go.transform.SetParent(parentObj);
        go.transform.ResetTr();
        return go;
    }

    public static GameObject AddChild(this Transform parentObj, GameObject childObj)
    {
        childObj.transform.SetParent(parentObj);
        childObj.transform.ResetTr();
        return childObj;
    }

    /// <summary>
    /// 自动生成一个添加
    /// </summary>
    /// <param name="parentObj"></param>
    /// <param name="prefabObj"></param>
    /// <returns></returns>
    public static GameObject AddChildPrefab(this Transform parentObj, GameObject prefabObj)
    {
        GameObject go = UnityEngine.Object.Instantiate(prefabObj, parentObj) as GameObject;
        go.transform.ResetTr();
        go.SetActive(true);
        return go;
    }

    /// <summary>
    /// 快速删除全部子空间
    /// </summary>
    /// <param name="parentObj"></param>
    public static void RemoveAllChild(this Transform tr)
    {
        List<GameObject> tempList = new List<GameObject>();

        for (int i = 0; i < tr.transform.childCount; i++)
        {
            tempList.Add(tr.GetChild(i).gameObject);
        }
        tr.DetachChildren();
        foreach (GameObject obj in tempList)
        {
            UnityEngine.Object.Destroy(obj);
        }
    }

    /// <summary>
    /// 快速删除全部子空间
    /// </summary>
    /// <param name="parentObj"></param>
    public static void RemoveAllChildExcept(this Transform tr, string exceptObjName)
    {
        List<GameObject> tempList = new List<GameObject>();

        for (int i = 0; i < tr.transform.childCount; i++)
        {
            Transform obj = tr.GetChild(i);
            if (obj.name != exceptObjName)
                tempList.Add(obj.gameObject);
        }
        //tr.DetachChildren();
        foreach (GameObject obj in tempList)
        {
            UnityEngine.Object.Destroy(obj);
        }
    }

    /// <summary>
    /// 重新设置值为默认
    /// </summary>
    /// <param name="trans"></param>
    public static void ResetTr(this Transform trans)
    {
        trans.localPosition = Vector3.zero;
        trans.localRotation = new Quaternion(0, 0, 0, 0);
        trans.localScale = Vector3.one;
    }

    /// <summary>
    /// 根据z轴排序depth
    /// </summary>
    /// <param name="myTr"></param>
    /// <param name="parentTr"></param>
    public static void SetParentSiblingByZ(this Transform myTr, Transform parentTr)
    {
        myTr.SetParent(parentTr);
        parentTr.SortSpiblingByZ();
    }

    /// <summary>
    /// Deep search the heirarchy of the specified transform for the name. Uses width-first search.
    /// 深度搜索子控件
    /// </summary>
    /// <param name="t"></param>
    /// <param name="name"></param>
    /// <returns></returns>
    static public Transform FindChildDeepSearch(this Transform t, string name)
    {
        Transform dt = t.Find(name);
        if (dt != null)
        {
            return dt;
        }

        foreach (Transform child in t)
        {
            dt = child.FindChildDeepSearch(name);
            if (dt != null)
                return dt;
        }
        return null;
    }

    /// <summary>
    /// 主要在ui界面注册点击事件,并只能点击一次
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetOnClick(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDragStart(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onDragStart = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDragEnd(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onDragEnd = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDrag(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onDrag = (evt, go, delta, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, delta, args);
                //callback = null;
            }
        };
    }

    /// <summary>
    /// 主要用于UI界面的双击事件，并只有效一次回调
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetOnDoubleClick(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onDoubleClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    /// <summary>
    /// 针对lua进行的优化，避免gameObject.transform 操作过多
    /// </summary>
    /// <param name="obj"></param>
    /// <returns></returns>
    public static Transform GetTransform(this Component obj) {
        if (obj == null) return null;
        return obj.transform;
    }

    public static Transform GetTransform(this GameObject obj)
    {
        if (obj == null) return null;
        return obj.transform;
    }

    public static void SetPosition(this GameObject obj, float x, float y, float z) {
        if (obj)
        {
            obj.transform.position = new Vector3(x, y, z);
        }
        else {
            Debug.LogError("null obj!");
        }
    }

    public static void SetLocalPosition(this GameObject obj, float x, float y, float z)
    {
        if (obj)
        {
            obj.transform.localPosition = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("null obj!");
        }
    }

    public static void SetPosition(this Component obj, float x, float y, float z)
    {
        if (obj)
        {
            obj.transform.position = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("null obj!");
        }
    }

    public static void SetLocalPosition(this Component obj, float x, float y, float z)
    {
        if (obj)
        {
            obj.transform.localPosition = new Vector3(x, y, z);
        }
        else
        {
            Debug.LogError("null obj!");
        }
    }

    #endregion Transform

    #region GameObject

    public static bool HasRigidbody(this GameObject gobj)
    {
        return (gobj.GetComponent<Rigidbody>() != null);
    }

    public static bool HasAnimation(this GameObject gobj)
    {
        return (gobj.GetComponent<Animation>() != null);
    }

    /// <summary>
    /// 主要在ui界面注册点击事件,并只能点击一次
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetOnClick(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnHover(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onHover = (evt, go, state, my_args) =>
        {
            if (callback != null)
            {
                if (state)
                {
                    //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                }
                callback.Call(obj, evt, go, state, args);
                //callback = null;
            }
        };
    }

    public static void SetOnPress(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onPress = (evt, go, state, my_args) =>
        {
            if (callback != null)
            {
                if (state)
                {
                    //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                }
                callback.Call(obj, evt, go, state, args);
                //callback = null;
            }
        };
    }

    /// <summary>
    /// 主要在ui界面注册点击事件,并只能点击一次
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void Set3DOnClick(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }


    public static void SetOnDragStart(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDragStart = (evt, go,  my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDragStart(this GameObject obj, VoidDelegate callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDragStart = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback(evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDrag(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDrag = (evt, go, data, my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, data, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDrag(this GameObject obj, VectorDelegate callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDrag = (evt, go, data, my_args) =>
        {
            if (callback != null)
            {
                callback(evt, go, data, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDragEnd(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDragEnd = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetOnDragEnd(this GameObject obj, VoidDelegate callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDragEnd = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback(evt, go, args);
                //callback = null;
            }
        };
    }

    public static void RemoveUGUIEventListener(this GameObject obj)
    {
        UGUIEventListener.Remove(obj);
    }

    /// <summary>
    /// 长按2秒事件
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetLongPress(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onLongPress = (evt, go, isPress, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    public static void SetLongPress(this Component obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj.gameObject).onLongPress = (evt, go, isPress, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    /// <summary>
    /// 添加一次点击事件
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetOneClick(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                callback.Call(obj, evt, go, args);
                callback = null;
            }
        };
    }

    /// <summary>
    /// 主要用于UI界面的双击事件，并只有效一次回调
    /// </summary>
    /// <param name="obj"></param>
    /// <param name="callback"></param>
    /// <param name="args"></param>
    public static void SetOnDoubleClick(this GameObject obj, LuaFunction callback, object args = null)
    {
        UGUIEventListener.Get(obj).onDoubleClick = (evt, go, my_args) =>
        {
            if (callback != null)
            {
                //LuaHelper.GetSoundManager().PlaySound("Shared", "anniu1", ViewHelper.Instance.UICamera.transform.position, 1);
                callback.Call(obj, evt, go, args);
                //callback = null;
            }
        };
    }

    /// <summary>
    /// 自动 脚本 控制
    /// Gets or add a component. Usage example:
    /// BoxCollider boxCollider = transform.GetOrAddComponent<BoxCollider>();
    /// </summary>
    public static T GetOrAddComponent<T>(this GameObject child) where T : Component
    {
        T result = child.GetComponent<T>();
        if (result == null)
        {
            try
            {
                result = child.gameObject.AddComponent<T>();
            }
            catch (Exception exception)
            {
                Debug.LogWarning("GetOrAddComponent=" + exception);
            }
        }
        return result;
    }

    #endregion GameObject

    #region Animation

    public static void SetSpeed(this Animation anim, float newSpeed)
    {
        anim[anim.clip.name].speed = newSpeed;
    }

    /// <summary>
    /// Get Fullpath string
    /// </summary>
    /// <param name="component"></param>
    /// <returns></returns>
    public static string GetPath(this Component component)
    {
        return component.transform.GetPath() + "/" + component.GetType().ToString();
    }

    #endregion Animation

    #region Enum

    /// <summary>
    /// 字符转换成Enum类型
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="theEnum"></param>
    /// <param name="valueToParse"></param>
    /// <param name="returnValue"></param>
    /// <returns></returns>
    public static bool TryParse<T>(this Enum theEnum, string valueToParse, out T returnValue)
    {
        returnValue = default(T);
        if (Enum.IsDefined(typeof(T), valueToParse))
        {
            TypeConverter converter = TypeDescriptor.GetConverter(typeof(T));
            returnValue = (T)converter.ConvertFromString(valueToParse);
            return true;
        }
        return false;
    }

    #endregion Enum

    #region string

    /// <summary>
    /// 自动换行
    /// </summary>
    /// <param name="content"></param>
    /// <param name="count"></param>
    /// <returns></returns>
    public static string SplitAutoReline(this string content, int count)
    {
        int len = content.Length / count + 1;
        System.Text.StringBuilder strBd = new System.Text.StringBuilder();
        int strLen = content.Length;
        for (int i = 0; i < len; i++)
        {
            int startIndex = i * count;
            if (startIndex + count > strLen)
            {
                count = strLen - startIndex;
            }
            if (i == len - 1)
                strBd.Append(content.Substring(startIndex, count));
            else
                strBd.AppendLine(content.Substring(startIndex, count));
        }
        return strBd.ToString();
    }

    /// <summary>
    /// 立马自动换行
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static string Reline(this string content)
    {
        return new StringBuilder(content).AppendLine("").ToString();
    }

    /// <summary>
    /// 快速换行连接字符
    /// </summary>
    /// <param name="content"></param>
    /// <param name="msg"></param>
    /// <returns></returns>
    public static string AppendLine(this string content, string msg)
    {
        if (string.IsNullOrEmpty(content))
            return msg;
        else
            return new StringBuilder(content).AppendLine(msg).ToString();
    }

    /// <summary>
    /// 在限定长度以内自动溢出，保留新添加的字符串
    /// </summary>
    /// <param name="str"></param>
    /// <param name="msg"></param>
    /// <param name="lenLimitCount"></param>
    /// <returns></returns>
    public static string AppendLineAutoOut(this string str, string msg, int lenLimitCount)
    {
        str = str.AppendLine(msg);
        int len = str.Length;
        if (len > lenLimitCount)
        {
            str = str.Substring(len - lenLimitCount);
        }
        return str;
    }

    public static string AppendColorLine(this string content, string msg)
    {
        //UnityRandom ran = new UnityRandom();
        //return AppendLine(content, NGUIText.EncodeColor(msg, ran.Rainbow()));
        return AppendLine(content, msg);
    }

    /// <summary>
    /// 字符串替换方法
    /// </summary>
    /// <param name="myStr">需要替换的字符串</param>
    /// <param name="displaceA">需要替换的字符</param>
    /// <param name="displaceB">将替换为</param>
    /// <returns></returns>
    public static string displace(this string myStr, string displaceA, string displaceB)
    {
        string[] strArrayA = Regex.Split(myStr, displaceA);
        for (int i = 0; i < strArrayA.Length - 1; i++)
        {
            strArrayA[i] += displaceB;
        }
        string returnStr = "";
        foreach (string var in strArrayA)
        {
            returnStr += var;
        }
        return returnStr;
    }

    //static public string EncodeColor(string text, Color c) { return "[c][" + EncodeColor24(c) + "]" + text + "[-][/c]"; }

    /// <summary>
    /// 转换成整数型
    /// </summary>
    /// <param name="content"></param>
    /// <returns></returns>
    public static int ToInt32(this string content)
    {
        return int.Parse(content);
    }

    /// <summary>
    /// 在C#里，String.Contains是大小写敏感的，所以如果要在C#里用String.
    /// Contains来判断一个string里是否包含一个某个关键字keyword，
    /// 需要把这个string和这个keyword都转成小写再调用contains，效率较低。
    ///比较好的一个方法是用String.Index()方法，然后通过StringComparison.OrdinalIgnoreCase指定查找过程忽略大小写
    /// </summary>
    /// <param name="source"></param>
    /// <param name="toCheck"></param>
    /// <param name="comp"></param>
    /// <returns></returns>
    public static bool ContainsIgnoreCase(this string source, string toCheck, StringComparison comp = StringComparison.OrdinalIgnoreCase)
    {
        return source.IndexOf(toCheck, comp) >= 0;
    }

    /// <summary>
    /// Insert the specified character into the string every n characters
    /// 等比插入制定字符
    /// </summary>
    /// <param name="input"></param>
    /// <param name="insertCharacter"></param>
    /// <param name="n"></param>
    /// <param name="charsInserted"></param>
    /// <returns></returns>
    public static string InsertCharEveryNChars(this string input, char insertCharacter, int n, out int charsInserted)
    {
        charsInserted = 0;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < input.Length; i++)
        {
            if (i % n == 0)
            {
                sb.Append(insertCharacter);
                ++charsInserted;
            }
            if (input[i] == insertCharacter)
                ++charsInserted;
            sb.Append(input[i]);
        }
        return sb.ToString();
    }

    #endregion string

    #region Collection

    /// <summary>
    /// 快速转换成数组
    /// </summary>
    /// <param name="keys"></param>
    /// <returns></returns>
    public static ArrayList ToArrayList(this ICollection keys)
    {
        return new ArrayList(keys);
    }

    /// <summary>
    /// 数组拷贝一份
    /// </summary>
    /// <param name="keys"></param>
    /// <returns></returns>
    public static List<T> ToListCopy<T>(this ICollection<T> keys)
    {
        return new List<T>(keys);
    }

    /// <summary>
    /// 列表模拟队列进入
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="RunQueue"></param>
    /// <returns></returns>
    public static void Enqueue<T>(this List<T> list, T t)
    {
        list.Insert(list.Count, t);
    }

    /// <summary>
    /// 列表模拟队列出队列
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="list"></param>
    /// <returns></returns>
    public static T Dequeue<T>(this List<T> list)
    {
        T t = list[0];
        list.RemoveAt(0);
        return t;
    }

    public static T Peek<T>(this List<T> list)
    {
        T t = list[0];
        return t;
    }

    /// <summary>
    /// 替换或者添加,或者修改一个值
    /// </summary>
    public static Dictionary<TKey, TValue> ForceAddValue<TKey, TValue>(this Dictionary<TKey, TValue> dict, TKey key, TValue value)
    {
        if (dict.ContainsKey(key))
        {
            dict[key] = value;
        }
        else
        {
            dict.Add(key, value);
        }
        return dict;
    }

    #endregion Collection

    #region Render

    /// <summary>
    /// 在指定camera中是否在渲染，判断可见性
    /// </summary>
    /// <param name="renderer"></param>
    /// <param name="camera"></param>
    /// <returns></returns>
    public static bool IsVisibleFrom(this Renderer renderer, Camera camera)
    {
        Plane[] planes = GeometryUtility.CalculateFrustumPlanes(camera);
        return GeometryUtility.TestPlanesAABB(planes, renderer.bounds);
    }

    #endregion Render

    #region LayerMask

    public static LayerMask Create(params string[] layerNames)
    {
        return NamesToMask(layerNames);
    }

    public static LayerMask Create(params int[] layerNumbers)
    {
        return LayerNumbersToMask(layerNumbers);
    }

    public static LayerMask NamesToMask(params string[] layerNames)
    {
        LayerMask ret = (LayerMask)0;
        foreach (var name in layerNames)
        {
            ret |= (1 << LayerMask.NameToLayer(name));
        }
        return ret;
    }

    public static LayerMask LayerNumbersToMask(params int[] layerNumbers)
    {
        LayerMask ret = (LayerMask)0;
        foreach (var layer in layerNumbers)
        {
            ret |= (1 << layer);
        }
        return ret;
    }

    public static LayerMask Inverse(this LayerMask original)
    {
        return ~original;
    }

    public static LayerMask AddToMask(this LayerMask original, params string[] layerNames)
    {
        return original | NamesToMask(layerNames);
    }

    public static LayerMask RemoveFromMask(this LayerMask original, params string[] layerNames)
    {
        LayerMask invertedOriginal = ~original;
        return ~(invertedOriginal | NamesToMask(layerNames));
    }

    public static string[] MaskToNames(this LayerMask original)
    {
        var output = new List<string>();

        for (int i = 0; i < 32; ++i)
        {
            int shifted = 1 << i;
            if ((original & shifted) == shifted)
            {
                string layerName = LayerMask.LayerToName(i);
                if (!string.IsNullOrEmpty(layerName))
                {
                    output.Add(layerName);
                }
            }
        }
        return output.ToArray();
    }

    public static string MaskToString(this LayerMask original)
    {
        return MaskToString(original, ", ");
    }

    public static string MaskToString(this LayerMask original, string delimiter)
    {
        return string.Join(delimiter, MaskToNames(original));
    }

    #endregion LayerMask

    #region Quaternion

    /// <summary>
    /// 指定幂运算
    /// To use these methods, simply append them to a given Quaternion.
    /// rotate the gameObject by rotateOffset's local rotation once per second.
    /// transform.rotation = rotateOffset.localRotation.Pow(Time.time);
    ///quaternion.Exp() - returns euler's number raised to quaternion
    ///quaternion.Magnitude() - returns the float magnitude of quaternion
    ///quaternion.ScalarMultipy(float scalar) - returns quaternion multiplied by scalar
    ///quaternion.Pow(float pow) - returns quaternion raised to the power pow.This is useful for smoothly multiplying a Quaternion by a given floating-point value.
    /// </summary>
    /// <param name="input"></param>
    /// <param name="power"></param>
    /// <returns></returns>
    public static Quaternion Pow(this Quaternion input, float power)
    {
        float inputMagnitude = input.Magnitude();
        Vector3 nHat = new Vector3(input.x, input.y, input.z).normalized;
        Quaternion vectorBit = new Quaternion(nHat.x, nHat.y, nHat.z, 0)
            .ScalarMultiply(power * Mathf.Acos(input.w / inputMagnitude))
                .Exp();
        return vectorBit.ScalarMultiply(Mathf.Pow(inputMagnitude, power));
    }

    /// <summary>
    /// 指数运算 数字 e 的 d 次幂
    /// </summary>
    /// <param name="input"></param>
    /// <returns></returns>
    public static Quaternion Exp(this Quaternion input)
    {
        float inputA = input.w;
        Vector3 inputV = new Vector3(input.x, input.y, input.z);
        float outputA = Mathf.Exp(inputA) * Mathf.Cos(inputV.magnitude);
        Vector3 outputV = Mathf.Exp(inputA) * (inputV.normalized * Mathf.Sin(inputV.magnitude));
        return new Quaternion(outputV.x, outputV.y, outputV.z, outputA);
    }

    public static float Magnitude(this Quaternion input)
    {
        return Mathf.Sqrt(input.x * input.x + input.y * input.y + input.z * input.z + input.w * input.w);
    }

    public static Quaternion ScalarMultiply(this Quaternion input, float scalar)
    {
        return new Quaternion(input.x * scalar, input.y * scalar, input.z * scalar, input.w * scalar);
    }

    #endregion Quaternion
}