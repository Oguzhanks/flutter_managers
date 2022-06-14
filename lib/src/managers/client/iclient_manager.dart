import 'package:dio/dio.dart';
import 'package:flutter_managers/src/models/client_model.dart';

import '../../models/response_model.dart';

abstract class IClientManager {
  Future<ResponseModel<R?>> getRequest<T extends ClientModel, R>(
    String path, {
    required T parseModel,
    Map<String, dynamic>? query,
    Options? options,
  });
  Future<ResponseModel<R?>> postRequest<T extends ClientModel, R>(
    String path, {
    required T parseModel,
    Map<String, dynamic>? query,
    Options? options,
    dynamic body,
  });
}
