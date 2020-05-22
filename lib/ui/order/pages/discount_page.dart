import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:order/provider/base_list_provider.dart';
import 'package:order/entity/base_entity.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/entity/discount_packages.dart';
import 'package:order/ui/order/widgets/goods_item.dart';
import 'package:order/widgets/state_layout.dart';

class DiscountPage extends StatefulWidget {
  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage>
    with AutomaticKeepAliveClientMixin {
  BaseListProvider<DiscountPackages> provider = BaseListProvider();

  @override
  void initState() {
    super.initState();
    provider.setStateType(StateType.loading);
    getDiscountPackages();
  }

  void getDiscountPackages() {

    try {
      rootBundle.loadString('assets/data/discount.json').then((value) {
        BaseEntity<DiscountPackages> result =
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
    return ChangeNotifierProvider<BaseListProvider<DiscountPackages>>(
      create: (_) => provider,
      child: Consumer<BaseListProvider<DiscountPackages>>(
        builder: (context, provider, child) {
          return provider.list.isEmpty
              ? StateLayout(type: provider.stateType)
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 49),
                  physics: BouncingScrollPhysics(),
                  itemCount: provider.list.length,
                  itemBuilder: (context, index) {
                    DiscountPackages discountPackages = provider.list[index];
                    CartGoodsBean cartGoodsBean = CartGoodsBean(
                        id: discountPackages.id,
                        img: discountPackages.img,
                        name: discountPackages.name,
                        description: discountPackages.description,
                        price: discountPackages.price,
                        type: 2,
                        propertyList: discountPackages.propertyList);
                    return GoodsItem(data: cartGoodsBean);
                  });
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
