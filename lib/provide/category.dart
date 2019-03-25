import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/service_method.dart';

class CategoryProvider with ChangeNotifier {
  int leftIndex = 0;
  int rightTopIndex = 1;

  //左侧导航
  List<CategoryData> categoryList = [];

  //右侧头部导航
  List<CategoryDataBxmallsubdto> childCategoryList = [];

  //右侧商品列表
  List<CategoryGoodsListData> categoryGoodsList = [];

  setCategoryList(List<CategoryData> list) {
    categoryList = list ?? [];
    notifyListeners();
  }


  setChildCategory(int index) {
    CategoryDataBxmallsubdto all = CategoryDataBxmallsubdto(
        mallsubid: '00',
        mallcategoryid: '00',
        comments: 'null',
        mallsubname: '全部');

    leftIndex = index;
    childCategoryList = [all];
    childCategoryList.addAll(categoryList[leftIndex].bxmallsubdto);
    notifyListeners();
  }

  //点击大类时，根据大类ID信息获取商品列表
  setGoodsList(int page, int index) {
    CategoryDataBxmallsubdto item = childCategoryList[index];
    getMallGoods(item.mallcategoryid, item.mallsubid, page).then((value) {
      categoryGoodsList = value ?? [];
      rightTopIndex = index;
      notifyListeners();
    });
  }
}
