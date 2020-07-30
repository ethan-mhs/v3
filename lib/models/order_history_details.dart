class OrderHistoryByProductDetails {
  String productName;
  String productUrl;
  int productId;
  int orderCount;
  double price;
  int totalQty;
  String skuValue;
  List<User> userList;

  OrderHistoryByProductDetails(
      {this.productName,
        this.productUrl,
        this.productId,
        this.orderCount,
        this.price,
        this.totalQty,
        this.skuValue,
        this.userList});

  OrderHistoryByProductDetails.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productUrl = json['productUrl'];
    productId = json['productId'];
    orderCount = json['orderCount'];
    price = json['price'];
    totalQty = json['totalQty'];
    skuValue = json['skuValue'];
    if (json['userList'] != null) {
      userList = new List<User>();
      json['userList'].forEach((v) {
        userList.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['productUrl'] = this.productUrl;
    data['productId'] = this.productId;
    data['orderCount'] = this.orderCount;
    data['price'] = this.price;
    data['totalQty'] = this.totalQty;
    data['skuValue'] = this.skuValue;
    if (this.userList != null) {
      data['userList'] = this.userList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int orderId;
  int qty;
  String sku;
  String orderStatus;
  int orderStatusId;
  int paymentInfoId;
  String paymentStatus;
  int paymentStatusId;
  String paymentServiceName;
  String paymentServiceImgPath;
  int userId;
  String userName;
  String userUrl;
  String orderCreatedDate;
  String createdDate;

  User(
      {this.orderId,
        this.qty,
        this.sku,
        this.orderStatus,
        this.orderStatusId,
        this.paymentInfoId,
        this.paymentStatus,
        this.paymentStatusId,
        this.paymentServiceName,
        this.paymentServiceImgPath,
        this.userId,
        this.userName,
        this.userUrl,
        this.orderCreatedDate,
        this.createdDate});

  User.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    qty = json['qty'];
    sku = json['sku'];
    orderStatus = json['orderStatus'];
    orderStatusId = json['orderStatusId'];
    paymentInfoId = json['paymentInfoId'];
    paymentStatus = json['paymentStatus'];
    paymentStatusId = json['paymentStatusId'];
    paymentServiceName = json['paymentServiceName'];
    paymentServiceImgPath = json['paymentServiceImgPath'];
    userId = json['userId'];
    userName = json['userName'];
    userUrl = json['userUrl'];
    orderCreatedDate = json['orderCreatedDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['qty'] = this.qty;
    data['sku'] = this.sku;
    data['orderStatus'] = this.orderStatus;
    data['orderStatusId'] = this.orderStatusId;
    data['paymentInfoId'] = this.paymentInfoId;
    data['paymentStatus'] = this.paymentStatus;
    data['paymentStatusId'] = this.paymentStatusId;
    data['paymentServiceName'] = this.paymentServiceName;
    data['paymentServiceImgPath'] = this.paymentServiceImgPath;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['userUrl'] = this.userUrl;
    data['orderCreatedDate'] = this.orderCreatedDate;
    data['createdDate'] = this.createdDate;
    return data;
  }
}