import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction
{
  static String userLoggedInKey='user login';
  static String userNameKey='user name';
  static String emailKey='email';

  Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async
  {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  Future<bool> saveUserNameSf(String userName)async
  {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmailSf(String userEmail)async
  {
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(emailKey, userEmail);
  }



  static Future<bool?> getUserLoggedInStatus()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    print(userLoggedInKey);
    return sharedPreferences.getBool(userLoggedInKey);

  }

  static Future<String?> getUserEmailFromSf()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    print(userLoggedInKey);
    return sharedPreferences.getString(emailKey);

  }

  static Future<String?> getUserFullNameFromSf()async
  {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    print(userLoggedInKey);
    return sharedPreferences.getString(userNameKey);

  }



}