import 'package:flutter/material.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/pages/goods_detail_page.dart';
import 'package:order/ui/order/widgets/goods_options.dart';
import 'package:order/util/utils.dart';
import 'package:order/widgets/load_image.dart';

/// 商品Item组件
class GoodsItem extends StatefulWidget {
  final CartGoodsBean data;

  GoodsItem({Key key, this.data}) : super(key: key);

  @override
  _GoodsItemState createState() => _GoodsItemState();
}

class _GoodsItemState extends State<GoodsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 12.5, 0.0, 12.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
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
                                  fontSize: Dimens.font_sp12,
                                  color: Colors.red)),
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
                      //商品的加减操作
                      GoodsOptions(data: widget.data)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GoodsDetailsPage(data: widget.data)));
      },
    );
  }
}
