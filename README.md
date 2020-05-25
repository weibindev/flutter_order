# order

用Flutter实现商品点单功能

> 前一段时间项目集成了`Flutter`做了许多的功能模块，再加上很久没有文章产出，所以打算写这么一篇文章来总结和记录`Flutter`开发中的一些问题 </br></br> Demo地址：[https://github.com/weibindev/flutter_order](https://github.com/weibindev/flutter_order) </br> 下载[apk](https://gitee.com/maratom/flutter_order/raw/master/apk/app-release.apk)体验一下（为了精简APK大小，cpu架构指定了armeabi-v7a）

`ps`:demo中的数据都从`assets\data\`文件夹下的json文件读取，所以并没有涉及到网络请求封装，项目架构等相关知识，这个demo偏注重于点单结构的实现。

总体的效果如下所示：


![点单.gif](https://user-gold-cdn.xitu.io/2020/5/25/1724969a689e9a58?w=360&h=640&f=gif&s=5151645)

# 整体结构分析

首页的店铺入口没什么好说的，它主要是我们点单功能的入口和店铺购物车商品数的展示。

下面我们主要来分析下点单界面的结构组成。

![点单界面结构](https://user-gold-cdn.xitu.io/2020/5/24/172476509054a090?w=417&h=835&f=png&s=103915)

根据上面这张图，按照数字标识框出的地方分析如下：
- 1：顶部的搜索框，相当于`Android`中的`statusBar`+`toolbar`
- 2：左侧一级商品分类栏目，部分栏目会有二级分类的情况出现
- 3：二级商品分类栏目，是对一个大类商品做进一步划分
- 4：一级或二级分类的商品列表，点击单个商品条目进入商品的详情页
- 5：底部购物车，它位于整个点单界面的最顶层，这个界面的所有功能均不会遮挡住购物车(具有`overlays`属性的控件除外)

其中1，2，3，4可以看作一个整体，5可以看作一个整体。

# 底部购物车实现

关于底部购物车，我刚开始的实现思路是用`Overlay`去做，源码中对它的描述如下
```dart
/// A [Stack] of entries that can be managed independently.
///
/// Overlays let independent child widgets "float" visual elements on top of
/// other widgets by inserting them into the overlay's [Stack]. The overlay lets
/// each of these widgets manage their participation in the overlay using
/// [OverlayEntry] objects.
///
/// Although you can create an [Overlay] directly, it's most common to use the
/// overlay created by the [Navigator] in a [WidgetsApp] or a [MaterialApp]. The
/// navigator uses its overlay to manage the visual appearance of its routes.
///
/// See also:
///
///  * [OverlayEntry].
///  * [OverlayState].
///  * [WidgetsApp].
///  * [MaterialApp].
class Overlay extends StatefulWidget {
```
意思是`Overlay`是一个`Stack`组件，可以将`OverlayEntry`插入到`Overlay`中，使其独立的`child`窗口悬浮于其它组件之上，利用这个特性我们可以用`Overlay`将底部购物车组件包裹起来，覆盖在其它的组件之上。

然而实际使用过程中问题多多，需要自己精准的控制好`Overlay`包裹的悬浮控件的显隐等，不然人家都退出这个界面了，咱们的购物车还搁下面显示着。个人认为这玩意还是更适合`Popupindow`和全局自定义`Dialog`之类的。

那么`Flutter`中有没有方便管理一堆子组件的组件呢？

在编写`Flutter`应用的时候，我们程序的入口是通过`main()`函数的`runApp(MyApp())`执行的，`MyApp`通常会`build`出一个`MaterialApp`组件
```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我要点东西',
      home: HomePage(),
    );
  }
}
```

对于不同界面之间的路由我们会交由`Navigator`管理，比如: `Navigator.push` 和 `Navigator.pop`等。为什么`MaterialApp`能够对`Navigator`的操作作出感应呢？

`MaterialApp`的构造方法中有这么一个字段`navigatorKey`
```dart
class MaterialApp extends StatefulWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  ///省略一些代码
}

class _MaterialAppState extends State<MaterialApp> {

  @override
  Widget build(BuildContext context) {
    Widget result = WidgetsApp(
      key: GlobalObjectKey(this),
      navigatorKey: widget.navigatorKey,
      navigatorObservers: _navigatorObservers,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return MaterialPageRoute<T>(settings: settings, builder: builder);
      },
  ///省略一些代码
  }
}
```
往深入的去看它会传递给`WidgetsApp`构造方法中的`navigatorKey`，`WidgetsApp`的`navigatorKey`在组件初始化时会默认的创建一个全局的`NavigatorState`，然后对`build(BuildContext context)`中创建的`Navigator`进行状态管理。
```
class _WidgetsAppState extends State<WidgetsApp> with WidgetsBindingObserver {
    @override
    void initState() {
        super.initState();
        _updateNavigator();
        _locale = _resolveLocales(WidgetsBinding.instance.window.locales, widget.supportedLocales);
        WidgetsBinding.instance.addObserver(this);
    }

    // NAVIGATOR
    GlobalKey<NavigatorState> _navigator;

    void _updateNavigator() {
        //MaterialApp中不指定navigatorKey会默认初始化一个全局的NavigatorState
        _navigator = widget.navigatorKey ?? GlobalObjectKey<NavigatorState>(this);
    }

    @override
  Widget build(BuildContext context) {
    //这里会构建出一个Navigator组件，并把上面的navigatorKey写进去，这样就做到了Navigator的栈操作
    Widget navigator;
    if (_navigator != null) {
      navigator = Navigator(
        key: _navigator,
        // If window.defaultRouteName isn't '/', we should assume it was set
        // intentionally via `setInitialRoute`, and should override whatever
        // is in [widget.initialRoute].
        initialRoute: WidgetsBinding.instance.window.defaultRouteName != Navigator.defaultRouteName
            ? WidgetsBinding.instance.window.defaultRouteName
            : widget.initialRoute ?? WidgetsBinding.instance.window.defaultRouteName,
        onGenerateRoute: _onGenerateRoute,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes == null
          ? Navigator.defaultGenerateInitialRoutes
          : (NavigatorState navigator, String initialRouteName) {
            return widget.onGenerateInitialRoutes(initialRouteName);
          },
        onUnknownRoute: _onUnknownRoute,
        observers: widget.navigatorObservers,
      );
    }
  }
}
```

到这里基本上可以想到该如何实现底部购物车的功能了。

是的，我们可以在点单界面自定义一个`Navigator`来管理搜索商品、商品详情、商品购物车列表等路由的跳转，其它的交由我们`MaterialApp`的`Navigator`控制。

![](https://user-gold-cdn.xitu.io/2020/5/25/1724bf61c51858ec?w=421&h=752&f=png&s=77374)

下面是功能代码大致实现：

```dart
class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  ///管理点单功能Navigator的key
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          //监听系统返回键，先对自定义Navigator里的路由做出栈处理，最后关闭OrderPage
          navigatorKey.currentState.maybePop().then((value) {
            if (!value) {
              NavigatorUtils.goBack(context);
            }
          });
          return Future.value(false);
        },
        child: Stack(
          children: <Widget>[
            Navigator(
              key: navigatorKey,
              onGenerateRoute: (settings) {
                if (settings.name == '/') {
                  return PageRouteBuilder(
                    opaque: false,
                    pageBuilder:
                        (childContext, animation, secondaryAnimation) =>
                            //构建内容层
                            _buildContent(childContext),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  );
                }
                return null;
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              //购物车组件，位于底部
              child: ShopCart(),
            ),
            //添加商品进购物车的小球动画
            ThrowBallAnim(),
          ],
        ),
      );
  }
}


```

# 页面过渡动画Hero的使用

效果可以看最开始的那一张GIF。

`Hero`的使用非常的简单，需要关联的两个组件用`Hero`组件包裹，并指定相同的`tag`参数,代码如下：

```dart
///列表item
InkWell(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Hero(
          tag: widget.data,
          child: LoadImage(
            '${widget.data.img}',
            width: 81.0,
            height: 81.0,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GoodsDetailsPage(data: widget.data)));
      },
    );


```

```dart

///详情
 Hero(
    tag: tag,
    child: LoadImage(
        imageUrl,
        width: double.infinity,
        height: 300,
        fit: BoxFit.cover,
        ),
    )

```

是不是觉得这样写好就完事了呢，Hero的效果就会出来了？在正常情况下是会有效果，但是在我们这里却没有任何效果，就跟普通的路由跳转一样样的，这是为啥呢？

我们在`MaterialApp`中的是有效果的，自定义的`Navigator`的却没效果，那么肯定是`MaterialApp`的`Navigator`做了什么配置。

还是通过`MaterialApp`的源码可以发现，在其初始化的时候会new一个`HeroController`并在构造参数`navigatorObservers`中添加进去

```dart
class _MaterialAppState extends State<MaterialApp> {
  HeroController _heroController;

  @override
  void initState() {
    super.initState();
    _heroController = HeroController(createRectTween: _createRectTween);
    _updateNavigator();
  }

  @override
  void didUpdateWidget(MaterialApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigatorKey != oldWidget.navigatorKey) {
      // If the Navigator changes, we have to create a new observer, because the
      // old Navigator won't be disposed (and thus won't unregister with its
      // observers) until after the new one has been created (because the
      // Navigator has a GlobalKey).
      _heroController = HeroController(createRectTween: _createRectTween);
    }
    _updateNavigator();
  }

  List<NavigatorObserver> _navigatorObservers;

  void _updateNavigator() {
    if (widget.home != null ||
        widget.routes.isNotEmpty ||
        widget.onGenerateRoute != null ||
        widget.onUnknownRoute != null) {
      _navigatorObservers = List<NavigatorObserver>.from(widget.navigatorObservers)
        ..add(_heroController);
    } else {
      _navigatorObservers = const <NavigatorObserver>[];
    }
  }

    ///....
}
```

最终是添加进`WidgetsApp`构建的`Navigator`构造参数`observers`里
```dart
navigator = Navigator(
        key: _navigator,
        // If window.defaultRouteName isn't '/', we should assume it was set
        // intentionally via `setInitialRoute`, and should override whatever
        // is in [widget.initialRoute].
        initialRoute: WidgetsBinding.instance.window.defaultRouteName != Navigator.defaultRouteName
            ? WidgetsBinding.instance.window.defaultRouteName
            : widget.initialRoute ?? WidgetsBinding.instance.window.defaultRouteName,
        onGenerateRoute: _onGenerateRoute,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes == null
          ? Navigator.defaultGenerateInitialRoutes
          : (NavigatorState navigator, String initialRouteName) {
            return widget.onGenerateInitialRoutes(initialRouteName);
          },
        onUnknownRoute: _onUnknownRoute,
        //MaterialApp的HeroController会添加进去
        observers: widget.navigatorObservers,
      );
```

所以我们只要同理在自己定义的`Navigator`里添加进去即可：
```
    Stack(
          children: <Widget>[
            Navigator(
              key: navigatorKey,
                //自定Navigator使用不了Hero的解决方案
              observers: [HeroController()],
              onGenerateRoute: (settings) {
                if (settings.name == '/') {
                  return PageRouteBuilder(
                    opaque: false,
                    pageBuilder:
                        (childContext, animation, secondaryAnimation) =>
                            _buildContent(childContext),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            FadeTransition(opacity: animation, child: child),
                    transitionDuration: Duration(milliseconds: 300),
                  );
                }
                return null;
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ShopCart(),
            ),
            //添加商品进购物车的小球动画
            ThrowBallAnim(),
          ],
        )
```

# 高斯模糊的实现

![](https://user-gold-cdn.xitu.io/2020/5/25/1724c22b2c8eca4a?w=424&h=170&f=png&s=25832)

底部购物车的灰色区域使用到了高斯模糊的效果

该效果在`Flutter`中的控件是`BackdropFilter`,用法如下：
```
BackdropFilter(
    filter: ImageFilter.blur(sigmaX, sigmaY),
    child: ...)
```

不过使用的时候也有小坑,如果没有进行剪辑，那么高斯模糊的效果会扩散至全屏，正确的写法应该如下：
```
ClipRect(
    BackdropFilter(
        filter: ImageFilter.blur(sigmaX, sigmaY),
        child: ...)
)
```
ps：其实在`BackdropFilter`的源码中有更详细的说明，建议大家去看看

# 商品栏目分类的实现

商品栏目的分类说的笼统点就是一、二级菜单对`PageView`的page切换处理。

![](https://user-gold-cdn.xitu.io/2020/5/25/1724c3e2867b9476?w=423&h=754&f=png&s=104527)

可以把上图右侧框出的部分看成一个`PageView`，左侧`tab`的点击就是对`PageView`进行的一个**竖直方向**的page切换操作，对应的`tab`下没有二级`tab`的话，那么当前page展示的就是一个`ListView`。

![](https://user-gold-cdn.xitu.io/2020/5/25/1724c451a09cc01e?w=424&h=753&f=png&s=86465)

那如果有二级`tab`的话，当前page展示的是`TabBar`+`PageView`联动，这个`PageView`的方向是**横向水平**的

![](https://user-gold-cdn.xitu.io/2020/5/25/1724c49383ce7ce1?w=428&h=755&f=png&s=105636)

如果上述的描述还不是很懂的话，没关系，我准备了一张总的结构图，清晰的描述了它们之间的关系：

![](https://user-gold-cdn.xitu.io/2020/5/25/1724c63e672d95c2?w=1091&h=796&f=png&s=91334)

还有一点需要注意的地方，我们不希望每次切换`tab`的时候,`Widgets`都会重新加载一次，这样对用户的体验是极差的，我们要对已经加载过的page保持它的一个页面状态。这一点使用`AutomaticKeepAliveClientMixin`可以做到。

```
class SortRightPage extends StatefulWidget {
  final int parentId;
  final List<Sort> data;

  SortRightPage(
      {Key key,
      this.parentId,
      this.data})
      : super(key: key);

  @override
  _SortRightPageState createState() => _SortRightPageState();
}

class _SortRightPageState extends State<SortRightPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.data == null || widget.data.isEmpty) {
      if (widget.parentId == -1) {
        //套餐Page
        return DiscountPage();
      } else {
        //商品列表
        return SubItemPage(
          key: Key('subItem${widget.parentId}'),
          id: widget.parentId
        );
      }
    } else {
      //二级分类
      return SubListPage(
        key: Key('subList${widget.parentId}'),
        data: widget.data
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

```

# 结束

好了,文章到这里七七八八的差不多了，其他更加细节的地方大家可以去Github上看我写的[demo](https://github.com/weibindev/flutter_order)，里面对用户交互的处理还是蛮妥当的，希望能够帮助到大家。