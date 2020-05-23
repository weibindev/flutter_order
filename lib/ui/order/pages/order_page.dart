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

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  OrderProvider provider = OrderProvider();

  bool _isShow = false;

  Future<void> showShopCarListCallback() async {
    FocusScope.of(context).unfocus();
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
              observers: [HeroController()], //自定Navigator使用不了Hero的解决方案 https://zhuanlan.zhihu.com/p/52228267
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
            ThrowBallAnim(),
          ],
        ),
      ),
    );
  }

  //构建内容层
  Widget _buildContent(BuildContext childContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      //弹出键盘不拉起底部布局
      resizeToAvoidBottomInset: false,
      appBar: SearchBar(
          hintText: '请输入关键字',
          isSearch: false,
          onBack: () => Navigator.maybePop(context)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Gaps.vLine10,
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
                      padding: const EdgeInsets.only(bottom: 70),
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
                Gaps.hLine10,
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
