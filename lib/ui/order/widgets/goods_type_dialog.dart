import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:order/common/common.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/entity/property.dart';
import 'package:order/res/resources.dart';
import 'file:///D:/GitHub-Flutter/flutter_order/lib/util/navigator_utils.dart';
import 'package:order/ui/order/provider/order_provider.dart';
import 'package:order/util/color_utils.dart';
import 'package:order/widgets/load_image.dart';
import 'package:provider/provider.dart';

class GoodsTypeDialog extends StatefulWidget {
  final CartGoodsBean data;
  final BuildContext context;

  GoodsTypeDialog(this.data, this.context);

  @override
  _GoodsTypeDialogState createState() => _GoodsTypeDialogState();
}

class _GoodsTypeDialogState extends State<GoodsTypeDialog> {

  ///商品属性map
  Map<String, List<Property>> propertyMap = Map();

  //最多考虑有三种的口味选择
  int index1 = 0;
  int index2 = 0;
  int index3 = 0;

  @override
  void initState() {
    super.initState();
    initPropertyMap();
    widget.data.properties = _getProperties();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets +
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeInCubic,
      child: MediaQuery.removeViewInsets(
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          context: context,
          child: Center(
            child: SizedBox(
              width: 270.0,
              height: 200 + (propertyMap.keys.length - 1) * 40.0,
              child: Material(
                borderRadius: BorderRadius.circular(7.5),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 53.5,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.only(top: 10.5),
                            child: Text(widget.data.name,
                                style: TextStyle(
                                    fontSize: Dimens.font_sp16,
                                    color: Colours.black_text)),
                          ),
                          Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Semantics(
                              label: '关闭',
                              child: GestureDetector(
                                  onTap: () => NavigatorUtils.goBack(context),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 8.0),
                                    child: const LoadAssetImage(
                                      'ic_close',
                                      width: 28.0,
                                      height: 28.0,
                                      key: const Key('dialog_close'),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildProperty(),
                    ),
                    Container(
                        height: 46.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7.5),
                              bottomRight: Radius.circular(7.5)),
                          color: Colours.dark_button_text,
                        ),
                        padding: const EdgeInsets.fromLTRB(19.5, 7.5, 8, 8),
                        child: _buildOptions())
                  ],
                ),
              ),
            ),
          )),
    );
  }

  ///拿到事先存储的商品属性,再根据id来设置map
  initPropertyMap() {
    List<Property> propertyList =
        SpUtil.getObjList(Constant.property, (v) => Property.fromJson(v));
    propertyList.forEach((property) {
      for (var value in widget.data.propertyList) {
        if (value.parentId == property.id) {
          if (propertyMap.containsKey(property.propertyName)) {
            propertyMap[property.propertyName].add(value);
          } else {
            List<Property> list = [];
            list.add(value);
            propertyMap[property.propertyName] = list;
          }
        }
      }
    });
  }

  ///构建商品属性组件
  Widget _buildProperty() {
    List<Widget> list = List.generate(propertyMap.keys.length, (i) {
      List<Property> propertyList = propertyMap[propertyMap.keys.toList()[i]];
      int _index = 0;
      if (i == 0) {
        _index = index1;
      } else if (i == 1) {
        _index = index2;
      } else {
        _index = index3;
      }

      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text('${propertyMap.keys.toList()[i]}',
                style: TextStyles.textBlack12),
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(17, 10, 17, 10),
              itemCount: propertyList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                  childAspectRatio: 2.123),
              itemBuilder: (_, index) {
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.5),
                      color: _index == index
                          ? ColorUtils.hexToColor('#FFF6E9')
                          : Colors.transparent,
                      border: Border.all(
                          color: _index == index
                              ? ColorUtils.hexToColor('#FFBD67')
                              : ColorUtils.hexToColor('#CCCCCC'),
                          width: 0.5),
                    ),
                    child: Text('${propertyList[index].propertyName}',
                        style: TextStyle(
                            color: _index == index
                                ? ColorUtils.hexToColor('#FF932D')
                                : Colours.black_text,
                            fontSize: Dimens.font_sp12)),
                  ),
                  onTap: () {
                    setState(() {
                      _index = index;

                      if (i == 0) {
                        index1 = _index;
                      } else if (i == 1) {
                        index2 = _index;
                      } else if (i == 2) {
                        index3 = _index;
                      }

                      widget.data.properties = _getProperties();
                    });
                  },
                );
              }),
        ],
      );
    });

    return Column(
      children: list,
    );
  }

  Widget _buildOptions() {
    OrderProvider provider =
        Provider.of<OrderProvider>(widget.context, listen: false);

    List<CartGoodsBean> cartGoodsWithProperties =
        provider.findCartGoodsWithProperty(widget.data);

    return Row(
      children: <Widget>[
        Visibility(
          visible: cartGoodsWithProperties.isNotEmpty,
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    provider.removeCartGoods(widget.data);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 7, 5),
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
                child: Text('${cartGoodsWithProperties.length}',
                    style: TextStyles.textBlack14),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    provider.addCartGoods(widget.data);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 5, 15, 5),
                  child: LoadAssetImage(
                    'ic_add',
                    width: 21.85,
                    height: 21.85,
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        Visibility(
          visible: cartGoodsWithProperties.isEmpty,
          child: Container(
            width: 63,
            height: 31,
            child: FlatButton(
              key: Key('btn_add_dialog'),
              onPressed: () {
                setState(() {
                  provider.addCartGoods(widget.data);
                });
              },
              child: Text('确认'),
              textColor: Colors.white,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  String _getProperties() {
    String _properties = '';
    if (propertyMap.keys.length == 1) {
      _properties =
          propertyMap[propertyMap.keys.toList()[0]][index1].id.toString();
    } else if (propertyMap.keys.length == 2) {
      _properties =
          '${propertyMap[propertyMap.keys.toList()[0]][index1].id},${propertyMap[propertyMap.keys.toList()[1]][index2].id}';
    } else {
      _properties =
          '${propertyMap[propertyMap.keys.toList()[0]][index1].id},${propertyMap[propertyMap.keys.toList()[1]][index2].id},${propertyMap[propertyMap.keys.toList()[2]][index3].id}';
    }

    return _properties;
  }
}
