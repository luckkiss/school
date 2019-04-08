# TabForm

> 页签面板基类。`TabForm`继承自`CommonForm`，是一个具有页签按钮组的`CommonForm`。`TabForm`仅仅是一个带Tab的壳面板，其各个子页签均是独立制作的，且仅仅在打开指定页签时才会进行加载并初始化。你只需将各个子页签面板的类定义传入`TabForm`的构造函数即可。

---

## getTabFormByID(id)
通过id取得对应的子面板。

|参数名称|类型|描述|
|:---|:---|:---|
|id|int|面板id，通常使用定义在_KW_中的功能关键字作为面板的id。|

#### 返回值
_TabSubForm_ - 对应的子面板。

---

## getCurrentTab()
获取当前正在显示的子面板。

#### 返回值
_TabSubForm_ - 当前正在显示的子面板。

---

## switchTabFormById(id, ...args)
切换到指定id的子面板。你还可以同时传递任意参数给该子面板。

|参数名称|类型|描述|
|:---|:---|:---|
|id|int|面板id，通常使用定义在_KW_中的功能关键字作为面板的id。|
|args|任意数量的任意类型的参数|传递给子面板的_open_方法。|

#### 返回值
_TabSubForm_ - 对应的子面板。

---

## setTabTipMarkById(id, isShowTipMark)
让指定id对应的页签按钮显示一个小红点，用来提示玩家。

|参数名称|类型|描述|
|:---|:---|:---|
|id|int|面板id，通常使用定义在_KW_中的功能关键字作为面板的id。|
|isShowTipMark|Boolean|是否显示小红点。|

#### 返回值
无

---

## 相关
* [CommonForm](//classes/CommonForm.html 'CommonForm')
* [TabSubForm](//classes/TabSubForm.html 'TabSubForm')