// class CategoryModel {
//     int? id;
//     String nameAr;
//     String nameEn;
//     int? parentId;

//     CategoryModel({
//         this.id,
//         required this.nameAr,
//         required this.nameEn,
//         this.parentId,
//     });
//     factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
//         id: json["id"],
//         nameAr: json["name_ar"],
//         nameEn: json["name_en"],
//         parentId: json["parent_id"],
//     );
//     Map<String, dynamic> toJson() => {
//         "name_ar": nameAr,
//         "name_en": nameEn,
//         "parent_id": parentId,
//     };

// }

class CategoryModel {
  int? id;
  String? nameAr;
  String? nameEn;
  int? parentId;
  List<Children>? children;

  CategoryModel(
      {this.id, this.nameAr, this.nameEn, this.parentId, this.children});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    parentId = json['parent_id'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['parent_id'] = this.parentId;
    if (this.children != null) {
      data['children'] = this.children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  int? id;
  String? nameAr;
  String? nameEn;
  int? parentId;

  Children({this.id, this.nameAr, this.nameEn, this.parentId});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name_ar'] = this.nameAr;
    data['name_en'] = this.nameEn;
    data['parent_id'] = this.parentId;
    return data;
  }
}