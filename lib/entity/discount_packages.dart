import 'property.dart';

class DiscountPackages {
  int ableDiscount;
  int ableReturn;
  String cid;
  String description;
  int id;
  String img;
  int isLowConsume;
  String modifier;
  String name;
  double price;
  String propertyIds;
  List<Property> propertyList;
  int type;

  DiscountPackages(
      {this.ableDiscount,
        this.ableReturn,
        this.cid,
        this.description,
        this.id,
        this.img,
        this.isLowConsume,
        this.modifier,
        this.name,
        this.price,
        this.propertyIds,
        this.propertyList,
        this.type});

  factory DiscountPackages.fromJson(Map<String, dynamic> json) {
    return DiscountPackages(
      ableDiscount: json['ableDiscount'],
      ableReturn: json['ableReturn'],
      cid: json['cid'],
      description: json['description'] != null ? json['description'] : '',
      id: json['id'],
      img: json['img'],
      isLowConsume: json['isLowConsume'],
      modifier: json['modifier'],
      name: json['name'],
      price: json['price'],
      propertyIds: json['propertyIds'],
      propertyList: json['propertyList'] != null
          ? (json['propertyList'] as List)
          .map((i) => Property.fromJson(i))
          .toList()
          : null,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ableDiscount'] = this.ableDiscount;
    data['ableReturn'] = this.ableReturn;
    data['cid'] = this.cid;
    data['id'] = this.id;
    data['img'] = this.img;
    data['isLowConsume'] = this.isLowConsume;
    data['modifier'] = this.modifier;
    data['name'] = this.name;
    data['price'] = this.price;
    data['propertyIds'] = this.propertyIds;
    data['type'] = this.type;
    if (this.description != null) {
      data['description'] = this.description;
    }
    if (this.propertyList != null) {
      data['propertyList'] = this.propertyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}