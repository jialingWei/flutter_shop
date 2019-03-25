import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/service_method.dart';

class CategoryProvider with ChangeNotifier {
  int currentIndex = 0;

  //左侧导航
  List<CategoryData> categoryList = [];

  //右侧头部导航
  List<CategoryDataBxmallsubdto> childCategoryList = [];

  //右侧商品列表
  List<CategoryGoodsListData> categoryGoodsList = [];

  //点击大类时，根据大类ID信息获取商品列表
  setCategoryList(List<CategoryData> list) {
    categoryList = list;
    notifyListeners();
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  setChildCategory(List<CategoryDataBxmallsubdto> list) {
    CategoryDataBxmallsubdto all = CategoryDataBxmallsubdto(
        mallsubid: '00',
        mallcategoryid: '00',
        comments: 'null',
        mallsubname: '全部');

    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //点击大类时，根据大类ID信息获取商品列表
  setGoodsList(String categoryId, String categorySubId, int page) {
    print('DoubleX---->categoryId:$categoryId');
    getMallGoods(categoryId, categorySubId, page).then((value) {
      categoryGoodsList = value;
      notifyListeners();
    });
  }
}
