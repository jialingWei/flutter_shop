import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_entity.dart';


class ChildCategory with ChangeNotifier{
  List<CategoryDataBxmallsubdto> childCategoryList = [];


  getChildCategory(List<CategoryDataBxmallsubdto> list){
    childCategoryList = list;
    notifyListeners();
  }

}