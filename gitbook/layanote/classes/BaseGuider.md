# BaseGuider

> 特定引导的基类。每个引导都可以拆分为若干步骤。

---

## _addStep(step, func)
添加指引步骤。

|参数名称|类型|描述|
|:---|:---|:---|
|step|int|指引步骤id，定义在_EnumGuide_中。|
|func|Handler|指引步骤处理器，处理该步骤需要执行的操作。|

#### 返回值
无

---

## _forceStep(step)
发生指引时，若玩家长时间没有按照指引进行操作，则系统会调用本方法强制执行该操作。每个`BaseGuider`的基类通常都需要重写本方法执行相应的操作。

|参数名称|类型|描述|
|:---|:---|:---|
|step|int|指引步骤id，定义在_EnumGuide_中。|

#### 返回值
_Boolean_ - 一个布尔值，若强制执行步骤失败则返回_false_，系统将取消当前引导。

---

## 子类示例
* [PetActivateGuider](//classes/PetActivateGuider.html 'PetActivateGuider')
* [EquipEnhanceGuider](//classes/EquipEnhanceGuider.html 'EquipEnhanceGuider')

