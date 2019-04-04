# BaseFuncIconCtrl

> 特定按钮控制器的基类，`ActBtnController`管理着多个`BaseFuncIconCtrl`。每个`BaseFuncIconCtrl`对应一个按钮。因此，增加按钮则需要增加一个继承自`BaseFuncIconCtrl`的特定按钮控制器。

---

## onStatusChange()
策划可以通过功能表配置某个功能的开启条件，比如主角达到某个等级、接受或者完成某个任务，以及所处服务器开服第几天等。针对这些条件，`ActBtnController`已经做了统一处理。假如某个按钮还有一些额外的判断逻辑，比如动态地根据主角的状态决定按钮是否显示，则需要重写此接口，根据具体的逻辑处理按钮显示与否，或者处理是否在按钮上显示小红点提示的逻辑。

#### 返回值
无

---

## handleClick()
处理点击按钮之后的相应逻辑。

#### 返回值
无

---

## 子类示例
* [DailyRechargeCtrl](//classes/DailyRechargeCtrl.html 'DailyRechargeCtrl')
* [FuLiDaTingCtrl](//classes/FuLiDaTingCtrl.html 'FuLiDaTingCtrl')