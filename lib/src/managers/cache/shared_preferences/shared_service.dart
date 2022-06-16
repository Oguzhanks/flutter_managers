import 'dart:convert';
import 'package:flutter_managers/flutter_managers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static Future<SharedPreferences> get _instance async => _preferences ??= await SharedPreferences.getInstance();
  static SharedPreferences? _preferences;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _preferences = await _instance;
    return _preferences!;
  }

  static T? getModel<T extends ManagerModel>(T model) {
    final data = _preferences!.getString(T.toString());
    if (data == null) return null;

    return model.fromJson(jsonDecode(data));
  }

  static String? getString(String key) => _preferences!.getString(key);

  static int? getInt(String key) => _preferences!.getInt(key);

  static bool? getBool(String key) => _preferences!.getBool(key);

  static double? getDouble(String key) => _preferences!.getDouble(key);

  static Future<bool> saveModel<T extends ManagerModel>(T model) async => await _preferences!.setString(T.toString(), jsonEncode(model.toJson()));

  static Future<bool> saveString(String key, String value) async => await _preferences!.setString(key, value);

  static Future<bool> saveInt(String key, int value) async => await _preferences!.setInt(key, value);

  static Future<bool> saveBool(String key, bool value) async => await _preferences!.setBool(key, value);

  static Future<bool> saveDouble(String key, double value) async => await _preferences!.setDouble(key, value);

  static Future<bool> remove(String key) async => await _preferences!.remove(key);

  static Future<bool> clear() async => await _preferences!.clear();
}
