class UserModel {
  int? id;
  String? name;
  String? phone;
  int? isVerified;

  UserModel({this.id, this.name, this.phone, this.isVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['is_verified'] = this.isVerified;
    return data;
  }
}