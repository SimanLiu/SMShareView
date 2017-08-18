# SMShareView
仿微信的分享面板。分为上下两部分，上部分为分享平台，下部分为其他操作。


初始化调用：
```objc
SMShareView *shareView = [[SMShareView alloc] initWithFrame:self.view.bounds];

[shareView showShareViewWithCancel:nil finish:^(SMShareType shareType) {
    
   //点击回调
}];
```

#![image](https://github.com/SimanLiu/SMShareView/blob/master/ezgif-1-e9aff456f3.gif)
