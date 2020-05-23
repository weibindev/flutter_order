import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/provider/ball_anim_provider.dart';
import 'package:order/ui/order/provider/order_provider.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/widgets/label_text.dart';
import 'package:order/widgets/load_image.dart';
import 'package:provider/provider.dart';
import '../../../common/common.dart';
import '../../../util/navigator_utils.dart';

///底部购物车组件
class ShopCart extends StatefulWidget {
  @override
  ShopCartState createState() => ShopCartState();
}

class ShopCartState extends State<ShopCart> with WidgetsBindingObserver {
  GlobalKey _shopCarImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 70,
        child: Consumer<OrderProvider>(builder: (context, provider, child) {
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: ClipRect(
                  //如果不设置ClipRect的话，效果将扩散至全屏
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 49.0,
                      width: double.infinity,
                      color: ColorUtils.hexToColor('#2D3339').withOpacity(0.65),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 53.0),
                          Expanded(
                            key: Key('cart_amount'),
                            child: Text(provider.getCartGoodsPrice(),
                                style: TextStyles.textWhite14),
                          ),
                          Visibility(
                            key: Key('cart_options'),
                            visible: true,
                            child: InkWell(
                              onTap: () {
                                if (provider.cartGoodsList.isEmpty) {
                                  showToast('请先选择商品加入购物车');
                                  return;
                                }
                                provider.removeAllCartGoods();
                                if (Constant.isShowShopList) {
                                  provider.clickShopCarButton();
                                }
                                NavigatorUtils.goBack(context);
                              },
                              child: Container(
                                width: 94.5,
                                height: double.infinity,
                                color: Colors.red,
                                alignment: Alignment.center,
                                child:
                                    Text('下单', style: TextStyles.textWhite14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 6.5,
                child: GestureDetector(
                  key: _shopCarImageKey,
                  child: LoadAssetImage(
                    provider.cartGoodsList.isNotEmpty
                        ? 'order_cart'
                        : 'order_cart_empty',
                    width: 45.0,
                    height: 45.0,
                  ),
                  onTap: () => provider.cartGoodsList.isNotEmpty
                      ? provider.clickShopCarButton()
                      : null,
                ),
              ),
              Positioned(
                top: 0.0,
                left: 38,
                child: Visibility(
                  visible: provider.cartGoodsList.isNotEmpty,
                  child: LabelText(
                    key: Key('cart_count'),
                    shape: BoxShape.circle,
                    backgroundColor: Colors.red,
                    text: '${provider.cartGoodsList.length}',
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void initShopCarPosition() {
    final ballAnimProvider =
        Provider.of<BallAnimProvider>(context, listen: false);
    RenderBox renderBox = _shopCarImageKey.currentContext.findRenderObject();
    // 购物车大小存储到全局
    ballAnimProvider.shopCarSize = renderBox.size;
    // 购物车在屏幕的位置存储到全局
    ballAnimProvider.shopCarPosition = renderBox.localToGlobal(Offset.zero);
  }

  void _onAfterRendering(Duration timeStamp) {
    // 绘制完成的第一帧调用  并且只调用一次
    initShopCarPosition();
  }

  @override
  void didChangeDependencies() {
    // 无需调用移出方法,因为当回调执行后,里边的List会被自动清空
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ShopCart oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
    super.didUpdateWidget(oldWidget);
  }
}
