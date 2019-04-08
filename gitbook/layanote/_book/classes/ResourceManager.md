# ResourceManager

> 资源管理器，负责各类资源文件的加载，比如各类模型。

---

## getUnitUrlByID(unitType, modelIdStr, forDisplay)
查询指定ID对应的模型文件的URL。

|参数名称|类型|描述|
|:---|:---|:---|
|unitType|int|单位类型，定义在_UnitCtrlType_中。|
|modelIdStr|String|模型文件名称。|
|forDisplay|Boolean|是否用于UI展示，部分模型专门制作了UI展示版本，可以展示更多精美细节。|

#### 返回值
_String_ - 模型文件的URL。

---

## getDependResources(info, uiArr, fontArr)
解析UI文件的信息，得出面板依赖的图集信息。

|参数名称|类型|描述|
|:---|:---|:---|
|info|Object|UI文件的uiView字段。|
|uiArr|Array|用于存储解析出来的图集信息。|
|fontArr|Array|用于存储解析出来的字体信息。|

#### 返回值
无