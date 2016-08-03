# LsTableViewPlaceholder
## 介绍
LsTableViewPlaceholder一行代码实现UITableView无数据时展示占位视图.
## 与其他框架的区别
 -| 特点 |解释
-------------|-------------|-------------
1 | 轻量级、无污染 | 基于 UITableView 分类，无污染，比基于子类化、继承的框架更加轻量级
2 | 低耦合 | 自定义占位视图的可自行实现，通过block传递。
3 | 使用方法简单 |  基于  `dataSource`  数据源，所以只需操作  `dataSource`  数据源，即可完成占位视图的显示和隐藏的时机，更加直观。搭配 MJRefresh 使用十分方便，demo 中也给出了搭配使用方法。

## 引入方式
直接将UITableView+Placeholder的.h文件和.m文件拖入到项目中。

## 使用示例

```Objective-C
#import "UITableView+Placeholder.h"

[self.tableView ls_setPlaceholderView:^UIView * _Nonnull(UITableView * _Nonnull tableView) {
        UIView *weChatStyle = [self weChatStylePlaceHolder];
        return weChatStyle;
    }];

```


## 适用于多种应用应用场景

[MyDemoCode](https://github.com/ShuangLee/MyDemoCode) 是基于  `dataSource`  数据源是否为空，所以只需操作  `dataSource`  数据源，即可完成占位视图的 `。只要为空就会触发。并且每次在操作占位视图的 `addSubview` 和 `removeFromSuperview` 时，每次都会将旧的销毁，并触发 `- (UIView *)makePlaceHolderView` 创建一个新的视图。如果在该方法中进行 if 判断，也就能适用于不同的场景。

   1.  [ 网络故障 ](https://github.com/ShuangLee/MyDemoCode#网络故障) 
    1.  [ 网络不可用，禁止重新加载 ](https://github.com/ShuangLee/MyDemoCode#网络不可用禁止重新加载) 
   2.  [ 暂无数据 ](https://github.com/ShuangLee/MyDemoCode#暂无数据) 

### 网络故障

适用于那些造成 dataSource 为空的原因只能是网络故障，比如首页、团购列表、商品列表等

比如

携程 网络故障 | 携程 网络故障 | 携程 网络故障
-------------|-------------|-------------
![应用场景之加载失败--携程](http://a66.tinypic.com/309791e.jpg) | ![应用场景之加载失败--携程](http://a67.tinypic.com/2druukl.jpg) | ![应用场景之加载失败--携程](http://a68.tinypic.com/11kz5vd.jpg)

代码实现时直接返回网络故障占位视图，用伪代码表示则是：

 ```Objective-C
 [self.tableView ls_setPlaceholderView:^UIView * _Nonnull(UITableView * _Nonnull tableView) {
        return NetNotAvailableView;
    }];

 ```



#### 网络不可用，禁止重新加载

如果此时检测到网络断开可以禁止用户刷新的行为，比如：

QQ空间 | 苏宁易购 | 嘟嘟美甲
-------------|-------------|-------------
![应用场景之加载失败](http://a64.tinypic.com/2ltrh3p.jpg) |![应用场景之加载失败](http://a66.tinypic.com/f2sx9g.jpg) |![应用场景之加载失败](http://a65.tinypic.com/w9e71d.jpg)|




### 暂无数据

适用于那些造成 dataSource 为空的原因不仅有网络故障，也可能是确实是服务端也没有数据，这种场景下需要判断下当前网络再返回占位视图，比如：




App | 暂无数据 | 网络故障
 -------------|------------- | ---------
百度传课 | ![应用场景之暂无数据](http://a63.tinypic.com/24x2jh1.jpg) |![应用场景之加载失败](http://a68.tinypic.com/34qnx8w.jpg)



 暂无数据 | 暂无数据（美团）
-------------|-------------
![应用场景之暂无数据](http://a64.tinypic.com/2i6dqtl.jpg) | ![应用场景之暂无数据](http://a67.tinypic.com/bhefd5.jpg)


代码实现，用伪代码表示则是：


 ```Objective-C
[self.tableView ls_setPlaceholderView:^UIView * _Nonnull(UITableView * _Nonnull tableView) {
        if (self.isNetNotAvailable) {
            return [self taoBaoStylePlaceHolder];
        }
        UIView *weChatStyle = [self weChatStylePlaceHolder];
        return weChatStyle;
    }];
 ```


### 网络不可达场景


- | 应用场景之加载失败 |  ---
-------------|-------------|-------------
![应用场景之加载失败](http://a65.tinypic.com/2nqbors.jpg) | ![应用场景之加载失败](http://a64.tinypic.com/17edlv.jpg) | ![应用场景之加载失败](http://a67.tinypic.com/2zg5hrr.jpg)
![应用场景之加载失败](http://a67.tinypic.com/2qx2ryo.jpg) | ![应用场景之加载失败](http://a64.tinypic.com/ms198y.jpg) | ![应用场景之加载失败](http://a66.tinypic.com/2r5eoig.jpg)
![应用场景之加载失败](http://a68.tinypic.com/sblk02.jpg) | ![应用场景之加载失败](http://a64.tinypic.com/2lvfq4y.jpg) | ![应用场景之加载失败](http://a63.tinypic.com/i70g13.jpg)
![应用场景之加载失败](http://a67.tinypic.com/px93s.jpg) | ![应用场景之加载失败](http://a66.tinypic.com/2ai1di.jpg) | ![应用场景之加载失败](http://a68.tinypic.com/mlmukm.jpg)
![应用场景之加载失败](http://a66.tinypic.com/6qxq36.jpg) | ![应用场景之加载失败](http://a66.tinypic.com/68bz7q.jpg) | ![应用场景之加载失败](http://a64.tinypic.com/2qu0yo1.jpg)
![应用场景之加载失败](http://a66.tinypic.com/2h3q4wh.jpg) | ![应用场景之加载失败](http://a65.tinypic.com/2w4b6ag.jpg) | ![应用场景之加载失败](http://a68.tinypic.com/28v9fdw.jpg)
![应用场景之加载失败](http://a65.tinypic.com/311xa9j.jpg) | ![应用场景之加载失败](http://a65.tinypic.com/2zf1g1l.jpg) | ![应用场景之加载失败](http://a63.tinypic.com/11udmbs.jpg)
![应用场景之加载失败](http://a63.tinypic.com/zx703l.jpg) | ![应用场景之加载失败](http://a63.tinypic.com/2chs3uc.jpg) | ![应用场景之加载失败](http://a68.tinypic.com/2a68kty.jpg)
![应用场景之加载失败](http://a67.tinypic.com/htfh1w.jpg) | ![应用场景之加载失败](http://a68.tinypic.com/1zgpykw.jpg)| ![应用场景之加载失败](http://a64.tinypic.com/xgfgi1.jpg)
![应用场景之加载失败](http://a65.tinypic.com/34gk4gm.jpg) | ![应用场景之加载失败](http://a68.tinypic.com/20abals.jpg)|![应用场景之加载失败](http://a68.tinypic.com/2up75hw.jpg)
![应用场景之加载失败](http://a66.tinypic.com/4l0bnt.jpg)| ![应用场景之加载失败](http://a67.tinypic.com/20q11th.jpg) |![应用场景之加载失败](http://a63.tinypic.com/o9o3cw.jpg)
## 致谢

----------
感谢[微博@iOS程序犭袁](http://weibo.com/luohanchenyilong/) ,本demo参考 
[CYLTableViewPlaceHolder](https://github.com/ChenYilong/CYLTableViewPlaceHolder)。
