import 'package:shared_preferences/shared_preferences.dart';

class SaveInSharedPref {
  static String sharedPrefUserKey = "ISLOGGEDIN";
  static String sharedPrefUserNameKey = "USERNAMEKEY";
  static String sharedPrefUserEmailKey = "USEREMAILKEY";
  static String sharedPrefUserPhoneKey = "USEREPHONEKEY";
  static String sharedPrefUserGroupKey = "USERGROUPKEY";

  static Future<bool> saveUserLoggedInPreference(bool userLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefUserKey, userLoggedIn);
  }

  static Future<bool> saveUserNamePreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserNameKey, userName);
  }

  static Future<bool> saveUserEmailPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserEmailKey, userEmail);
  }

  static Future<bool> saveUserGroupPreference(String userGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserGroupKey, userGroup);
  }

  static Future<bool?> getUserLoggedInPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefUserKey);
  }

  static Future<String?> getUserNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserNameKey);
  }

  static Future<String?> getUserEmailPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserEmailKey);
  }

  static Future<String?> getUserGroupPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserGroupKey);
  }

  static Future<String?> getUserPhonePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefUserPhoneKey);
  }
  static Future<bool> saveUserPhonePreference(String userPhone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUserPhoneKey, userPhone);
  }
}