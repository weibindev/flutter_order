import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/common/common.dart';
import 'package:order/entity/base_entity.dart';
import 'package:order/entity/property.dart';
import 'package:order/entity/sort.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/pages/sort_page.dart';
import 'package:order/ui/order/pages/sort_right_page.dart';
import 'package:order/ui/order/provider/ball_anim_provider.dart';
import 'package:order/ui/order/provider/order_provider.dart';
import 'package:order/ui/order/widgets/shop_cart.dart';
import 'package:order/ui/order/widgets/shop_cart_list.dart';
import 'package:order/ui/order/widgets/throw_ball_anim.dart';
import 'package:order/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import '../../../util/navigator_utils.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  PageController _pageController = PageController();

  ///管理点单功能Navigator的key
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  ///点单功能的provider实现了商品的增减，缓存，购物车列表回调等
  OrderProvider provider = OrderProvider();

  bool _isShow = false;

  ///购物车不为空的情况下，点击购物车图标会触发的回调
  Future<void> showShopCarListCallback() async {
    _isShow = !_isShow;
    if (_isShow) {
      // 显示
      await ShopCartList.start(navigatorKey.currentState);
      // 已经关闭
      _isShow = false;
    } else {
      // 关闭
      navigatorKey.currentState.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    //初始化栏目分类数据以及缓存商品属性
    getSortList();
  }

  void getSortList() {
    rootBundle.loadString('assets/data/sort.json').then((value) {
      BaseEntity<Sort> result = BaseEntity.fromJson(jsonDecode(value));

      //删选出一级菜单
      List<Sort> sortList =
          result.listData.where((element) => element.parentId == -1).toList();

      //增加一个名为菜单的一级菜单
      sortList.insert(0, Sort(typeName: '套餐', id: -1));

      //删除出二级菜单
      List<Sort> subSortList =
          result.listData.where((element) => element.parentId != -1).toList();

      provider.setSortList(sortList);

      provider.setSubSortList(subSortList);
    }).then((value) {
      getPropertyList();
    });
  }

  void getPropertyList() {
    rootBundle.loadString('assets/data/property.json').then((value) {
      //将商品属性存储下来
      BaseEntity<Property> result = BaseEntity.fromJson(jsonDecode(value));
      if (result.listData != null && result.listData.isNotEmpty) {
        SpUtil.putObjectList(Constant.property, result.listData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //多Provider的使用
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          provider.showShopCarListCallback = showShopCarListCallback;
          return provider;
        }),
        ChangeNotifierProvider(
          create: (_) => BallAnimProvider(),
        )
      ],
      child: WillPopScope(
        onWillPop: () {
          //监听系统返回键，先对自定义Navigator里的路由做出栈处理，最后关闭OrderPage
          navigatorKey.currentState.maybePop().then((value) {
            if (!value) {
              NavigatorUtils.goBackWithParams(
                  context, provider.cartGoodsList.length);
            }
          });
          return Future.value(false);
        },
        child: Stack(
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
        ),
      ),
    );
  }

  //构建内容层
  Widget _buildContent(BuildContext childContext) {
    return Scaffold(
      //弹出键盘不拉起底部布局
      resizeToAvoidBottomInset: false,
      appBar: SearchBar(
          hintText: '请输入关键字',
          isSearch: false,
          onBack: () => Navigator.maybePop(context)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vLine10(context),
          //占满剩余高度
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 59,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 80 + MediaQuery.of(context).padding.bottom),
                      child:
                          Consumer<OrderProvider>(builder: (_, provider, __) {
                        return SortPage(
                          itemHeight: 43.0,
                          items:
                              provider.sortList.map((e) => e.typeName).toList(),
                          sortTaped: (index) {
                            _pageController.jumpToPage(index);
                          },
                        );
                      }),
                    ),
                  ),
                ),
                Gaps.hLine10(context),
                Expanded(
                  flex: 306,
                  child: Consumer<OrderProvider>(
                    builder: (_, provider, __) {
                      return PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: provider.sortList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (_, index) {
                            int parentId = provider.sortList[index].id;
                            List<Sort> list = provider.subSortMap[parentId];
                            return SortRightPage(
                                key: Key('SortRightPage$parentId'),
                                parentId: parentId,
                                data: list);
                          });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
