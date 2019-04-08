# ThingData

> 物品数据管理器。`ThingData`既管理包括物品表格、装备表格等配置数据，又管理主角背包、装备等各个容器的数据，并提供查询物品配置、主角背包数据等接口。

---

## getThingConfig(thingID)
获取指定ID的物品配置。

|参数名称|类型|描述|
|:---|:---|:---|
|thingID|int|指定物品的id。|

#### 返回值
_ThingConfigM_ - 物品配置。

---

## getThingNum(thingID, containerID, bindInsensitive)
查询指定ID的物品在指定容器中的数量，默认容器为背包，默认不区分物品绑定与否。当_bindInsensitive_为_true_时，表示不区分物品绑定与否，返回的数量为绑定物品和非绑定物品的总数之和。当_bindInsensitive_为_false_时，则严格查找和_thingID_的id相同的物品的数量。

|参数名称|类型|描述|
|:---|:---|:---|
|thingID|int|指定物品的id。|
|containerID|int|指定容器的id。|
|bindInsensitive|Boolean|是否对绑定与否不敏感。|

#### 返回值
_int_ - 物品数量。

---

## getBagItemById(itemId, bindInsensitive, num)
在背包中查找指定ID的物品的数据。

|参数名称|类型|描述|
|:---|:---|:---|
|itemId|int|指定物品的id。|
|bindInsensitive|Boolean|是否对绑定与否不敏感。|
|num|查找数量，默认为_0_，表示查找所有符合条件的物品。通常情况下只需查找1个符合条件的物品即可，此时传递_1_可以减少查找消耗。|

#### 返回值
_Vector.<ThingItemData>_ - 一个数组，包含符合条件的物品的数据。

---

## 相关
* [BagModule](//classes/BagModule.html 'BagModule')
* [DataManager](//classes/DataManager.html 'DataManager')