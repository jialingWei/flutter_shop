import 'package:flutter_shop/model/BaseEntity.dart';

class CategoryEntity {
  String code;
  List<CategoryData> data;
  String message;

  CategoryEntity({this.code, this.data, this.message});

  CategoryEntity.fromJson(Map<String, dynamic> json) {
    var baseListEntity = BaseListEntity.fromJson(json, (itemData) {
      CategoryData.fromJson(itemData);
    });
    data = baseListEntity.data;
    message = baseListEntity.message;
    data = baseListEntity.data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CategoryData {
  String image; //类别图片
  List<CategoryDataBxmallsubdto> bxmallsubdto;
  Null comments; //类别描述，目前全是null
  String mallcategoryid; //类别ID
  String mallcategoryname; //类别名称

  CategoryData(
      {this.image,
      this.bxmallsubdto,
      this.comments,
      this.mallcategoryid,
      this.mallcategoryname});

  CategoryData.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    if (json['bxMallSubDto'] != null) {
      bxmallsubdto = new List<CategoryDataBxmallsubdto>();
      (json['bxMallSubDto'] as List).forEach((v) {
        bxmallsubdto.add(new CategoryDataBxmallsubdto.fromJson(v));
      });
    }
    comments = json['comments'];
    mallcategoryid = json['mallCategoryId'];
    mallcategoryname = json['mallCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    if (this.bxmallsubdto != null) {
      data['bxMallSubDto'] = this.bxmallsubdto.map((v) => v.toJson()).toList();
    }
    data['comments'] = this.comments;
    data['mallCategoryId'] = this.mallcategoryid;
    data['mallCategoryName'] = this.mallcategoryname;
    return data;
  }
}

class CategoryDataBxmallsubdto {
  String mallsubname;
  String comments;
  String mallcategoryid;
  String mallsubid;

  CategoryDataBxmallsubdto(
      {this.mallsubname, this.comments, this.mallcategoryid, this.mallsubid});

  CategoryDataBxmallsubdto.fromJson(Map<String, dynamic> json) {
    mallsubname = json['mallSubName'];
    comments = json['comments'];
    mallcategoryid = json['mallCategoryId'];
    mallsubid = json['mallSubId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mallSubName'] = this.mallsubname;
    data['comments'] = this.comments;
    data['mallCategoryId'] = this.mallcategoryid;
    data['mallSubId'] = this.mallsubid;
    return data;
  }
}
