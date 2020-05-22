import 'package:order/entity/property.dart';

///需要添加到购物车的实体类(覆写hashcode)
class CartGoodsBean {
  int id;
  String img;
  String name;
  String description;
  double price;
  int type;
  String properties = '';
  List<Property> propertyList;

  CartGoodsBean({this.id,
    this.img,
    this.name,
    this.description,
    this.type,
    this.price,
    this.properties,
    this.propertyList});

  factory CartGoodsBean.fromJson(Map<String, dynamic> json) {
    return CartGoodsBean(
        id: json['id'],
        img: json['img'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        type: json['type'],
        properties: json['properties'],
        propertyList: json['propertyList'] != null
            ? (json['propertyList'] as List)
            .map((i) => Property.fromJson(i))
            .toList()
            : null
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.img;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['type'] = this.type;
    data['properties'] = this.properties;
    if (this.propertyList != null) {
      data['propertyList'] = this.propertyList.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartGoodsBean &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              img == other.img &&
              name == other.name &&
              description == other.description &&
              price == other.price &&
              type == other.type &&
              properties == other.properties ;

  @override
  int get hashCode =>
      id.hashCode ^
      img.hashCode ^
      name.hashCode ^
      description.hashCode ^
      price.hashCode ^
      type.hashCode ^
      properties.hashCode ;
}
