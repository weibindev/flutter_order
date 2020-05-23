import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../entity/cart_goods_bean.dart';
import '../../../res/resources.dart';
import '../../../util/color_utils.dart';
import '../../../util/utils.dart';
import '../../../widgets/label_text.dart';
import '../../../widgets/load_image.dart';
import '../provider/ball_anim_provider.dart';
import '../provider/order_provider.dart';
import 'goods_type_dialog.dart';

class GoodsOptions extends StatefulWidget {
  final CartGoodsBean data;

  GoodsOptions({Key key, this.data}) : super(key: key);

  @override
  _GoodsOptionsState createState() => _GoodsOptionsState();
}

class _GoodsOptionsState extends State<GoodsOptions> {
  GlobalKey _addWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    OrderProvider provider = Provider.of<OrderProvider>(context, listen: true);

    List<CartGoodsBean> cartGoods = provider.findCartGoods(widget.data);

    if (widget.data.propertyList != null && widget.data.propertyList.isNotEmpty) {
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
                        return GoodsTypeDialog(widget.data, context);
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
              onTap: () => provider.removeCartGoods(widget.data),
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
              Provider.of<BallAnimProvider>(context, listen: false);

              // 获取Widget树中真正的盒子对象
              RenderBox renderBox =
              _addWidgetKey.currentContext.findRenderObject();
              // 小球大小保存到全局
              ballAnimProvider.ballSize = Size(16, 16);
              // 小球的在屏幕的位置保存到全局
              ballAnimProvider.ballPosition =
                  renderBox.localToGlobal(Offset.zero);
              // 回调这个启动动画的函数
              ballAnimProvider.notifyStartAnim();

              provider.addCartGoods(widget.data);
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
