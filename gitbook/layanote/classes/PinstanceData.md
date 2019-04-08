# PinstanceData

> 副本数据。负责管理副本模块相关的数据，包括各个副本的进度、奖励领取状态等信息。

---

## getConfigByID(id)
查询指定副本ID的整体配置。

|参数名称|类型|描述|
|:---|:---|:---|
|id|int|指引副本id。|

#### 返回值
_PinstanceConfigM_ - 指定副本的配置。

---

## getDiffBonusConfigs(pinstanceID)
查询指定副本难度的关卡配置。

|参数名称|类型|描述|
|:---|:---|:---|
|pinstanceID|int|指引副本id。|

#### 返回值
_Vector.\<PinstanceDiffBonusM\>_ - 一个包含所有关卡配置的数组。

---

## getPinstanceInfo(id)
查询指定副本的进度数据。

|参数名称|类型|描述|
|:---|:---|:---|
|id|int|指引副本id。|

#### 返回值
_ListPinHomeRsp_ - 一个协议数据结构，包含终身首通（曾经通关）、今日首通（今日通关）、历史最高关卡、今日最高关卡，以及终身奖励和今日奖励的领取状态等信息。

---

## 相关
* [PinstanceModule](//classes/PinstanceModule.html 'PinstanceModule')