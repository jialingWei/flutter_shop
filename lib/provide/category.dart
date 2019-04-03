import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/service_method.dart';

class CategoryProvider with ChangeNotifier {
  int leftIndex = 0;
  int rightTopIndex = 0;

  int page = 1;

  String noMoreText = "没有更多数据了";

  //左侧导航
  List<CategoryData> leftCategoryList = [];

  //右侧头部导航
  List<CategoryDataBxmallsubdto> rightTopCategoryList = [];

  //右侧商品列表
  List<CategoryGoodsListData> rightGoodsList = [];

  initLeftList(List<CategoryData> list) {
    leftCategoryList = list ?? [];
    setLeftCategoryList(0);
  }

  setLeftCategoryList(int index) {
    leftIndex = index;
    setRightTopCategory(0);
  }

  setRightTopCategory(int index) {
    rightTopIndex = index;
    page = 1;
    rightTopCategoryList.clear();
    rightTopCategoryList.addAll(leftCategoryList[leftIndex].bxmallsubdto);
    rightGoodsList.clear();
    setGoodsList(page);
  }

  loadMoreGoodsList() {
    setGoodsList(page + 1);
  }

  setGoodsList(int currentPage) {
    CategoryDataBxmallsubdto item = rightTopCategoryList[rightTopIndex];
    getMallGoods(item.mallcategoryid, item.mallsubid, currentPage)
        .then((value) {
      page = currentPage;
      if (value != null) {
        rightGoodsList.addAll(value);
        noMoreText = "后面还有更多哦~~";
      } else {
        rightGoodsList.addAll([]);
        noMoreText = "没有更多数据了";
      }
      notifyListeners();
    });
  }
}
