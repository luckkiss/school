# ActivityModule

> 活动模块，负责各个活动的处理逻辑。

---

## _onListActivityResponse(response)
登录后客户端会向服务器请求所有活动的状态，服务器回复消息`ListActivity_Response`。本方法用于处理此回复。

|参数名称|类型|描述|
|:---|:---|:---|
|response|ListActivity_Response|拉取活动信息的回复协议结构。|

#### 返回值
无

---

## _onDoActivityResponse(response)
客户端执行某个活动的某项操作，服务器回复消息`DoActivity_Response`。比如领取某个活动的奖励。笨方法用于处理此回复。

|参数名称|类型|描述|
|:---|:---|:---|
|response|DoActivity_Response|执行活动活动操作的回复协议结构。|

#### 返回值
无

---

## _onActivityStatusChangeNotify(notify)
当某个活动状态发生变更时，服务器向客户端推送通知`ActivityStatusChange_Notify`。比如某个活动开启或关闭了。

|参数名称|类型|描述|
|:---|:---|:---|
|notify|ActivityStatusChange_Notify|活动状态变更通知的协议结构。|

#### 返回值
无

---

## _onActivityDataChangeNotify(notify)
当某个活动数据发生变更时，服务器向客户端推送通知`ActivityDataChange_Notify`。比如专属BOSS活动某个BOSS复活了。

|参数名称|类型|描述|
|:---|:---|:---|
|notify|ActivityDataChange_Notify|活动数据变更通知的协议结构。|

#### 返回值
无

