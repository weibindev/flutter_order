class Sort {
  String cid;
  int id;
  int parentId;
  int status;
  int isWine; //是否酒类 0：否，1：是
  String typeCode;
  String typeName;

  Sort(
      {this.cid,
        this.id,
        this.parentId,
        this.status,
        this.isWine,
        this.typeCode,
        this.typeName});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      cid: json['cid'],
      id: json['id'],
      parentId: json['parentId'],
      status: json['status'],
      isWine: json['isWine'],
      typeCode: json['typeCode'],
      typeName: json['typeName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.cid;
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['status'] = this.status;
    data['isWine'] = this.isWine;
    data['typeCode'] = this.typeCode;
    data['typeName'] = this.typeName;
    return data;
  }
}