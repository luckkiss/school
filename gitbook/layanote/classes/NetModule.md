# NetModule

> 网络模块，负责与服务器进行通信。通过`Global.ModuleMgr.NetModule`进行访问。协议是指客户端和服务器之间进行通信的数据。客户端向服务器发起请求，称为XX_Request，服务器收到后回复XX_Response。此外，还有一部分服务器主动推送的通知，称为XX_Notify，比如他人聊天。

---

## sendMsg(msg)
向服务器发送协议。

|参数名称|类型|描述|
|:---|:---|:---|
|msg|FyMsg|要发送的协议。|

#### 返回值
无

---

## 相关
* [ProtocolUtil](//classes/ProtocolUtil.html 'ProtocolUtil')