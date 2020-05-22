class Property {
  int id;
  String cid;
  String propertyName;
  int parentId;

  Property({this.id, this.cid, this.propertyName, this.parentId});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      cid: json['cid'],
      propertyName: json['propertyName'],
      parentId: json['parentId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['id'] = this.id;
    data['propertyName'] = this.propertyName;
    data['parentId'] = this.parentId;
    return data;
  }
}