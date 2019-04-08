# MapManager

> 地图管理器，负责地图上的寻路等。

---

## goToPos(sceneID, x, y, isTransport, needPromp, strategy, monsterID, toAutoFight, distance)
寻路到指定的场景中的某个位置。

|参数名称|类型|描述|
|:---|:---|:---|
|sceneID|int|指引场景id。|
|x|int|指引位置x坐标。|
|y|int|指引位置y坐标。|
|isTransport|Boolean|是否使用传送功能。|
|needPromp|int|是否提示错误信息。|
|strategy|int|目标点处理策略，定义在_FindPosStrategy_中，支持直接使用指定坐标、检查指定坐标是否有效等策略。|
|monsterID|int|如需到达目标点后自动开始攻击怪物，可通过本参数指定要攻击的怪物id。|
|toAutoFight|int|如需达到目标点后自动开始挂机，则向本参数传递_true_。|
|distance|Number|当_strategy_为_FindPosStrategy.FindSuitableAround_时，可以通过本参数指定寻找合适站位点的距离。|

#### 返回值
_int_ - 一个_PathingState_的枚举值，_PathingState.CAN_REACH_表示可以到达，_PathingState.CANNOT_REACH_表示不可到达，_PathingState.REACHED_表示已经到达，_PathingState.BUSY_表示当前状态不可进行寻路。

---

## 相关
* [PathingState](//classes/PathingState.html 'PathingState')
