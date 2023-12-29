import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  static LocalStorageServices? _instance;
  static SharedPreferences? _preferences;

  static Future<LocalStorageServices> getinstance() async {
    _instance ??= LocalStorageServices();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance!;
  }

  Future<bool> _saveData(String key, dynamic value) {
    if (value is String) {
      return _preferences!.setString(key, value);
    }
    if (value is bool) {
      return _preferences!.setBool(key, value);
    }
    if (value is int) {
      return _preferences!.setInt(key, value);
    }
    if (value is double) {
      return _preferences!.setDouble(key, value);
    }
    if (value is List<String>) {
      return _preferences!.setStringList(key, value);
    }
    throw  Exception('Unsupported value type');
  }

  dynamic _getData(String key) {
    var value = _preferences!.get(key);
    return value;
  }

  /// save is user first time
  Future<bool> setFirstTimeVisit(bool isFirstTime) {
    return _saveData('firstTimeVisit', isFirstTime);
  }

  /// get is firstTime
  Bool? getFirstTimeVisit() {
    var status = _getData('firstTimeVisit');
    if (status == null) {
      return null;
    }
    return status;
  }

}