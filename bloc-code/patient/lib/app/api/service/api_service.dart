import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eye_buddy/app/api/service/base_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/keys/token_keys.dart';

class ApiService extends BaseService {
  ApiService() {
    final options = BaseOptions(
      contentType: Headers.jsonContentType,
      headers: patientToken == ''
          ? <String, String>{
              'Accept': 'application/json',
              // 'Content-Type': 'application/json',
            }
          : <String, String>{
              // 'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $patientToken',
            },
      receiveTimeout: const Duration(seconds: 15),
      connectTimeout: const Duration(seconds: 15),
    );

    _dio = Dio(options);
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  late Dio _dio;

  @override
  Future getDeleteResponse(
    String url, {
    payloadData = '',
  }) async {
    dynamic responseJson;

    Response? response;

    try {
      response = await _dio.delete(
        url,
        //data: payloadData,
        //queryParameters: payloadData
      );
      responseJson = returnResponse(response);
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }

    return responseJson;
  }

  @override
  Future getGetResponse(String url) async {
    dynamic responseJson;

    Response response;
    try {
      response = await _dio.get(url);
      responseJson = returnResponse(response);
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        print("Response at Repo ${e.response?.data["message"]}");

        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getGetQueryParametersResponse(String url, Map<String, dynamic> parameters) async {
    dynamic responseJson;

    Response response;
    try {
      response = await _dio.get(url, queryParameters: parameters);
      responseJson = returnResponse(response);
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        print("Response at Repo ${e.response?.data["message"]}");

        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPostResponse(String url, data) async {
    dynamic responseJson;
    Response response;
    try {
      response = await _dio.post(
        url,
        data: data,
      );
      //log("Your Response : $response");
      responseJson = returnResponse(response);
      //log("Your Response : $responseJson");
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPutResponse(String url, data) async {
    //print("calling put");
    dynamic responseJson;

    //Response? response;
    Response response;
    try {
      response = await _dio.put(
        url,
        data: data,
      );
      //log("Your Response : $response");
      responseJson = returnResponse(response);
      //log("Your Response : $responseJson");
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        // print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @override
  Future getPatchResponse(String url, data) async {
    //print("calling put");
    dynamic responseJson;

    //Response? response;
    Response response;
    try {
      response = await _dio.patch(
        url,
        data: data,
      );
      //log("Your Response : $response");
      responseJson = returnResponse(response);
      //log("Your Response : $responseJson");
    } on DioException catch (error) {
      responseJson = returnResponse(error.response!);
    } on SocketException {
      return {
        'error': true,
        'message': 'No internet connection.',
        'data': [],
      };
    } catch (e) {
      if (e is DioException) {
        // print("Response at Repo ${e.response?.data["message"]}");
        return {
          'error': true,
          'message': e.response?.data['message'],
          'data': [],
        };
      }
    }
    return responseJson;
  }

  @visibleForTesting
  dynamic returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 201:
        return response.data;
      case 400:
        return response.data;
      case 404:
        return response.data;
      case 422:
        return response.data;
      case 401:
        // boxStorage.erase();
        // Get.offAll(FutureWedslyHomePage);
        return response.data;
      case 403:
        // boxStorage.erase();
        // Get.offAll(FutureWedslyHomePage);
        return response.data;
      case 500:
        log('RESPONSE DATA : ${response.data.toString()}');
        return response.data;
      default:
        log('RESPONSE DATA : ${response.data.toString()}');
        return response.data;
      // throw FetchDataException('Error occurred while communication with server'
      //     ' with status code : ${response.statusCode}');
    }
  }
}
