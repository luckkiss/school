# ActivityData

> 活动数据管理器。这是一个很庞杂的数据集合，因为活动数量很多，为了避免`ActivityData`代码量看起来太吓人，故有些活动数据又独立写了一个数据集挂靠在`ActivityData`下，比如`DailySignData`(每日签到数据)。

---

## getActivityStatus(activityID)
查询指定活动ID的活动的状态。函数返回一个`ActivityStatus`数据结构，包含活动是否开启、结束时间、下一次开启时间等信息。由于很多操作必须在相应的活动开启期间才能进行，因此我们经常需要通过本接口查询某个活动是否开启。

|参数名称|类型|描述|
|:---|:---|:---|
|activityID|int|活动ID，定义在_Macros_中。|

#### 返回值
_ActivityStatus_ - 活动状态，若没有查找到指定活动的状态则返回_null_。

---

## isActivityOpen
和getActivityStatus类似，查询指定活动是否开启。

|参数名称|类型|描述|
|:---|:---|:---|
|activityID|int|活动ID，定义在_Macros_中。|

#### 返回值
_Boolean_ - 一个布尔值，_true_表示活动已经开启。

---

## getActivityConfig
查询指定活动ID的配置。

|参数名称|类型|描述|
|:---|:---|:---|
|activityID|int|活动ID，定义在_Macros_中。|

#### 返回值
_ActivityConfigM_ - 指定活动的配置。