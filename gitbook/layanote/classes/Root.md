# Root

> 游戏入口，相当于整个游戏的壳。负责根据当前平台，选择创建对应的主程序入口。比如，针对微信、QQ玩吧分别创建对应的主程序入口`WxRoot`、`WbRoot`。不同平台的入口，仅有些许差别，比如平台礼包、登录。