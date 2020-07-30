class OrderHistoryByCustomer {
  int orderId;
  String voucherNo;
  String productUrl;
  double price;
  int qty;
  int orderStatusId;
  String orderStatus;
  String orderDate;
  int paymentStatusId;
  String paymentStatusName;
  String paymentDate;
  String createdDate;
  String paymentServiceImgPath;

  OrderHistoryByCustomer(
      {this.orderId,
        this.voucherNo,
        this.productUrl,
        this.price,
        this.qty,
        this.orderStatusId,
        this.orderStatus,
        this.orderDate,
        this.paymentStatusId,
        this.paymentStatusName,
        this.paymentDate,
        this.createdDate,
        this.paymentServiceImgPath});

  OrderHistoryByCustomer.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    voucherNo = json['voucherNo'];
    productUrl = json['productUrl'];
    price = json['price'];
    qty = json['qty'];
    orderStatusId = json['orderStatusId'];
    orderStatus = json['orderStatus'];
    orderDate = json['orderDate'];
    paymentStatusId = json['paymentStatusId'];
    paymentStatusName = json['paymentStatusName'];
    paymentDate = json['paymentDate'];
    createdDate = json['createdDate'];
    paymentServiceImgPath = json['paymentServiceImgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['voucherNo'] = this.voucherNo;
    data['productUrl'] = this.productUrl;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['orderStatusId'] = this.orderStatusId;
    data['orderStatus'] = this.orderStatus;
    data['orderDate'] = this.orderDate;
    data['paymentStatusId'] = this.paymentStatusId;
    data['paymentStatusName'] = this.paymentStatusName;
    data['paymentDate'] = this.paymentDate;
    data['createdDate'] = this.createdDate;
    data['paymentServiceImgPath'] = this.paymentServiceImgPath;
    return data;
  }
}