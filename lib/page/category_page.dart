import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/category.dart';
import 'package:provide/provide.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/config/cached_network_img.dart';
import 'package:flutter_shop/model/category_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/service_method.dart';

var leftIndex = 0;
var rightTopIndex = 1;

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
                Expanded(
                  flex: 1,
                  child: CategoryGoodsList(),
                ),
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
  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _initData() async {
    await getCategory().then((value) {
      var rep = json.decode(value.toString());
      CategoryEntity categoryList = CategoryEntity.fromJson(rep);
      var list = categoryList.data;

      Provide.value<CategoryProvider>(context)

        ///1.左侧分类导航
        ..setCategoryList(list)

        ///2.根据左侧分类选中的右侧头部导航
        ..setChildCategory(leftIndex)

        ///3.根据右侧头部导航选中item的对应商品列表  默认取第二个导航类的ID去取值
        ..setGoodsList(1, rightTopIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: Provide<CategoryProvider>(builder: (context, child, data) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return _leftInkWell(index, data.leftIndex, data.categoryList);
          },
          itemCount: data.categoryList.length,
        );
      }),
    );
  }

  Widget _leftInkWell(int index, int currentIndex, List<CategoryData> list) {
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context)
          ..setChildCategory(index)
          ..setGoodsList(1, rightTopIndex);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Color.fromRGBO(236, 236, 236, 1.0)
                : Colors.white,
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
    return Provide<CategoryProvider>(builder: (context, child, data) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.childCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(data.childCategoryList[index],
                  index == data.rightTopIndex, index);
            }),
      );
    });
  }

  Widget _rightInkWell(CategoryDataBxmallsubdto item, bool isCheck, int index) {
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context).setGoodsList(1, index);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          item.mallsubname,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isCheck ? Colors.red : Colors.black),
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
  List<CategoryGoodsListData> list;

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryProvider>(
      builder: (context, child, data) {
        if (data.categoryGoodsList.length == 0) {
          return Center(
            child: Text("暂无数据..."),
          );
        } else
          return ListView.builder(
            itemBuilder: (context, index) =>
                _itemWidget(data.categoryGoodsList[index]),
            itemCount: data.categoryGoodsList.length,
          );
      },
    );
  }

  Widget _itemWidget(CategoryGoodsListData item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(item),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[_goodsName(item), _goodsPrice(item)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goodsImage(CategoryGoodsListData item) {
    return CNImage.loadImg(
      imgUrl: item.image,
      width: ScreenUtil().setWidth(200),
    );
//  return Image.network(item.image,width: ScreenUtil().setWidth(200));
  }

  Widget _goodsName(CategoryGoodsListData item) {
    return Container(
      child: Text(
        item.goodsname,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(CategoryGoodsListData item) {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        width: ScreenUtil().setWidth(370),
        child: Row(children: <Widget>[
          Text(
            '价格:￥${item.presentprice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${item.oriprice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ]));
  }
}
