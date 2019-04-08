# Runtime

> 运行时状态管理器，这是一个杂乱的数据集合。通常每个具体的模块都有对应的数据集，比如`BagModule`(背包模块)对应`ThingData`(物品数据)，`PinstanceModule`(副本模块)对应`PinstanceData`(副本数据)。对于那些无法明确归类在某个模块的数据，我们记录在`Runtime`上。