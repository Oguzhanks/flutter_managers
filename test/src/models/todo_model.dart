import 'package:flutter_managers/src/models/client_model.dart';

class TodoModel extends ManagerModel<TodoModel> {
  String? name;
  String? surName;
  TodoModel({this.name, this.surName});
  @override
  TodoModel fromJson(Map<String, dynamic> json) => TodoModel(
        name: json["name"],
        surName: json["surName"],
      );

  @override
  Map<String, dynamic>? toJson() => {
        "name": name,
        "surName": surName,
      };
}
