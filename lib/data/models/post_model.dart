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
    fav = int.parse(json['fav'].toString());
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['discribtion'] = discribtion;
    data['price'] = price;
    data["status"] = status ?? "available";
    data['product_status'] = productStatus;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imageUrl;
  int? isMain;

  Images({this.id, this.imageUrl, this.isMain});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    isMain = int.parse(json['is_main'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    data['is_main'] = isMain;
    return data;
  }
}
