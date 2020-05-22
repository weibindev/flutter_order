import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:order/entity/base_entity.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/entity/goods.dart';
import 'package:order/provider/base_list_provider.dart';
import 'package:order/ui/order/widgets/goods_item.dart';
import 'package:order/widgets/state_layout.dart';
import 'package:provider/provider.dart';

class SubItemPage extends StatefulWidget {
  final int id;

  SubItemPage({Key key, this.id})
      : super(key: key);

  @override
  _SubItemPageState createState() => _SubItemPageState();
}

class _SubItemPageState extends State<SubItemPage>
    with AutomaticKeepAliveClientMixin {
  BaseListProvider<GoodsBean> provider = BaseListProvider();

  @override
  void initState() {
    super.initState();
    provider.setStateType(StateType.loading);
    getGoodsList(widget.id);
  }

  void getGoodsList(int typeId) {
    try {
      rootBundle.loadString('assets/data/goods_$typeId.json').then((value) {
        BaseEntity<GoodsBean> result =
        BaseEntity.fromJson(jsonDecode(value));

        if (result != null) {
          if (result.listData.isEmpty || result.listData == null) {
            provider.setStateType(StateType.empty);
          } else {
            provider.addAll(result.listData);
          }
        } else {
          provider.setStateType(StateType.empty);
        }
      });
    } catch (e) {
      print(e);
      provider.setStateType(StateType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<BaseListProvider<GoodsBean>>(
      create: (_) => provider,
      child: Consumer<BaseListProvider<GoodsBean>>(
        builder: (context, provider, child) {
          return provider.list.isEmpty
              ? StateLayout(type: provider.stateType)
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 49),
                  physics: BouncingScrollPhysics(),
                  itemCount: provider.list.length,
                  itemBuilder: (context, index) {
                    GoodsBean goodsBean = provider.list[index];
                      CartGoodsBean cartGoodsBean = CartGoodsBean(
                          id: goodsBean.id,
                          img: goodsBean.img,
                          name: goodsBean.goodsName,
                          description: goodsBean.description,
                          price: goodsBean.price,
                          type: 1,
                          propertyList: goodsBean.propertyList);
                      return GoodsItem(data: cartGoodsBean);
                  });
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
