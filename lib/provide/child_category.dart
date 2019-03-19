import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_entity.dart';


class ChildCategory with ChangeNotifier{
  List<CategoryDataBxmallsubdto> childCategoryList = [];


  getChildCategory(List<CategoryDataBxmallsubdto> list){
    CategoryDataBxmallsubdto all = CategoryDataBxmallsubdto(mallsubid:'00',mallcategoryid: '00',comments: 'null',mallsubname: '全部' );

    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

}