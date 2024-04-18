// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:moviedb/src/core/constants/api_constants.dart';
import 'package:moviedb/src/core/constants/strings.dart';
import 'package:moviedb/src/core/utils/response_model.dart' as task;

class ApiService {
  final Options _options = Options(
    contentType: 'application/json',
    sendTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    followRedirects: false,
  );

  final Dio dio = Dio();

  ApiService() {
    //Adding api key interceptor
    dio.interceptors.add(QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          options.queryParameters['api_key'] = ApiConstants.apiKey;

          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) => handler.next(error)));
  }

  Future<task.Response<dynamic>> getRequest(
      {required String url, var params}) async {
    try {
      log('##Request##\n$url\n$params');

      Response response =
          await dio.get(url, queryParameters: params, options: _options);
      log('##Response##\n$url\n${response.statusCode ?? ''}\n${response.statusMessage ?? ''}\n$response');

      if (response.statusCode == 200) {
        return task.Response.completed(response.data);
      }
      return task.Response.completed(response.data);
    } on DioError catch (e) {
      log(e.message ?? '');
      switch (e.type) {
        case DioErrorType.badResponse:
          log('${e.response}');

          if (e.response?.data != null &&
              e.response?.data is Map<String, dynamic> &&
              e.response?.data.containsKey('message') &&
              e.response?.data['message'] is String) {
            return task.Response.error(
                e.response?.data['message'] ?? AppStrings.defaultErrorMsg);
          } else {
            return task.Response.error(AppStrings.defaultErrorMsg);
          }
        case DioErrorType.connectionTimeout:
          {
            return task.Response.error(AppStrings.timeoutErrorMsg);
          }
        case DioErrorType.sendTimeout:
          {
            return task.Response.error(AppStrings.timeoutErrorMsg);
          }
        case DioErrorType.receiveTimeout:
          {
            return task.Response.error(AppStrings.timeoutErrorMsg);
          }
        case DioErrorType.unknown:
          if (e.error is SocketException) {
            return task.Response.error(AppStrings.noInternetErrorMsg);
          } else {
            return task.Response.error(AppStrings.defaultErrorMsg);
          }
        default:
          return task.Response.error(AppStrings.defaultErrorMsg);
      }
    } catch (e) {
      return task.Response.error(AppStrings.defaultErrorMsg);
    }
  }
}
