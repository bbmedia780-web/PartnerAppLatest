import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_x;
import 'package:varnika_app/routes/app_routes.dart';
import '../../../../../../utils/global.dart';
import 'api_end_point.dart';

final dio = Dio();

class ApiClient {
  Future<Response?> getData(
      {required String endPoint,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) async {
    try {
      Response response;
      response = await dio.get(
        endPoint,
        queryParameters: queryParams,
        options: headers != null
            ? Options(headers: headers)
            : Options(headers: ApiConstant().headers),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 400) {
          if (e.response?.data["message"] != null) {
            ShowToast.error(
                e.response?.data["message"] ?? "Something want wrong!");
          } else {
            get_x.Get.offAndToNamed(AppRoutes.homeScreen);
          }
        }
        if (e.response?.statusCode == 500) {
          ShowToast.error(
              e.response?.data["message"] ?? "Something want wrong!");
        }
      } else {}
    }
    return null;
  }

  Future<Response?> postData(
      {required String endPoint,
      Map<String, dynamic>? data,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? header}) async {
    try {
      Response response;
      response = await dio.post(
        endPoint,
        queryParameters: queryParams,
        options: header != null
            ? Options(headers: header)
            : Options(headers: ApiConstant().headers),
        data: jsonEncode(data),
      );

      return response;
    } on DioException catch (e) {
      // Handle the error
      if (e.response != null) {
        if (e.response?.statusCode == 400) {
          if (e.response?.data["message"] != null) {
            ShowToast.error(
                e.response?.data["message"] ?? "Something want wrong!");
          } else {
            get_x.Get.offAndToNamed(AppRoutes.homeScreen);
          }
        }
        if (e.response?.statusCode == 500) {
          ShowToast.error(
              e.response?.data["message"] ?? "Something want wrong!");
        }
      } else {}
    }
    return null;
  }

  Future<Response?> deleteData(
      {required String endPoint,
      Map<String, dynamic>? data,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? header}) async {
    try {
      Response response;
      response = await dio.delete(
        endPoint,
        options: header != null
            ? Options(headers: header)
            : Options(headers: ApiConstant().headers),
      );
      return response;
    } on DioException catch (e) {
      // Handle the error
      if (e.response != null) {
        ShowToast.error(
            e.response?.data["message"] ?? "Something want wrong!");
      }
    }
    return null;
  }
}
