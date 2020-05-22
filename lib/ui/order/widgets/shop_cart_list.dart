import 'package:flutter/material.dart';
import 'package:order/common/common.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/entity/property.dart';
import 'package:order/res/resources.dart';
import 'file:///D:/GitHub-Flutter/flutter_order/lib/util/navigator_utils.dart';
import 'package:order/ui/order/provider/order_provider.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/util/utils.dart';
import 'package:order/widgets/load_image.dart';
import 'package:provider/provider.dart';

///点击购物车图标出现的列表组件
class ShopCartList extends StatefulWidget {
  ShopCartList({Key key}) : super(key: key);

  static Future<T> start<T extends Object>(NavigatorState navigatorState) {
    return navigatorState.push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Color(0x6604040F),
        pageBuilder: (context, animation, secondaryAnimation) => ShopCartList(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
              .animate(animation),
          child: child,
        ),
        transitionDuration: Duration(milliseconds: 200),
      ),
    );
  }

  @override
  _ShopCartListState createState() => _ShopCartListState();
}

class _ShopCartListState extends State<ShopCartList> {
  @override
  void initState() {
    Constant.isShowShopList = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 7 / 10.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: Colors.white,
            ),
            child: _buildList(context),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    OrderProvider provider = Provider.of<OrderProvider>(context, listen: true);

    return Column(
      children: <Widget>[
        Gaps.vGap20,
        Padding(
          padding: const EdgeInsets.only(left: 11, right: 10),
          child: Row(
            children: <Widget>[
              Text('已选商品', style: TextStyles.textGray14),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    provider.removeAllCartGoods();
                    provider.clickShopCarButton();
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    LoadAssetImage(
                      'ic_clear',
                      width: 19,
                      height: 19,
                    ),
                    Text('清空', style: TextStyles.textGray12),
                  ],
                ),
              ),
            ],
          ),
        ),
        Gaps.vGap12,
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 70),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: provider.cartGoodsSort.length,
              itemBuilder: (_, index) {
                CartGoodsBean goods = provider.cartGoodsSort[index];
                bool hasProperty =
                    goods.properties != null && goods.properties.isNotEmpty;

                List<CartGoodsBean> goodsList = hasProperty
                    ? provider.findCartGoodsWithProperty(goods)
                    : provider.findCartGoods(goods);

                return Padding(
                  padding: const EdgeInsets.fromLTRB(11, 0, 10, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 233,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text('${goods.name}',
                                  style: TextStyles.textBlack14,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              flex: 5,
                            ),
                            Gaps.hGap5,
                            Visibility(
                              visible: hasProperty ? true : false,
                              child: _buildProperty(goods, hasProperty),
                            ),
                          ],
                        ),
                      ),
                      Gaps.hGap5,
                      Expanded(
                        flex: 160,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                provider.removeCartGoods(goods);
                                if (provider.cartGoodsList.isEmpty) {
                                  NavigatorUtils.goBack(context);
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 7, 15),
                                child: LoadAssetImage(
                                  'ic_reduce',
                                  width: 21.85,
                                  height: 21.85,
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                              alignment: Alignment.center,
                              child: Text('${goodsList.length}',
                                  style: TextStyles.textBlack14),
                            ),
                            GestureDetector(
                              onTap: () => provider.addCartGoods(goods),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(7, 15, 10, 15),
                                child: LoadAssetImage(
                                  'ic_add',
                                  width: 21.85,
                                  height: 21.85,
                                ),
                              ),
                            ),
                            Spacer(),
                            RichText(
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text: '¥',
                                    style: TextStyle(
                                        fontSize: Dimens.font_sp10,
                                        color: Colors.red)),
                                TextSpan(
                                    text: _getGoodsPrice(goodsList),
                                    style: TextStyle(
                                        fontSize: Dimens.font_sp14,
                                        color: Colors.red,
                                        fontFamily: 'DINRegular')),
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  String _getGoodsPrice(List<CartGoodsBean> goods) {
    double totalPrice = 0.0;
    for (var value in goods) {
      totalPrice += value.price;
    }
    return Utils.formatPriceWithoutSymbol(totalPrice.toString());
  }

  Widget _buildProperty(CartGoodsBean goods, bool hasProperty) {
    if (hasProperty) {
      List<Property> list = [];

      if (goods.properties.contains(',')) {
        List<String> stringList = goods.properties.split(',');
        for (var value in stringList) {
          Property property = goods.propertyList
              .singleWhere((item) => item.id.toString() == value);
          list.add(property);
        }
      } else {
        list = goods.propertyList
            .where((item) => item.id.toString() == goods.properties)
            .toList();
      }

      return Row(
        children: list.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(8.5, 1.5, 8.5, 1.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.5),
                  color: ColorUtils.hexToColor('#FFF6E9'),
                  border: Border.all(
                      color: ColorUtils.hexToColor('#FFBD67'), width: 0.5)),
              child: Text(item.propertyName,
                  style: TextStyle(
                      color: ColorUtils.hexToColor('#FF932D'),
                      fontSize: Dimens.font_sp10)),
            ),
          );
        }).toList(),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  void dispose() {
    Constant.isShowShopList = false;
    super.dispose();
  }
}
