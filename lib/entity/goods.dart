import 'property.dart';

class GoodsBean {
  int ableDiscount;
  int ableReturn;
  String cid;
  String delayDays;
  String description;
  String goodsName;
  int id;
  String img;
  int isLowConsume;
  double storeMinCount; //起存数量
  int isWholeStore; //整存或零存（1整存，2零存）
  int maxDelayCount;
  double price;
  int printId;
  String printName;
  String propertyIds;
  double selfPrice;
  int status;
  int stock;
  int typeId;
  String typeName;
  String unit;
  List<Property> propertyList;

  GoodsBean(
      {this.ableDiscount,
        this.ableReturn,
        this.cid,
        this.delayDays,
        this.description,
        this.goodsName,
        this.id,
        this.img,
        this.isLowConsume,
        this.storeMinCount,
        this.isWholeStore,
        this.maxDelayCount,
        this.price,
        this.printId,
        this.printName,
        this.propertyIds,
        this.selfPrice,
        this.status,
        this.stock,
        this.typeId,
        this.typeName,
        this.unit,
        this.propertyList});

  factory GoodsBean.fromJson(Map<String, dynamic> json) {
    return GoodsBean(
      ableDiscount: json['ableDiscount'],
      ableReturn: json['ableReturn'],
      cid: json['cid'],
      delayDays: json['delayDays'] != null ? json['delayDays'] : '',
      description: json['description'] != null ? json['description'] : '',
      goodsName: json['goodsName'],
      id: json['id'],
      img: json['img'],
      isLowConsume: json['isLowConsume'],
      storeMinCount:
      json['storeMinCount'] != null ? json['storeMinCount'] : 0.0,
      isWholeStore: json['isWholeStore'] != null ? json['isWholeStore'] : -1,
      maxDelayCount: json['maxDelayCount'] != null ? json['maxDelayCount'] : -1,
      price: json['price'],
      printId: json['printId'],
      printName: json['printName'],
      propertyIds: json['propertyIds'],
      selfPrice: json['selfPrice'],
      status: json['status'],
      stock: json['stock'],
      typeId: json['typeId'],
      typeName: json['typeName'],
      unit: json['unit'],
      propertyList: json['propertyList'] != null
          ? (json['propertyList'] as List)
          .map((i) => Property.fromJson(i))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ableDiscount'] = this.ableDiscount;
    data['ableReturn'] = this.ableReturn;
    data['cid'] = this.cid;
    data['goodsName'] = this.goodsName;
    data['id'] = this.id;
    data['img'] = this.img;
    data['isLowConsume'] = this.isLowConsume;
    data['price'] = this.price;
    data['printId'] = this.printId;
    data['printName'] = this.printName;
    data['propertyIds'] = this.propertyIds;
    data['selfPrice'] = this.selfPrice;
    data['status'] = this.status;
    data['stock'] = this.stock;
    data['typeId'] = this.typeId;
    data['typeName'] = this.typeName;
    data['unit'] = this.unit;
    if (this.delayDays != null) {
      data['delayDays'] = this.delayDays;
    }
    if (this.description != null) {
      data['description'] = this.description;
    }
    if (this.storeMinCount != null) {
      data['storeMinCount'] = this.storeMinCount;
    }
    if (this.isWholeStore != null) {
      data['isWholeStore'] = this.isWholeStore;
    }
    if (this.maxDelayCount != null) {
      data['maxDelayCount'] = this.maxDelayCount;
    }
    if (this.propertyList != null) {
      data['propertyList'] = this.propertyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
