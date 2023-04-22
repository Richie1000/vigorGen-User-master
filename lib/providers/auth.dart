import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final Uri url =
        Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBSCyDq_1t6N7GPj74ZObVi4FkyfuYCKts');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId, 'expiryDate': _expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    } catch (error) {
      print(error);
      throw error;
      
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }
    
    final userExtractedData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userExtractedData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token = userExtractedData['token'];
    _userId = userExtractedData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout()async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
  void _autoLogout(){
    if (_authTimer != null){
      _authTimer.cancel();
    }
   final timeToExpiry =  _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> resetPassword(String email)async{
    final Uri url = Uri.parse("https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyBSCyDq_1t6N7GPj74ZObVi4FkyfuYCKts");
        final response = await http.post(url, body: json.encode({
        "requestType":"PASSWORD_RESET",
        "email": email}));
      final responseData = json.decode(response.body);
      print(responseData['email']);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

  }
}
