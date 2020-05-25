import 'package:flutter/material.dart';
import 'package:order/ui/order/widgets/goods_options.dart';
import 'package:order/widgets/preferred_hero_img_bar.dart';
import '../../../entity/cart_goods_bean.dart';
import '../../../res/resources.dart';
import '../../../util/utils.dart';

///商品详情页
class GoodsDetailsPage extends StatefulWidget {
  final CartGoodsBean data;

  GoodsDetailsPage({Key key, this.data}) : super(key: key);

  @override
  _GoodsDetailsPageState createState() => _GoodsDetailsPageState();
}

class _GoodsDetailsPageState extends State<GoodsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///封装的appBar
      appBar: PreferredHeroImgBar(
          tag: widget.data, imageUrl: '${widget.data.img}'),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.data.name,
              style: TextStyles.textBold24,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 2.5),
            Text(
              '月销 100',
              style: TextStyles.textGray14,
            ),
            const SizedBox(height: 2.5),
            Text('${widget.data.description}',
                style: TextStyles.textGray14,
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
                            fontSize: Dimens.font_sp16,
                            color: Colors.red)),
                    TextSpan(
                        text:
                        '${Utils.formatPriceWithoutSymbol(widget.data.price.toString())}',
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.red,
                            fontFamily: 'DINRegular')),
                  ]),
                ),
                Spacer(),
                //商品的加减操作
                GoodsOptions(data: widget.data)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
