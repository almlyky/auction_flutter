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

import 'package:hive/hive.dart';
part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? nameAr;
  @HiveField(2)
  String? nameEn;
  @HiveField(3)
  int? parentId;
  @HiveField(4)
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['parent_id'] = parentId;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 1)
class Children extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? nameAr;
  @HiveField(2)
  String? nameEn;
  @HiveField(3)
  int? parentId;

  Children({this.id, this.nameAr, this.nameEn, this.parentId});

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name_ar'] = nameAr;
    data['name_en'] = nameEn;
    data['parent_id'] = parentId;
    return data;
  }
}
