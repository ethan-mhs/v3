class OrderStatusGet {
  int orderId;
  int orderStatusId;

  OrderStatusGet({this.orderId, this.orderStatusId});

  OrderStatusGet.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderStatusId = json['orderStatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderStatusId'] = this.orderStatusId;
    return data;
  }
}