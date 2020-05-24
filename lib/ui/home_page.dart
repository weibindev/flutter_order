import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:order/common/common.dart';
import 'package:order/res/gaps.dart';
import 'package:order/res/resources.dart';
import 'package:order/ui/order/pages/order_page.dart';
import 'package:order/widgets/label_text.dart';
import 'package:order/widgets/load_image.dart';
import 'package:order/widgets/tool_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _goodsItem = 0;

  @override
  void initState() {
    super.initState();
    List<dynamic> goodsList = SpUtil.getObjectList(Constant.cartGoods);
    if (goodsList != null && goodsList.isNotEmpty) {
      _goodsItem = goodsList.length;
    }
//    _goodsItem = SpUtil.getObjectList(Constant.cartGoods).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(
        centerTitle: '大爷，来点东西玩玩啊',
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        LoadImage(
                          'https://img.meituan.net/msmerchant/77830c7aeb655a5e29bc3905ff7a648c2028276.jpg',
                          width: 120.0,
                          height: 80.0,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Visibility(
                            visible: _goodsItem != 0,
                            child: LabelText(
                              shape: BoxShape.circle,
                              backgroundColor: Colors.red,
                              text: '$_goodsItem',
                              padding: const EdgeInsets.all(5),
                            ),
                          ),
                        )
                      ],
                    ),
                    Gaps.hGap10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('客官里面请', style: TextStyles.textBold18),
                        Gaps.vGap10,
                        Text('好酒好菜应有尽有', style: TextStyles.text),
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => OrderPage()))
                    .then((value) {
                  setState(() {
                    if (value != null) {
                      _goodsItem = value;
                    }
                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
