class CategoryGoodsListEntity {
	List<CategoryGoodsListData> data;

	CategoryGoodsListEntity({this.data});

	CategoryGoodsListEntity.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<CategoryGoodsListData>();
			(json['data'] as List).forEach((v) { data.add(new CategoryGoodsListData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class CategoryGoodsListData {
	String image;
	double oriprice;
	double presentprice;
	String goodsid;
	String goodsname;

	CategoryGoodsListData({this.image, this.oriprice, this.presentprice, this.goodsid, this.goodsname});

	CategoryGoodsListData.fromJson(Map<String, dynamic> json) {
		image = json['image'];
		oriprice = json['oriPrice'];
		presentprice = json['presentPrice'];
		goodsid = json['goodsId'];
		goodsname = json['goodsName'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['image'] = this.image;
		data['oriPrice'] = this.oriprice;
		data['presentPrice'] = this.presentprice;
		data['goodsId'] = this.goodsid;
		data['goodsName'] = this.goodsname;
		return data;
	}
}
