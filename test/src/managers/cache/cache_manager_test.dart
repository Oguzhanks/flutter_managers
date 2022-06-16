import 'package:flutter/cupertino.dart';
import 'package:flutter_managers/src/managers/cache/shared_preferences/SharedService.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../models/todo_model.dart';

void main() {
  group('Cache Test Manager / ', () {
    setUp(() async {
      await CacheManager.init();
    });

    test('Save & Get Model', () async {
      const name = 'Ozzy';
      const surName = 'Ks';
      await CacheManager.saveModel(TodoModel(name: name, surName: surName));
      final data = CacheManager.getModel(TodoModel());
      expect(data, isNotNull);
      expect(data?.name, name);
      expect(data?.surName, surName);
    });
    test('Save & Get String', () async {
      const key = 'getString';
      const value = 'Ozzy';
      await CacheManager.saveString(key, value);
      final data = CacheManager.getString(key);
      expect(data, isNotNull);
      expect(data, value);
    });
    test('Save & Get Int', () async {
      const key = 'getInt';
      const value = 10;
      await CacheManager.saveInt(key, value);
      final data = CacheManager.getInt(key);
      expect(data, isNotNull);
      expect(data, value);
    });
    test('Save & Get Double', () async {
      const key = 'getDouble';
      const value = 10.2;
      await CacheManager.saveDouble(key, value);
      final data = CacheManager.getDouble(key);
      expect(data, isNotNull);
      expect(data, value);
    });
    test('Save & Get Bool', () async {
      const key = 'getBool';
      const value = true;
      await CacheManager.saveBool(key, value);
      final data = CacheManager.getBool(key);
      expect(data, isNotNull);
      expect(data, value);
    });
  });
}
