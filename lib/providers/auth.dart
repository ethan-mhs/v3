import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/login.dart';
import 'package:seller/models/login_respond.dart';
import 'package:seller/models/profile.dart';
import 'package:seller/services/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  Network _network = new Network();

  String _token;
  DateTime _expiryDate;
  int _userId;
  Timer _authTimer;

  Profile _profile;

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
  int get userId => _userId;

  Profile get profile => _profile;

  Future<void> login(String phone, String password) async {
    final url = urlBase + urlAuth + urlLogin;
    var body = json.encode(
        Login(emailOrPhoneNo: phone, password: password));
    try {
      var response = await _network.post(body: body, url: url);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
      var loginRespond = LoginRespond.fromJson(responseData);
      _token = loginRespond.token.accessToken;
      _userId = loginRespond.user.id;
      _expiryDate = DateTime.now().add(
        Duration(seconds: loginRespond.token.accessTokenExpiration.toInt()),
      );

      _autoLogout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final loginData = json.encode(loginRespond);
      prefs.setString('loginData', loginData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> forgetPassword(String phone) async {
    final url = urlBase + urlAuth + urlForget;
    var body = json.encode(phone);
    try {
      var responseData = await _network.post(body: body, url: url);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      var loginRespond = LoginRespond.fromJson(responseData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('loginData')) {
      return false;
    }
    final extractedLoginData =
        json.decode(prefs.getString('loginData')) as Map<String, dynamic>;
    var loginRespond = LoginRespond.fromJson(extractedLoginData);
    final expiryDate = loginRespond.token.expiryDate;

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = loginRespond.token.accessToken;
    _userId = loginRespond.user.id;
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('loginData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<void> getProfile() async {
    final url = urlBase + urlAuth + urlProfile + '?Id=$userId&ApplicationConfigId=3';
    try {
      var response = await _network.get(url: url,token: _token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
      var profile = Profile.fromJson(responseData);
      _profile = profile;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
