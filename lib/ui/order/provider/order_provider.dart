import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:order/common/common.dart';
import 'package:order/entity/cart_goods_bean.dart';
import 'package:order/entity/sort.dart';
import 'package:order/util/utils.dart';

///点单的状态管理
class OrderProvider extends ChangeNotifier {
  ///左侧菜单分类
  final List<Sort> _sortList = [];

  List<Sort> get sortList => _sortList;

  ///填充左侧菜单和缓存数据
  void setSortList(List<Sort> data) {
    _sortList.addAll(data);

    List<CartGoodsBean> cartGoods =
        SpUtil.getObjList(Constant.cartGoods, (v) => CartGoodsBean.fromJson(v));
    if (cartGoods != null) {
      _cartGoodsList.addAll(cartGoods);
    }

    List<CartGoodsBean> sortGoods =
        SpUtil.getObjList(Constant.sortGoods, (v) => CartGoodsBean.fromJson(v));

    if (sortGoods != null) {
      _cartGoodsSort.addAll(sortGoods);
    }

    //两个都不为空的情况下，有缓存数据，取出对应的商品数量索引
    if (_cartGoodsList.isNotEmpty && _cartGoodsSort.isNotEmpty) {
      _cartGoodsSort.forEach((value) {
        if (value.properties != null && value.properties.isNotEmpty) {
          List<CartGoodsBean> goodsWithProMap = _cartGoodsList
              .where((goods) =>
                  _buildGoodsPropertyKey(goods) ==
                  _buildGoodsPropertyKey(value))
              .toList();
          if (goodsWithProMap != null) {
            _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(value)] =
                goodsWithProMap;
          }
        } else {
          List<CartGoodsBean> goodsMap =
              _cartGoodsList.where((goods) => _buildGoodsKey(goods) == _buildGoodsKey(value)).toList();
          if (goodsMap != null) {
            _cartGoodsMap[_buildGoodsKey(value)] = goodsMap;
          }
        }
      });
    }

    notifyListeners();
  }

  ///右侧二级菜单map
  final Map<int, List<Sort>> _subSortMap = Map();

  Map<int, List<Sort>> get subSortMap => _subSortMap;

  ///设置右侧tab的map数据
  void setSubSortList(List<Sort> data) {
    for (var value in data) {
      if (_subSortMap.containsKey(value.parentId)) {
        _subSortMap[value.parentId].add(value);
      } else {
        List<Sort> list = [];
        list.add(value);
        _subSortMap[value.parentId] = list;
      }
    }
    notifyListeners();
  }

  ///添加到购物车的商品
  final List<CartGoodsBean> _cartGoodsList = [];

  List<CartGoodsBean> get cartGoodsList => _cartGoodsList;

  ///维护购物车中的商品分类
  final List<CartGoodsBean> _cartGoodsSort = [];

  List<CartGoodsBean> get cartGoodsSort => _cartGoodsSort;

  ///维护商品规格的map
  //没有商品属性
  final Map<String, List<CartGoodsBean>> _cartGoodsMap = Map();

  //有商品属性
  final Map<String, List<CartGoodsBean>> _cartGoodsWithPropertyMap = Map();

  ///添加商品
  void addCartGoods(CartGoodsBean goods) {
    CartGoodsBean cartGoodsBean = CartGoodsBean(
        id: goods.id,
        img: goods.img,
        name: goods.name,
        description: goods.description,
        price: goods.price,
        type: goods.type,
        properties: goods.properties,
        propertyList: goods.propertyList);
    _cartGoodsList.add(cartGoodsBean);
    if (goods.properties != null && goods.properties.isNotEmpty) {
      if (_cartGoodsWithPropertyMap
          .containsKey(_buildGoodsPropertyKey(goods))) {
        _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goods)]
            .add(cartGoodsBean);
      } else {
        List<CartGoodsBean> list = [];
        list.add(cartGoodsBean);
        _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goods)] = list;
        _cartGoodsSort.add(cartGoodsBean);
      }
    } else {
      if (_cartGoodsMap.containsKey(_buildGoodsKey(goods))) {
        _cartGoodsMap[_buildGoodsKey(goods)].add(cartGoodsBean);
      } else {
        List<CartGoodsBean> list = [];
        list.add(cartGoodsBean);
        _cartGoodsMap[_buildGoodsKey(goods)] = list;
        _cartGoodsSort.add(cartGoodsBean);
      }
    }
    _save();
    notifyListeners();
  }

  ///从购物车中移除商品
  void removeCartGoods(CartGoodsBean goods) {
    _cartGoodsList.remove(goods);
    if (goods.properties != null && goods.properties.isNotEmpty) {
      if (_cartGoodsWithPropertyMap
          .containsKey(_buildGoodsPropertyKey(goods))) {
        _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goods)].remove(goods);
        if (_cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goods)] == null ||
            _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goods)].isEmpty) {
          _cartGoodsSort.remove(goods);
          _cartGoodsWithPropertyMap.remove(_buildGoodsPropertyKey(goods));
        }
      }
    } else {
      if (_cartGoodsMap.containsKey(_buildGoodsKey(goods))) {
        _cartGoodsMap[_buildGoodsKey(goods)].remove(goods);
        if (_cartGoodsMap[_buildGoodsKey(goods)] == null ||
            _cartGoodsMap[_buildGoodsKey(goods)].isEmpty) {
          _cartGoodsSort.remove(goods);
          _cartGoodsMap.remove(_buildGoodsKey(goods));
        }
      }
    }
    _save();
    notifyListeners();
  }

  ///清空购物车
  void removeAllCartGoods() {
    _removeAll();
    _cartGoodsList.clear();
    _cartGoodsSort.clear();
    _cartGoodsWithPropertyMap.clear();
    _cartGoodsMap.clear();
    notifyListeners();
  }

  ///获得购物车中的商品
  List<CartGoodsBean> findCartGoods(CartGoodsBean goodsBean) {
    if (_cartGoodsMap.containsKey(_buildGoodsKey(goodsBean))) {
      return _cartGoodsMap[_buildGoodsKey(goodsBean)];
    } else {
      return _cartGoodsList.where((goods) => _buildGoodsKey(goods) == _buildGoodsKey(goodsBean)).toList();
    }
  }

  ///获得购物车中带属性的商品
  List<CartGoodsBean> findCartGoodsWithProperty(CartGoodsBean goodsBean) {
    if (_cartGoodsWithPropertyMap.containsKey(_buildGoodsPropertyKey(goodsBean))) {
      return _cartGoodsWithPropertyMap[_buildGoodsPropertyKey(goodsBean)];
    } else {
      return List<CartGoodsBean>();
    }
  }

  ///获得购物车的商品总价
  String getCartGoodsPrice() {
    if (_cartGoodsList.isEmpty) {
      return '未选购任何商品';
    } else {
      double totalPrice = 0.0;
      for (var value in _cartGoodsList) {
        totalPrice += value.price;
      }
      return Utils.formatPrice(totalPrice.toString());
    }
  }

  GestureTapCallback _showShopCarListCallback = () {};

  set showShopCarListCallback(GestureTapCallback voidCallback) {
    this._showShopCarListCallback = voidCallback;
  }

  void clickShopCarButton() {
    _showShopCarListCallback();
  }

  ///对数据进行持久化存储
  void _save() {
    SpUtil.putObjectList(Constant.cartGoods, _cartGoodsList);
    SpUtil.putObjectList(Constant.sortGoods, _cartGoodsSort);
  }

  ///删除持久化数据
  void _removeAll() {
    SpUtil.remove(Constant.cartGoods);
    SpUtil.remove(Constant.sortGoods);
  }

  ///构建没有属性的key,避免套餐和商品id重复
  String _buildGoodsKey(CartGoodsBean goods) {
    return 'type:${goods.type},id:${goods.id}';
  }

  ///构建有属性的key,避免套餐和商品id重复
  String _buildGoodsPropertyKey(CartGoodsBean goods) {
    return 'type:${goods.type},id:${goods.id},properties:${goods.properties}';
  }
}
