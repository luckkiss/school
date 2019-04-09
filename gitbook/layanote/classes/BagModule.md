# BagModule

> 背包模块，负责背包、装备等各个容器相关逻辑。比如使用背包中的某个物品该触发什么操作，是直接向服务器发送消耗物品请求，还是跳转到某个关联面板，均在此编写相关逻辑。物品的配置结构名为`ThingConfigM`，其有一个字段`m_ucFunctionType`表示该物品的功能。在`BagModule::_useItemThing`中针对不同的物品功能进行了不同的逻辑判断。
