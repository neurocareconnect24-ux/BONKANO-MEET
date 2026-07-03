import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart';

/// Liste des clés sensibles dont les valeurs ne doivent PAS être loguées
const _sensitiveKeys = {'USER_PASSWORD', 'USER_LOGIN_DATA', 'USER_DATA'};

GetStorage localStorage = GetStorage();

setValueToLocal(String key, dynamic value) {
  if (kDebugMode) {
    final logValue = _sensitiveKeys.contains(key) ? '***' : value;
    log('setValueToLocal : ${value.runtimeType} - $key - $logValue');
  }
  localStorage.write(key, value);
}

T getValueFromLocal<T>(String key) {
  final val = localStorage.read(key);
  if (kDebugMode) {
    final logValue = _sensitiveKeys.contains(key) ? '***' : val;
    log("getValueFromLocal : ${val.runtimeType} - $key - $logValue");
  }
  return val;
}

removeValueFromLocal(String key) {
  if (kDebugMode) {
    log("removeValueFromLocal : $key");
  }
  localStorage.remove(key);
}

/// Returns a Bool if exists in SharedPref
bool getBoolAsync(String key, {bool defaultValue = false}) {
  return sharedPreferences.getBool(key) ?? defaultValue;
}
