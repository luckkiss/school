# 自动进阶

```flow
st=>start: 自动进阶
op_auto=>operation: 标记进入自动模式
op_req=>operation: 发送进阶请求
op_update=>operation: 刷新界面
cond_auto=>condition: 是否处于自动模式中
cond_upgraded=>condition: 是否升到下一阶
e=>end: 取消自动模式
st->op_auto->op_req->op_update->cond_auto
cond_auto(no)->e
cond_auto(yes)->cond_upgraded
cond_upgraded(no)->op_req
cond_upgraded(yes)->e
```

