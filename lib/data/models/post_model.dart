class PostModel {
  int? id;
  String? name;
  String? address;
  String? discribtion;
  int? price;
  String? status;
  String? productStatus;
  DateTime? createdAt;
  int? userId;
  int? categoryId;
  int? fav;
  List<Images>? images;

  PostModel(
      {this.id,
      this.name,
      this.address,
      this.discribtion,
      this.price,
      this.status,
      this.productStatus,
      this.userId,
      this.categoryId,
      this.fav,
      this.images});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    address = json['address'];
    discribtion = json['discribtion'];
    price = int.parse(json['price'].toString());
    status = json['status'];
    productStatus = json['product_status'];
    userId = int.parse(json['user_id'].toString());
    categoryId = int.parse(json['category_id'].toString());
    createdAt = DateTime.parse(json['created_at']);
    fav= int.parse(json['fav'].toString());
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['discribtion'] = this.discribtion;
    data['price'] = this.price;
    data["status"] = status ?? "available";
    data['product_status'] = productStatus;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? imageUrl;
  int? isMain;

  Images({this.imageUrl, this.isMain});

  Images.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    isMain = int.parse(json['is_main'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['is_main'] = this.isMain;
    return data;
  }
}
