import 'package:auction/core/api/crud.dart';
import 'package:auction/core/api/links_api.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:dio/dio.dart';

class CategoryRepository {
  Crud crud = Crud();

  // CategoryRepository({required this.crud});

 Future<List<CategoryModel>> getCategories() async {
  try {
    final Response response = await crud.get(LinksApi.endpointCategories);
    
    // فحص حالة الرد (إذا كان الرد موجوداً ولكن يحمل كود خطأ مثل 404 أو 500)
    if (response.statusCode == 200) { 
      return (response.data['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
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
}
