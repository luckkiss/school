# FuncLimitData

> 功能限制数据管理器，负责管理各个功能是否受到限制。

---

## isFuncEntranceVisible(funcName)
查询指定功能入口是否可见。策划通过NPC功能表可以配置各个功能的开启条件，比如开启等级、主角必须完成某个任务等。

|参数名称|类型|描述|
|:---|:---|:---|
|funcName|int|功能ID，定义在_KW_中。|

#### 返回值
_Boolean_ - 一个布尔值，_true_表示指定功能入口可见。