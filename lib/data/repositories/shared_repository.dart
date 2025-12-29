import 'dart:io';

import 'package:auction/core/api/crud.dart';
import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/core/utils/snackbar_helper.dart';
import 'package:dio/dio.dart';

class SharedRepository {
  Crud crud = Crud(token: Services.accessToken );

  Future getdata(String endpoint) async {
    try {
      final Response response = await crud.get(endpoint);

      // فحص حالة الرد (إذا كان الرد موجوداً ولكن يحمل كود خطأ مثل 404 أو 500)
      if (response.statusCode == 200) {
        return response.data['data'];
        // return (response.data['data'] as List)
        //     .map((json) => CategoryModel.fromJson(json))
        //     .toList();
      } else {
        // التعامل مع أكواد الخطأ التي يرجعها السيرفر (مثل 500)
        throw Exception('Server returned error code: ${response.statusCode}');
      }
    } catch (e) {
      // هذا هو الجزء الذي سيلتقط استثناء فشل الاتصال بالخادم المغلق
      // يمكن هنا إرجاع قائمة فارغة، أو بيانات مخزنة مؤقتاً، أو رمي استثناء مخصص
      throw Exception('Failed to connect to server or fetch data.');
    }
  }

  Future postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final Response response = await crud.post(endpoint, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.showSnackbar('تم الإضافة بنجاح');
        return response.data['data'];
      } else {
        throw Exception('Server returned error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server or post data.');
    }
  }

  Future deleteData(String endpoint) async {
    try {
      final Response response = await crud.delete(endpoint);
      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        SnackbarHelper.showSnackbar('تم الحذف بنجاح');
        // return response.data['data'];
      } else {
        throw Exception('Server returned error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server or delete data.');
    }
  }

  Future postDataWithMultiFile(
      String endpoint, Map<String, dynamic> data, List<File> images) async {
    try {
      final Response response =
          await crud.postwithMultiFile(endpoint, data: data, images: images);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['data'];
      } else {
        throw Exception('Server returned error code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server or post data.');
    }
  }
}
