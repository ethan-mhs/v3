import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/category.dart';
import 'package:seller/services/network.dart';

import '../constants/vars.dart';
import '../models/ProductView.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  Network _network = new Network();

  final String token;
  Products(this.token);

  List<ProductView> _allProducts = new List();
  List<ProductView> _promoProducts = new List();
  List<ProductView> _outOfStockProducts = new List();
  List<Category> _categoryList = new List();


  List<ProductView> get allProducts => _allProducts;
  List<ProductView> get promoProducts => _promoProducts;
  List<ProductView> get outOfStockProducts => _outOfStockProducts;
  List<Category> get categoryList => _categoryList;

  Future<void> getAllCategories() async {
    final url = urlBase + urlStore + urlMiscellaneous + urlGetMainCategory;

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
      final extracted = responseData.cast<Map<String, dynamic>>();
      _categoryList.clear();
      _categoryList = extracted.map<Category>((element) => Category.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _categoryList.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getAllProducts() async {
    final url = urlBase + urlStore + urlProduct + urlGetProductList + '?Filter=1';

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
      final extracted = responseData.cast<Map<String, dynamic>>();
      _allProducts.clear();
      _allProducts = extracted.map<ProductView>((element) => ProductView.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _allProducts.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getPromoProducts() async {
    final url = urlBase + urlStore + urlProduct + urlGetProductList + '?Filter=2';

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      final extracted = responseData.cast<Map<String, dynamic>>();
      _promoProducts.clear();
      _promoProducts = extracted.map<ProductView>((element) => ProductView.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _promoProducts.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOfsProducts() async {
    final url = urlBase + urlStore + urlProduct + urlGetProductList + '?Filter=3';

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      final extracted = responseData.cast<Map<String, dynamic>>();
      _outOfStockProducts.clear();
      _outOfStockProducts = extracted.map<ProductView>((element) => ProductView.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _outOfStockProducts.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getProducts() async {
    await getAllProducts();
    await getPromoProducts();
    await getOfsProducts();
  }
}
