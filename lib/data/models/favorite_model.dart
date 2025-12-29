import 'package:auction/data/models/post_model.dart';

class FavoriteModel {
  int? id;
  PostModel? post;
  String? createdAt;
  String? updatedAt;
  int? userId;

  FavoriteModel({this.id, this.createdAt, this.updatedAt, this.userId});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = PostModel.fromJson(json['post']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post'] = post;
    data['user_id'] = userId;
    return data;
  }
}
