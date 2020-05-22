import 'package:flutter/material.dart';
import 'package:order/common/http_api.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/provider/ball_anim_provider.dart';
import 'package:order/ui/order/provider/order_provider.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/util/utils.dart';
import 'package:order/widgets/label_text.dart';
import 'package:order/widgets/load_image.dart';
import 'package:provider/provider.dart';

import 'goods_type_dialog.dart';

class GoodsItem extends StatefulWidget {
  final CartGoodsBean data;

  GoodsItem({Key key, this.data}) : super(key: key);

  @override
  _GoodsItemState createState() => _GoodsItemState();
}

class _GoodsItemState extends State<GoodsItem> {
  GlobalKey _addWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 12.5, 0.0, 12.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LoadImage(
              '${HttpApi.oss}${widget.data.img}',
              width: 81.0,
              height: 81.0,
              fit: BoxFit.fitHeight,
            ),
          ),
          Gaps.hGap10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.data.name,
                  style: TextStyles.textBold14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2.5),
                Text(
                  '月销 100',
                  style: TextStyles.textGray10,
                ),
                const SizedBox(height: 2.5),
                Text('${widget.data.description}',
                    style: TextStyles.textGray10,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: '¥',
                            style: TextStyle(
                                fontSize: Dimens.font_sp12, color: Colors.red)),
                        TextSpan(
                            text:
                                '${Utils.formatPriceWithoutSymbol(widget.data.price.toString())}',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.red,
                                fontFamily: 'DINRegular')),
                      ]),
                    ),
                    Spacer(),
                    _buildOptions(widget.data)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptions(CartGoodsBean goods) {
    OrderProvider provider = Provider.of<OrderProvider>(context, listen: true);

    List<CartGoodsBean> cartGoods = provider.findCartGoods(goods);

    if (goods.propertyList != null && goods.propertyList.isNotEmpty) {
      return Container(
        width: 100.0,
        height: 33.5,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              right: 15.0,
              child: LabelText(
                padding: const EdgeInsets.fromLTRB(12.5, 4, 12.5, 4),
                radius: 12.5,
                text: '选规格',
                backgroundColor: ColorUtils.hexToColor('#2567FE'),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  showElasticDialog(
                      context: context,
                      builder: (_) {
                        return GoodsTypeDialog(goods, context);
                      });
                },
              ),
            ),
            Positioned(
              top: 0.0,
              right: 6.0,
              child: Visibility(
                visible: cartGoods.isNotEmpty,
                child: LabelText(
                  key: Key('goods_count'),
                  shape: BoxShape.circle,
                  backgroundColor: Colors.red,
                  text: '${cartGoods.length}',
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Row(
        children: <Widget>[
          Visibility(
            visible: cartGoods.isNotEmpty,
            child: GestureDetector(
              onTap: () => provider.removeCartGoods(goods),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 7, 5),
                child: LoadAssetImage(
                  'ic_reduce',
                  width: 21.85,
                  height: 21.85,
                ),
              ),
            ),
          ),
          Visibility(
            visible: cartGoods.isNotEmpty,
            child: Container(
              width: 20,
              alignment: Alignment.center,
              child: Text('${cartGoods.length}', style: TextStyles.textBlack14),
            ),
          ),
          GestureDetector(
            onTap: () {
              final BallAnimProvider ballAnimProvider =
                  Provider.of<BallAnimProvider>(context,listen: false);

              // 获取Widget树中真正的盒子对象
              RenderBox renderBox = _addWidgetKey.currentContext.findRenderObject();
              // 小球大小保存到全局
              ballAnimProvider.ballSize = Size(16, 16);
              // 小球的在屏幕的位置保存到全局
              ballAnimProvider.ballPosition = renderBox.localToGlobal(Offset.zero);
              // 回调这个启动动画的函数
              ballAnimProvider.notifyStartAnim();

              provider.addCartGoods(goods);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(7, 5, 15, 5),
              child: LoadAssetImage(
                'ic_add',
                key: _addWidgetKey,
                width: 21.85,
                height: 21.85,
              ),
            ),
          )
        ],
      );
    }
  }
}
