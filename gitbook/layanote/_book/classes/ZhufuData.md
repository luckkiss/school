# ZhufuData

> 祝福系统数据。负责管理坐骑、翅膀、阵法等系统的数据。

---

## getData(type)
查询指定祝福系统的数据，其返回一个数据结构`CSHeroSubSuper`，包含该系统等级、祝福值、幻化形象等信息。

|参数名称|类型|描述|
|:---|:---|:---|
|type|int|祝福系统类型，定义在_KW_中，比如_KW.HERO_SUB_TYPE_ZUOQI_。|

#### 返回值
_CSHeroSubSuper_ - 指定祝福系统的数据。

---

## getConfig(type, level)
查询指定祝福系统的配置。

|参数名称|类型|描述|
|:---|:---|:---|
|type|int|祝福系统类型，定义在_KW_中，比如_KW.HERO_SUB_TYPE_ZUOQI_。|
|level|int|祝福系统等级。|

#### 返回值
_ZhuFuConfigM_ - 指定祝福系统的配置。

---

## 相关
* [HeroModule](//classes/HeroModule.html 'HeroModule')
* [ZhuFuModule](//classes/ZhuFuModule.html 'ZhuFuModule')