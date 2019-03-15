import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category_entity.dart';

import 'package:flutter_shop/service/service_method.dart';



class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("商品分类"),),
      body: Row(
        children: <Widget>[
          LeftCategoryNav(),
          Expanded(
            flex: 1,
            child: Container(color: Colors.red,),
          )
        ],
      ),
    );
  }


}

//左侧导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<CategoryData> list = [];

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
        border: Border(right: BorderSide(width: 1,color: Colors.black12))
      ),
      child: ListView.builder(itemBuilder: (context,index){
        return _leftInkWell(index);
      },itemCount: list.length,),
    );
  }

  void _loadCategoryList() async{
    await getCategory().then((value){
      var rep = json.decode(value.toString());
      CategoryEntity categoryList = CategoryEntity.fromJson(rep);
      categoryList.data.forEach((item)=>print(item.mallcategoryname));
      setState(() {
        list = categoryList.data;
      });
    });
  }

  Widget _leftInkWell(int index) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1,color: Colors.black12))
        ),
        child: Text(list[index].mallcategoryname,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }
}

