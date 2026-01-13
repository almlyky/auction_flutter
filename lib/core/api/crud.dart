import 'dart:io';

import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/utils/snackbar_helper.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Crud {
  late final Dio dio;
  Crud({String? token}) {
    dio = Dio(
      BaseOptions(
        baseUrl: LinksApi.server,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
    // dio.interceptors.add(PrettyDioLogger(
    //   requestHeader: true,
    //   requestBody: true,
    //   responseBody: true,
    //   error: true,
    //   compact: true,
    //   maxWidth: 100,
    // ));

    dio.interceptors.add(InterceptorsWrapper(
   
      onError: (DioException e, handler) {
        // Do something with response error
        String message = "حدث خطأ غير متوقع 😢";

        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            message = "⏱️ فشل الاتصال: انتهى الوقت المحدد.";
            break;
          case DioExceptionType.receiveTimeout:
            message = "📶 انتهى الوقت أثناء استقبال البيانات.";
            break;
          case DioExceptionType.sendTimeout:
            message = "🚫 فشل في إرسال الطلب للسيرفر.";
            break;
          case DioExceptionType.badResponse:
            final status = e.response?.statusCode ?? 0;
            if (status == 400)
              message = "❌ طلب غير صالح.";
            else if (status == 401)
              message = "🔒 غير مصرح لك.";
            else if (status == 404)
              message = "❗ الصفحة غير موجودة.";
            else if (status == 500)
              message = "💥 خطأ في الخادم.";
            else
              message = "⚠️ خطأ في الاستجابة: $status";
            break;
          case DioExceptionType.unknown:
            message = "🌐 تحقق من اتصال الإنترنت.";
            break;
          default:
            message = "⚠️ خطأ غير معروف.";
        }
        SnackbarHelper.showSnackbar(message);
        return handler.next(e); //continue
      },
    ));
  }
  Future<Response> get(String endpoint, {Map<String, dynamic>? query}) async {
    Response response = await dio.get(endpoint, queryParameters: query);
    return response;
  }

  // Future<Response> post(String endpoint, {Map<String, dynamic>? data}) async {
  //   return await dio.post(endpoint, data: data);
  // }

  // Future<Response> put(String endpoint, {Map<String, dynamic>? data}) async {
  //   return await dio.put(endpoint, data: data);
  // }

  // Combine put and post into one method
  Future<Response> putOrPost(String endpoint, {Map<String, dynamic>? data}) async {
    if (data != null && data.containsKey('_method')) {
      return await dio.put(endpoint, data: data);
    } else {
      return await dio.post(endpoint, data: data);
    }
  }

  Future<Response> delete(String endpoint) async {
    return await dio.delete(endpoint);
  }

  // Future<Response> postwithFile(
  //   String endpoint, {
  //   required Map<String, dynamic> data,
  //   required String filePath,
  // }) async {
  //   // final MultipartFile multipartFile = await MultipartFile.fromFile(filePath);
  //   final FormData formData = FormData.fromMap({
  //     'data': data,
  //     // 'file': multipartFile,
  //     'file': await MultipartFile.fromFile(filePath),
  //   });
  //   return await dio.post(endpoint, data: formData);
  // }

  // Future<Response> postwithMultiFile(String endpoint,
  //     {required Map<String, dynamic> data, required List<File> images}) async {
  //       // print("=================in crud multi file");
  //       // print(images);

  //       List<MultipartFile > multipartFiles = [];
  //       for (File image in images) {
  //         // MultipartFile multipartFile = await MultipartFile.fromFile(image.path);
  //         multipartFiles.add(await MultipartFile.fromFile(image.path));
  //       }
  //   final FormData formData = FormData.fromMap({
  //     'data': data,
  //     'images[]': multipartFiles,
  //   });
  //   return await dio.post(endpoint, data: formData);
  //     }
  
  // fu
  Future<Response> putOrPostwithMultiFile(String endpoint,
      {required Map<String, dynamic> data, required List<File> images}) async {
        List<MultipartFile > multipartFiles = [];
        for (File image in images) {
          // MultipartFile multipartFile = await MultipartFile.fromFile(image.path);
          multipartFiles.add(await MultipartFile.fromFile(image.path));
        }
    final FormData formData = FormData.fromMap({
      'data': data,
      'images[]': multipartFiles,
    });
    // laravel not support put with file so we use post with _method put
    // if (data.containsKey('_method')) {
      // return await dio.put(endpoint, data: formData);
    // } else {
      return await dio.post(endpoint, data: formData);
    // }
  }
}
