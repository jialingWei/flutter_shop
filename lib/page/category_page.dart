import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category_entity.dart';

import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品分类"),
      ),
      body: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

///左侧导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<CategoryData> list = [];
  int currentIndex = 0;
  List<CategoryDataBxmallsubdto> childRightList = [];

  @override
  void initState() {
    _loadCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
        itemCount: list.length,
      ),
    );
  }

  void _loadCategoryList() async {
    await getCategory().then((value) {
      var rep = json.decode(value.toString());
      CategoryEntity categoryList = CategoryEntity.fromJson(rep);
      categoryList.data.forEach((item) => print(item.mallcategoryname));
      setState(() {
        list = categoryList.data;
        childRightList = list[currentIndex].bxmallsubdto;
        Provide.value<ChildCategory>(context).getChildCategory(childRightList);
      });
    });
  }

  Widget _leftInkWell(int index) {
    return InkWell(
      onTap: () {
        var childList = list[index].bxmallsubdto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: currentIndex == index ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallcategoryname,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

///右侧顶部导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(builder: (context, child, childCategory) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategoryList[index]);
            }),
      );
    });
  }

  Widget _rightInkWell(CategoryDataBxmallsubdto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          item.mallsubname,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

///右侧具体商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  @override
  void initState() {
    super.initState();
    getMallGoods('4', '', 1).then((value){
      print("doublex---->value.length:${value.length}");
      value.forEach((item)=>print('doublex---->${item}'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
