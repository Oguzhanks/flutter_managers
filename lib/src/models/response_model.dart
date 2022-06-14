import 'package:flutter/cupertino.dart';

import 'error_model.dart';

class ResponseModel<T> {
  T? data;
  ErrorModel? error;

  ResponseModel({this.data, this.error});
}
