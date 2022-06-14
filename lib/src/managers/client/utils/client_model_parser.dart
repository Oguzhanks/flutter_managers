part of '../client_manager.dart';

extension _CoreServiceExtension on ClientManager {
  dynamic _getBodyModel(dynamic data) {
    if (data is ClientModel) {
      return data.toJson();
    } else if (data != null) {
      return jsonEncode(data);
    } else {
      return data;
    }
  }

  R? _parseBody<R, T extends ClientModel>(dynamic responseBody, T model) {
    try {
      if (responseBody is List) {
        return responseBody.map((data) => model.fromJson(data)).cast<T>().toList() as R;
      } else if (responseBody is Map<String, dynamic>) {
        return model.fromJson(responseBody) as R;
      } else {
        throw ErrorModel(
          type: ErrorType.local,
          message: 'Becareful your data $responseBody, I could not parse it',
        );
      }
    } catch (e) {
      throw ErrorModel(
        type: ErrorType.local,
        message: 'Parse Error: $e - response body: $responseBody T model: $T , R model: $R ',
      );
    }
  }
}
