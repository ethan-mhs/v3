import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:seller/constants/vars.dart';
import 'package:seller/models/notification_model.dart';
import 'package:seller/models/order_cancel.dart';
import 'package:seller/models/order_details.dart';
import 'package:seller/models/order_history.dart';
import 'package:seller/models/order_history_details.dart';
import 'package:seller/models/order_history_product.dart';
import 'package:seller/models/order_status.dart';
import 'package:seller/models/payment_status.dart';
import 'package:seller/models/response.dart';
import 'package:seller/services/network.dart';

import '../models/http_exception.dart';
import '../models/order_history.dart';

class Orders with ChangeNotifier {
  Network _network = new Network();

  final String token;
  Orders(this.token);

  List<OrderHistoryByProduct> _orderHistoryByProductList = new List();
  List<OrderHistoryByCustomer> _orderHistoryByCustomerList = new List();
  List<NotificationModel> _notificationModelList = new List();
  OrderHistoryByProductDetails _orderHistoryByProductDetails;
  OrderDetails _orderDetails;
  String _response;


  List<OrderHistoryByProduct> get orderHistoryByProduct => _orderHistoryByProductList;
  List<OrderHistoryByCustomer> get orderHistoryByCustomer => _orderHistoryByCustomerList;
  List<NotificationModel> get notificationModel => _notificationModelList;
  OrderHistoryByProductDetails get orderHistoryByProductDetails => _orderHistoryByProductDetails;
  OrderDetails get orderDetails => _orderDetails;
  String get response => _response;

  Future<void> updatePaymentStatus({int paymentInfoId, int paymentStatusId}) async {
    final url = urlBase + urlStore + urlOrder + urlUpdatePaymentStatus;

    var body = json.encode(
        PaymentStatus(paymentInfoId: paymentInfoId,paymentStatusId: paymentStatusId));
    try {
      var response = await _network.post(body: body, url: url,token: token);

      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        _response = null;
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      var respondData = ResponseModel.fromJson(responseData);

      _response = respondData.message;
      notifyListeners();

    } catch (error) {
      _response = null;
      notifyListeners();
      throw error;
    }
  }

  Future<void> cancelOrder({int orderId}) async {
    final url = urlBase + urlStore + urlOrder + urlSellerOrderCancel;

    var body = json.encode(
        OrderCancel(orderId: orderId));
    try {
      var response = await _network.post(body: body, url: url,token: token);

      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        _response = null;
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      var respondData = ResponseModel.fromJson(responseData);

      _response = respondData.message;
      notifyListeners();

    } catch (error) {
      _response = null;
      notifyListeners();
      throw error;
    }
  }

  Future<void> updateOrderStatus({int orderId, int orderStatusId}) async {
    final url = urlBase + urlStore + urlOrder + urlUpdateOrderStatus;

    var body = json.encode(
        OrderStatusGet(orderId: orderId,orderStatusId: orderStatusId));
    try {
      var response = await _network.post(body: body, url: url,token: token);

      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        _response = null;
        notifyListeners();
        throw HttpException(responseData['message']);
      }
      var respondData = ResponseModel.fromJson(responseData);

      _response = respondData.message;
      notifyListeners();

    } catch (error) {
      _response = null;
      notifyListeners();
      throw error;
    }
  }

  Future<void> getOrderDetails({@required int id}) async {
    final url = urlBase + urlStore + urlOrder + urlGetOrderDetails + '?OrderId=' + id.toString();

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
      var orderDetail  = OrderDetails.fromJson(responseData);
      _orderDetails = orderDetail;
      notifyListeners();
    } catch (error) {
      _orderDetails = null;
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOrderHistoryByCustomer({String voucher,int orderStatusId,String orderDate,String paymentDate,String paymentStatusId}) async {
    String url;
    if (voucher == null){
      url = urlBase + urlStore + urlOrder + urlGetOrders;
    }else{
      url = urlBase + urlStore + urlOrder + urlGetOrders + '?VoucherNo=$voucher';
    }

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      final extracted = responseData.cast<Map<String, dynamic>>();
      _orderHistoryByCustomerList.clear();
      _orderHistoryByCustomerList = extracted.map<OrderHistoryByCustomer>((element) => OrderHistoryByCustomer.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _orderHistoryByCustomerList.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOrderHistoryByProduct({String name}) async {
    String url;
    if (name == null){
       url = urlBase + urlStore + urlOrder + urlGetOrdersByProduct;
    }else{
       url = urlBase + urlStore + urlOrder + urlGetOrdersByProduct + '?ProductName=$name';
    }

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      final extracted = responseData.cast<Map<String, dynamic>>();
      _orderHistoryByProductList.clear();
      _orderHistoryByProductList = extracted.map<OrderHistoryByProduct>((element) => OrderHistoryByProduct.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _orderHistoryByProductList.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOrderHistoryByProductDetails({@required int id}) async {
    final url = urlBase + urlStore + urlOrder + urlGetOrderHistoryDetails + id.toString();

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      var orderHistoryDetails  = OrderHistoryByProductDetails.fromJson(responseData);
      _orderHistoryByProductDetails = orderHistoryDetails;
      notifyListeners();
    } catch (error) {
      _orderHistoryByProductDetails = null;
      notifyListeners();
      throw (error);
    }
  }

  Future<void> getOrderHistories() async {
    await getOrderHistoryByProduct();
    await getOrderHistoryByCustomer();
  }

  Future<void> getNotification() async {
    final url = urlBase + urlStore + urlOrder + urlGetNotification;

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }

      final extracted = responseData.cast<Map<String, dynamic>>();
      _notificationModelList.clear();
      _notificationModelList = extracted.map<NotificationModel>((element) => NotificationModel.fromJson(element)).toList();
      notifyListeners();
    } catch (error) {
      _notificationModelList.clear();
      notifyListeners();
      throw (error);
    }
  }

  Future<void> seenNotification({@required int id}) async {
    final url = urlBase + urlStore + urlOrder + urlSeenNotification +'?Id=$id';

    try {
      Response response = await _network.get(url: url,token: token);
      var responseData = json.decode(response.body);
      if (response.statusCode >= 300 ) {
        throw HttpException(responseData['message']);
      }
    } catch (error) {
      throw (error);
    }
  }

}
