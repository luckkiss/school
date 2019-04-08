# CommonForm

> 面板基类，主要实现了面板图集和字体的自动加载。所有面板都必须继承自`CommonForm`，并通过`Global.uimgr.createForm`进行创建。

---

## layer
声明面板的层级。游戏中的面板是分层显示的。常见的层级有`UILayer.Normal`和`UILayer.Second`，分别对应一级面板和二级面板。

```
override public function layer(): int {
    return UILayer.Normal;
}
```

---

## resPath
声明关联的UI定义。当创建面板时，将根据这个声明去查找哪些图集需要预加载。

```
override protected function resPath(): Object {
    return [BagViewUI.uiView];
}
```

---

## initElements()
创建并初始化UI，比如设置list、为按钮添加事件监听等。

#### 返回值
无

```
override protected function initElements(): void {
    uiview = new BagViewUI();
    form = uiview;
    super.initElements(); 
    BagView.title = uiview.title;
    uiview.btnClose.on(Event.CLICK, this, this.close);
}
```

---

## onOpen()
界面打开后调用此函数，通常在此刷新界面显示。

#### 返回值
无

```
override protected function onOpen(): void {
    super.onOpen();
    // 更新页签
    this.switchTabFormById(this.openTab, this.openItemId);
    this.setTabTipMarkById(EnumBagTab.bag, Global.DataMgr.thingData.isCanDecomposeEquip());
}
```

---

## onClose()
界面关闭前调用此函数，通常在此执行某些清理工作。这个接口不是必须重写的，因为定时器清除、移除模型等常见清理任务均已由`CommonForm`代劳。

#### 返回值
无

---

## \_open()
打开面板。注意这个接口是_protected_，意味着外部无法直接调用。所有继承自`CommonForm`的子类均需提供一个`open`函数并接收各自所需的参数，并在函数体内调用`\_open`。

#### 返回值
无

```
public function open(actId: int, bossId: int): void {
    this.openActId = actId;
    this.openBossId = bossId;
    _open();
}
```

---

## 相关
* [TabForm](//classes/TabForm.html 'TabForm')

