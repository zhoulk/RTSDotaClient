using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class UGUIEventListener : MonoBehaviour, IEventSystemHandler,
    IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler,
    IPointerUpHandler, IPointerClickHandler, IBeginDragHandler,
    IInitializePotentialDragHandler, IDragHandler,
    IEndDragHandler, IDropHandler, IScrollHandler,
    IUpdateSelectedHandler, ISelectHandler,
    IDeselectHandler, IMoveHandler,
    ISubmitHandler, ICancelHandler{
    // 可点击的按钮路径，如果为空则全部可点击
    private static List<string> _allowedClicks = new List<string>();

    private static Dictionary<string, object[]> _eventArgs = new Dictionary<string, object[]>();

    #region 注册参数处理

    public void SetEventArgs(params object[] eventArgs)
    {
        _eventArgs[transform.GetPath()] = eventArgs;
    }

    private object[] getEventArgs()
    {
        object[] tempArgs = null;
        _eventArgs.TryGetValue(transform.GetPath(), out tempArgs);
        return tempArgs;
    }

    #endregion 注册参数处理

    #region 可点击事件管理

    /// <summary>
    /// 有限的点击事件处理，列表点击按钮的绝对路径
    /// </summary>
    /// <param name="clicks"></param>
    public static void AddAllowEvent(List<string> clicks)
    {
        _allowedClicks = clicks;
    }

    /// <summary>
    /// 允许某个可点击，其他全部不可以点击，直到清除点击
    /// </summary>
    /// <param name="tr"></param>
    public static void AddAllowObj(Transform tr)
    {
        _allowedClicks.Add(tr.GetPath());
    }

    /// <summary>
    /// 清除某个点击事件
    /// </summary>
    /// <param name="tr"></param>
    public static void ClearAllowObj(Transform tr)
    {
        string path = tr.GetPath();
        if (_allowedClicks.Count > 0 && _allowedClicks.Contains(path))
            _allowedClicks.Remove(path);
    }

    /// <summary>
    /// 清除所有点击事件
    /// </summary>
    public static void ClearAllowEvent()
    {
        _allowedClicks.Clear();
    }

    private static bool IsAllowedMe(GameObject gameObject)
    {
        string fullPath = gameObject.transform.GetPath();
        if (string.IsNullOrEmpty(fullPath)) return false;
        if (_allowedClicks.Count != 0 && !_allowedClicks.Contains(fullPath)) return true;
        return false;
    }

    private static bool IsForbid()
    {
        return _allowedClicks.Count != 0;
    }

    #endregion 可点击事件管理

    #region 代理定义

    public delegate void UGUIEventObjectDelegate(PointerEventData eventData, GameObject targetObj, params object[] eventArgs);

    public delegate void UGUIEventBaseDelegate(BaseEventData eventData, GameObject targetObj, params object[] eventArgs);

    public delegate void VoidDelegate(BaseEventData go, GameObject targetObj, params object[] eventArgs);

    public delegate void BoolDelegate(BaseEventData go, GameObject targetObj, bool state, params object[] eventArgs);

    public delegate void FloatDelegate(PointerEventData go, GameObject targetObj, float delta, params object[] eventArgs);

    public delegate void VectorDelegate(PointerEventData go, GameObject targetObj, Vector2 delta, params object[] eventArgs);

    public delegate void ObjectDelegate(PointerEventData go, GameObject targetObj, GameObject obj, params object[] eventArgs);

    public delegate void KeyCodeDelegate(PointerEventData go, GameObject targetObj, KeyCode key, params object[] eventArgs);

    public object Parameter;

    public UGUIEventListener.VoidDelegate onSubmit;
    public UGUIEventListener.VoidDelegate onClick;
    public UGUIEventListener.VoidDelegate onDoubleClick;
    public UGUIEventListener.BoolDelegate onHover;
    public UGUIEventListener.BoolDelegate onPress;
    public UGUIEventListener.BoolDelegate onLongPress;
    public UGUIEventListener.BoolDelegate onSelect;
    public UGUIEventListener.VectorDelegate onScroll;
    public UGUIEventListener.VoidDelegate onDragStart;
    public UGUIEventListener.VectorDelegate onDrag;
    public UGUIEventListener.VoidDelegate onDragOver;
    public UGUIEventListener.VoidDelegate onDragOut;
    public UGUIEventListener.VoidDelegate onDragEnd;
    public UGUIEventListener.ObjectDelegate onDrop;
    public UGUIEventListener.KeyCodeDelegate onKey;
    public UGUIEventListener.BoolDelegate onTooltip;
    public UGUIEventObjectDelegate onInitializePotentialDrag;
    public UGUIEventBaseDelegate onUpdateSelected;
    public UGUIEventBaseDelegate onCancel;

    #endregion 代理定义

    /// <summary>
    /// 添加UI事件管理，用SetEventArgs,传递参数
    /// </summary>
    /// <param name="go"></param>
    /// <returns></returns>
    static public UGUIEventListener Get(GameObject go, bool isRegistCmdMsg = true)
    {
        UGUIEventListener listener = go.GetComponent<UGUIEventListener>();
        if (listener == null) listener = go.AddComponent<UGUIEventListener>();
        listener.enabled = true;

        if (isRegistCmdMsg)
        {
            listener.AutoRegistCMDEvent();
        }

        return listener;
    }

    static public void Remove(GameObject go)
    {
        UGUIEventListener listener = go.GetComponent<UGUIEventListener>();
        if (listener)
        {
            listener.enabled = false;
        }
    }

    #region 自动事件触发系统

    public static void HandleEventToObj(GameObject gameObject)
    {
        if (ExecuteEvents.CanHandleEvent<IBeginDragHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.beginDragHandler);
        if (ExecuteEvents.CanHandleEvent<ICancelHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.cancelHandler);
        if (ExecuteEvents.CanHandleEvent<IDeselectHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.deselectHandler);
        if (ExecuteEvents.CanHandleEvent<IDragHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.dragHandler);
        if (ExecuteEvents.CanHandleEvent<IDropHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.dropHandler);
        if (ExecuteEvents.CanHandleEvent<IEndDragHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.endDragHandler);
        if (ExecuteEvents.CanHandleEvent<IInitializePotentialDragHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.initializePotentialDrag);
        ////if (ExecuteEvents.CanHandleEvent<IMoveHandler>(gameObject))
        ////    ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.moveHandler);
        if (ExecuteEvents.CanHandleEvent<IPointerClickHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.pointerClickHandler);
        if (ExecuteEvents.CanHandleEvent<IPointerDownHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.pointerDownHandler);
        if (ExecuteEvents.CanHandleEvent<IPointerEnterHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.pointerEnterHandler);
        if (ExecuteEvents.CanHandleEvent<IPointerExitHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.pointerExitHandler);
        if (ExecuteEvents.CanHandleEvent<IPointerUpHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.pointerUpHandler);
        if (ExecuteEvents.CanHandleEvent<IScrollHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.scrollHandler);
        if (ExecuteEvents.CanHandleEvent<ISelectHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.selectHandler);
        if (ExecuteEvents.CanHandleEvent<ISubmitHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.submitHandler);
        if (ExecuteEvents.CanHandleEvent<IUpdateSelectedHandler>(gameObject))
            ExecuteEvents.Execute(gameObject, new PointerEventData(EventSystem.current), ExecuteEvents.updateSelectedHandler);
    }

    #endregion 自动事件触发系统

    /// <summary>
    /// 自动注册命令事件
    /// </summary>
    public void AutoRegistCMDEvent()
    {
        //VShaMenuMsgKit.addObserver(gameObject.GetInstanceID(), this);
    }

    /// <summary>
    /// 发送点击事件消息
    /// </summary>
    public void PostCmdMsg()
    {
        Debug.Log("Menu: " + gameObject.name);
        HandleEventToObj(gameObject);
    }

    #region mono函数

    private void OnDestroy()
    {
        //VShaMenuMsgKit.removeObserver(gameObject.GetInstanceID());
    }

    #endregion mono函数

    #region UGUI事件实现接口

    public void OnPointerClick(PointerEventData eventData)
    {
        //if (eventData == null || !eventData.selectedObject) return;
        //Debug.Log("Click" + eventData.selectedObject.name);
        if (onClick != null)
        {
            if (!IsForbid())
            {
                onClick(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onClick(eventData, gameObject, getEventArgs());
            }
        }
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        //if (eventData == null) return;
        //VSUIBtnAnim.DoBTNHoverAnimation(gameObject, true);
        if (onHover != null)
        {
            if (!IsForbid())
            {
                onHover(eventData, gameObject, true, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onHover(eventData, gameObject, true, getEventArgs());
            }
        }
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        //if (eventData == null) return;
        //VSUIBtnAnim.DoBTNHoverAnimation(gameObject, false);
        if (onHover != null)
        {
            if (!IsForbid())
            {
                onHover(eventData, gameObject, false, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onHover(eventData, gameObject, false, getEventArgs());
            }
        }
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        //if (eventData == null) return;
        //VSUIBtnAnim.DoBTNHoverAnimation(gameObject, true);
        if (onPress != null)
        {
            if (!IsForbid())
            {
                onPress(eventData, gameObject, true, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onPress(eventData, gameObject, true, getEventArgs());
            }
        }

        if (onLongPress != null) {
            if (!IsForbid())
            {
                if (!IsInvoking("OnLongPress"))
                {
                    Invoke("OnLongPress", 2f);
                    longPressBean = new LongPressBean(eventData, getEventArgs());
                }

            }
            else if (IsAllowedMe(gameObject))
            {
                if (!IsInvoking("OnLongPress"))
                {
                    Invoke("OnLongPress", 2f);
                    longPressBean = new LongPressBean(eventData, getEventArgs());
                }
            }
        }
    }

    LongPressBean longPressBean;
    public void OnLongPress() {
        if (longPressBean != null) {
            onLongPress(longPressBean.eventData, gameObject, true, longPressBean.args);
        }
        longPressBean = null;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        //if (eventData == null) return;
        if (onPress != null)
        {
            if (!IsForbid())
            {
                onPress(eventData, gameObject, false, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onPress(eventData, gameObject, false, getEventArgs());
            }
        }

        if (onLongPress != null)
        {
            if (!IsForbid())
            {
                if (IsInvoking("OnLongPress"))
                {
                    CancelInvoke("OnLongPress");
                    longPressBean = null;
                }

            }
            else if (IsAllowedMe(gameObject))
            {
                if (IsInvoking("OnLongPress"))
                {
                    CancelInvoke("OnLongPress");
                    longPressBean = null;
                }
            }
        }
    }

    public void OnBeginDrag(PointerEventData eventData)
    {
        //if (eventData == null) return;
        if (onDragStart != null)
        {
            if (!IsForbid())
            {
                onDragStart(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onDragStart(eventData, gameObject, getEventArgs());
            }
        }
    }

    public void OnInitializePotentialDrag(PointerEventData eventData)
    {
        if (onInitializePotentialDrag != null)
        {
            if (!IsForbid())
            {
                onInitializePotentialDrag(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onInitializePotentialDrag(eventData, gameObject, getEventArgs());
            }
        }
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (eventData == null) return;
        if (onDrag != null)
        {
            if (!IsForbid())
            {
                onDrag(eventData, gameObject, eventData.delta, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onDrag(eventData, gameObject, eventData.delta, getEventArgs());
            }
        }
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        //if (eventData == null) return;
        if (onDragEnd != null)
        {
            if (!IsForbid())
            {
                onDragEnd(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onDragEnd(eventData, gameObject, getEventArgs());
            }
        }
    }


    public void OnDrop(PointerEventData eventData)
    {
        if (eventData == null || !eventData.pointerEnter) return;
        //Debug.Log(eventData.pointerEnter.name);
        if (onDrop != null)
        {
            if (!IsForbid())
            {
                onDrop(eventData, gameObject, eventData.pointerEnter, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onDrop(eventData, gameObject, eventData.pointerEnter, getEventArgs());
            }
        }
    }

    public void OnScroll(PointerEventData eventData)
    {
        if (eventData == null) return;
        if (onScroll != null)
        {
            if (!IsForbid())
            {
                onScroll(eventData, gameObject, eventData.scrollDelta, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onScroll(eventData, gameObject, eventData.scrollDelta, getEventArgs());
            }
        }
    }

    public void OnUpdateSelected(BaseEventData eventData)
    {
        //if (eventData == null) return;
        //throw new NotImplementedException();
        //Debug.Log(eventData.selectedObject.name + "  OnUpdateSelected");
        if (onUpdateSelected != null)
        {
            if (!IsForbid())
            {
                onUpdateSelected(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onUpdateSelected(eventData, gameObject, getEventArgs());
            }
        }
    }

    public void OnSelect(BaseEventData eventData)
    {
        //if (eventData == null) return;
        if (onSelect != null)
        {
            if (!IsForbid())
            {
                onSelect(eventData, gameObject, true, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onSelect(eventData, gameObject, true, getEventArgs());
            }
        }
    }

    public void OnDeselect(BaseEventData eventData)
    {
        //if (eventData == null) return;
        if (onSelect != null)
        {
            if (!IsForbid())
            {
                onSelect(eventData, gameObject, false, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onSelect(eventData, gameObject, false, getEventArgs());
            }
        }
    }

    public void OnMove(AxisEventData eventData)
    {
        if (eventData == null) return;
        Debug.Log(eventData.selectedObject.name + "  OnMove");
    }

    public void OnSubmit(BaseEventData eventData)
    {
        if (onSubmit != null)
        {
            if (!IsForbid())
            {
                onSubmit(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onSubmit(eventData, gameObject, getEventArgs());
            }
        }
    }

    public void OnCancel(BaseEventData eventData)
    {
        //throw new NotImplementedException();
        //Debug.Log(eventData.selectedObject.name + "  OnCancel");
        if (onCancel != null)
        {
            if (!IsForbid())
            {
                onCancel(eventData, gameObject, getEventArgs());
            }
            else if (IsAllowedMe(gameObject))
            {
                onCancel(eventData, gameObject, getEventArgs());
            }
        }
    }

    #endregion UGUI事件实现接口
}

internal class LongPressBean
{
    public PointerEventData eventData;
    public object[] args;

    public LongPressBean(PointerEventData eventData, object[] args)
    {
        this.eventData = eventData;
        this.args = args;
    }
}