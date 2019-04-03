import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/config/cached_network_img.dart';
import 'package:flutter_shop/config/easyrefresh_config.dart';
import 'package:flutter_shop/ui/base_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';

import '../service/service_method.dart';
import '../ui/banner/banner_diy.dart';
import '../ui/banner/top_navigator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> _hotGoodsList = [];

  String homePageContent = "还没有数据";

  /// 保持页面状态，不用切换换来每次都重新build
  @override
  bool get wantKeepAlive => true;

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  ScrollController _constroller = ScrollController();

  @override
  void dispose() {
    _constroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Container(
              //设置标题尽可能填充沾满，响应双击事件
              child: Text("请求远程数据"),
              width: double.maxFinite,
              height: double.maxFinite,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: Colors.transparent),
            ),
            onDoubleTap: () {
              _constroller.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
        ),
        body: FutureBuilder(
          future: getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> _swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> _navigatorList =
                  (data['data']['category'] as List).cast();
              String _advertesPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
              String _leaderImage =
                  data['data']['shopInfo']['leaderImage']; //店长图片
              String _leaderPhone = data['data']['shopInfo']['leaderPhone']; //
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast(); // 商品推荐

              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              String floor2Title =
                  data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层2的标题图片
              String floor3Title =
                  data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层3的标题图片
              List<Map> floor1 =
                  (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 =
                  (data['data']['floor2'] as List).cast(); //楼层2商品和图片
              List<Map> floor3 =
                  (data['data']['floor3'] as List).cast(); //楼层3商品和图片

              return EasyRefresh(
                child: ListView(
                  controller: _constroller,
                  children: <Widget>[
                    HomeBanner(swiperDataList: _swiperDataList),
                    TopNavigator(navigatorList: _navigatorList),
                    AdBanner(advertesPicture: _advertesPicture), //广告组件
                    LeaderPhone(
                      leaderImage: _leaderImage,
                      leaderPhone: _leaderPhone,
                    ),
                    Recommend(
                      recommedList: recommendList,
                    ),
                    FloorTitle(picAddres: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(picAddres: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    FloorTitle(picAddres: floor3Title),
                    FloorContent(floorGoodsList: floor3),
                    _hotGoods(),
                  ],
                ),
                loadMore: () async {
                  print('加载更多，，，，，，');
                  var formPage = {'page': page};
                  await getHomePageBeloContent(formPage).then((result) {
                    var data = json.decode(result.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      _hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
                onRefresh: () async {
                  print('下拉刷新，，，，，，');
                },
                refreshFooter: getDefaultFooter(_footerKey,"没有更多数据了！！！"),
//                refreshHeader: BallPulseHeader(
//                  key: _headerKey,
//                ),
                refreshHeader: getDefaultHeader(_headerKey),
              );
            } else {
              return Center(
                child: Text("加载中..."),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle, _wrapList()],
      ),
    );
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text("火爆专区"),
  );

  Widget _wrapList() {
    if (_hotGoodsList.length != 0) {
      List<Widget> listWidget = _hotGoodsList.map((item) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
//            color: Colors.white70,
//            padding: EdgeInsets.all(5.0),
//            margin: EdgeInsets.only(bottom: 3.0),
            child: Card(
              elevation: 5, //阴影距离
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)), //卡片圆角
              child: Column(
                children: <Widget>[
                  CNImage.loadImg(
                    imgUrl: item['image'],
                    width: ScreenUtil().setWidth(370),
                  ),
                  Text(
                    item['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('￥${item['mallPrice']}'),
                      Text(
                        '￥${item['price']}',
                        textScaleFactor: 0.8,
                        style: TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: CachedNetworkImage(
          imageUrl: leaderImage,
          placeholder: PlaceholderWidget(),
        ),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:$leaderPhone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '无法启动： $url';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommedList;

  Recommend({Key key, this.recommedList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList(),
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, .0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _item(index),
        itemCount: recommedList.length,
      ),
    );
  }

  Widget _item(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: recommedList[index]['image'],
              placeholder: PlaceholderWidget(),
            ),
            Text('￥${recommedList[index]['mallPrice']}'),
            Text(
              '￥${recommedList[index]['price']}',
              textScaleFactor: 0.8,
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picAddres; //图片地址

  FloorTitle({Key key, this.picAddres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: picAddres,
        placeholder: PlaceholderWidget(),
      ),
    );
  }
}

//楼层商品
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    final img = goods['image'];
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () => print('点击了商品$img'),
        child: CachedNetworkImage(
          imageUrl: img,
          placeholder: PlaceholderWidget(),
        ),
      ),
    );
  }
}
