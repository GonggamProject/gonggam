import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  // sets
  static Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static Future<bool> setDouble(String key, double value) async =>
      await _prefs.setDouble(key, value);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static Future<bool> setString(String key, String value) async =>
      await _prefs.setString(key, value);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  // sets
  static Future<bool> setCustomerName(String customerName) => setString("customerName", customerName);

  static Future<bool> setLastGroupId(int lastGroupId) => setInt("lastGroupId", lastGroupId);

  // gets
  static bool isLogined() => _prefs.getBool("isLogin") ?? false;

  static String currentLoginedPlatform() => _prefs.getString("currentLoginedPlatform") ?? "";

  static String getCustomerId() => _prefs.getString("customerId") ?? "";

  static String getCustomerName() => _prefs.getString("customerName") ?? "테스트이름";

  static int getLastGroupId() => _prefs.getInt("lastGroupId") ?? 0;

  // clear
  static Future<bool> remove(String key) async => await _prefs.remove(key);

  static Future<bool> clear() async => await _prefs.clear();
}
