import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';


class Network {

  Future<dynamic> post({@required String url, @required Object body, String token}) async {
    Response response = await http.post(
      url,
      body: body,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
    return response;
  }

  Future<dynamic> get({@required String url, String token}) async {
    Response response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token' ,
      },
    );
    return response;
  }
}
