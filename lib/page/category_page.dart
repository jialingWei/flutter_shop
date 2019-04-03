import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/config/easyrefresh_config.dart';
import 'package:flutter_shop/provide/category.dart';
import 'package:provide/provide.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/config/cached_network_img.dart';
import 'package:flutter_shop/model/category_entity.dart';
import 'package:flutter_shop/model/category_goods_list_entity.dart';
import 'package:flutter_shop/service/service_method.dart';

var rightTopIndex = 0;

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

      Provide.value<CategoryProvider>(context).initLeftList(list);
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
            return _leftInkWell(index, data.leftIndex, data.leftCategoryList);
          },
          itemCount: data.leftCategoryList.length,
        );
      }),
    );
  }

  Widget _leftInkWell(int index, int currentIndex, List<CategoryData> list) {
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context).setLeftCategoryList(index);
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
            itemCount: data.rightTopCategoryList.length,
            itemBuilder: (context, index) {
              return _rightInkWell(data.rightTopCategoryList[index],
                  index == data.rightTopIndex, index);
            }),
      );
    });
  }

  Widget _rightInkWell(CategoryDataBxmallsubdto item, bool isCheck, int index) {
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context).setRightTopCategory(index);
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
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  ScrollController _constroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryProvider>(
      builder: (context, child, data) {
        try {
          var currentPage = Provide.value<CategoryProvider>(context).page;
          print("应该滚动到顶部 page:$currentPage");
          if (currentPage == 1) {
            _constroller.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化：${e}');
        }

        if (data.rightGoodsList.length == 0) {
          return Center(
            child: Text("暂无数据..."),
          );
        } else {
          var easyRefresh = EasyRefresh(
            child: ListView.builder(
              controller: _constroller,
              itemBuilder: (context, index) =>
                  _itemWidget(data.rightGoodsList[index]),
              itemCount: data.rightGoodsList.length,
            ),
            loadMore: () {
              print('分类也加载更多');
              Provide.value<CategoryProvider>(context).loadMoreGoodsList();
            },
            refreshHeader: getDefaultHeader(_headerKey),
            refreshFooter: getDefaultFooter(_footerKey,
                Provide.value<CategoryProvider>(context).noMoreText),
          );

          return easyRefresh;
        }
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
