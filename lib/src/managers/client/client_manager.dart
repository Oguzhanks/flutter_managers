import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_managers/src/models/error_model.dart';
import 'package:retry/retry.dart';

import '../../models/client_model.dart';
import '../../models/response_model.dart';
import 'package:dio/src/adapters/io_adapter.dart' if (dart.library.html) 'package:dio/src/adapters/browser_adapter.dart' as adapter;
import 'package:dio/dio.dart' as dio;

import 'iclient_manager.dart';
part 'utils/client_intercaptors.dart';
part 'utils/client_model_parser.dart';

class ClientManager with dio.DioMixin implements dio.Dio, IClientManager {
  late Future<DioError> Function(DioError error, ClientManager newService)? onRefreshToken;

  late VoidCallback? onRefreshFail;

  final int _maxCount = 3;

  @override
  dio.Interceptors get dioIntercaptors => interceptors;

  ClientManager({
    required BaseOptions options,
    dio.Interceptor? interceptor,
    this.onRefreshToken,
    this.onRefreshFail,
  }) {
    this.options = options;

    _addNetworkIntercaptors(interceptor);
    httpClientAdapter = adapter.createAdapter();
  }

  @override
  Future<ResponseModel<R?>> getRequest<T extends ClientModel, R>(
    String path, {
    required T parseModel,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    options ??= Options();
    options.method = 'GET';
    ResponseModel<R?> responseModel = ResponseModel<R?>();

    try {
      final response = await request(path, options: options, queryParameters: query);
      final responseStatusCode = response.statusCode ?? HttpStatus.notFound;
      if (responseStatusCode >= HttpStatus.ok && responseStatusCode <= HttpStatus.multipleChoices) {
        responseModel = _getResponseResult<T, R>(response.data, parseModel);
      } else {
        responseModel = ResponseModel<R?>(
          error: ErrorModel(
            type: ErrorType.response,
            message: response.data.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      final ErrorModel error;
      if (e.response != null) {
        error = ErrorModel(
          type: ErrorType.response,
          statusCode: e.response?.statusCode,
          message: e.response?.statusMessage ?? 'Status Error',
        );
      } else {
        error = ErrorModel(
          type: ErrorType.dio,
          message: (e.error ?? 'Dio Error').toString(),
        );
      }
      responseModel = ResponseModel<R?>(error: error);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel<R?>> postRequest<T extends ClientModel, R>(
    String path, {
    required T parseModel,
    Map<String, dynamic>? query,
    Options? options,
    dynamic body,
  }) async {
    options ??= Options();
    options.method = 'POST';
    final postBody = _getBodyModel(body);
    ResponseModel<R?> responseModel = ResponseModel<R?>();

    try {
      final response = await request(path, data: postBody, options: options, queryParameters: query);
      final responseStatusCode = response.statusCode ?? HttpStatus.notFound;
      if (responseStatusCode >= HttpStatus.ok && responseStatusCode <= HttpStatus.multipleChoices) {
        responseModel = _getResponseResult<T, R>(response.data, parseModel);
      } else {
        responseModel = ResponseModel<R?>(
          error: ErrorModel(
            type: ErrorType.response,
            message: response.data.toString(),
          ),
        );
      }
    } on DioError catch (e) {
      final ErrorModel error;
      if (e.response != null) {
        error = ErrorModel(
          type: ErrorType.response,
          statusCode: e.response?.statusCode,
          message: e.response?.statusMessage ?? 'Status Error',
        );
      } else {
        error = ErrorModel(
          type: ErrorType.dio,
          message: (e.error ?? 'Dio Error').toString(),
        );
      }
      responseModel = ResponseModel<R?>(error: error);
    }
    return responseModel;
  }

  ResponseModel<R> _getResponseResult<T extends ClientModel, R>(dynamic data, T parserModel) {
    R? model;
    ErrorModel? error;
    try {
      model = _parseBody<R, T>(data, parserModel);
    } on ErrorModel catch (e) {
      error = e;
    }

    return ResponseModel<R>(data: model, error: error);
  }
}
