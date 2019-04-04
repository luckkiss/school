# GuideMgr

> 新手引导管理器。策划在表格中配置了各个引导的触发条件，包括主角达到某个等级、接受或者完成某个任务等。所有特定引导必须先注册到`GuideMgr`上方可使用。`GuideMgr`保证引导过程和任务过程按序进行互不干扰。

---

## processGuideNext(group, step)
通知指引管理器指定指引步骤可完成，继续下一步指引。

|参数名称|类型|描述|
|:---|:---|:---|
|group|int|指引id，定义在_EnumGuide_中。|
|step|int|指引步骤id，定义在_EnumGuide_中。|

#### 返回值
无

---

## 相关
* [BaseGuider](//classes/BaseGuider.html 'BaseGuider')

