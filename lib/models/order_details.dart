class OrderDetails {
  int orderId;
  String voucherNo;
  String orderDate;
  double totalAmt;
  double deliveryFee;
  double netAmt;
  bool isDeleted;
  int userId;
  String userUrl;
  OrderStatus orderStatus;
  List<OrderItem> orderItem;
  DeliveryInfo deliveryInfo;
  List<PaymentInfo> paymentInfo;

  OrderDetails(
      {this.orderId,
        this.voucherNo,
        this.orderDate,
        this.totalAmt,
        this.deliveryFee,
        this.netAmt,
        this.isDeleted,
        this.userId,
        this.userUrl,
        this.orderStatus,
        this.orderItem,
        this.deliveryInfo,
        this.paymentInfo});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    voucherNo = json['voucherNo'];
    orderDate = json['orderDate'];
    totalAmt = json['totalAmt'];
    deliveryFee = json['deliveryFee'];
    netAmt = json['netAmt'];
    isDeleted = json['isDeleted'];
    userId = json['userId'];
    userUrl = json['userUrl'];
    orderStatus = json['orderStatus'] != null
        ? new OrderStatus.fromJson(json['orderStatus'])
        : null;
    if (json['orderItem'] != null) {
      orderItem = new List<OrderItem>();
      json['orderItem'].forEach((v) {
        orderItem.add(new OrderItem.fromJson(v));
      });
    }
    deliveryInfo = json['deliveryInfo'] != null
        ? new DeliveryInfo.fromJson(json['deliveryInfo'])
        : null;
    if (json['paymentInfo'] != null) {
      paymentInfo = new List<PaymentInfo>();
      json['paymentInfo'].forEach((v) {
        paymentInfo.add(new PaymentInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['voucherNo'] = this.voucherNo;
    data['orderDate'] = this.orderDate;
    data['totalAmt'] = this.totalAmt;
    data['deliveryFee'] = this.deliveryFee;
    data['netAmt'] = this.netAmt;
    data['isDeleted'] = this.isDeleted;
    data['userId'] = this.userId;
    data['userUrl'] = this.userUrl;
    if (this.orderStatus != null) {
      data['orderStatus'] = this.orderStatus.toJson();
    }
    if (this.orderItem != null) {
      data['orderItem'] = this.orderItem.map((v) => v.toJson()).toList();
    }
    if (this.deliveryInfo != null) {
      data['deliveryInfo'] = this.deliveryInfo.toJson();
    }
    if (this.paymentInfo != null) {
      data['paymentInfo'] = this.paymentInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderStatus {
  int id;
  String name;

  OrderStatus({this.id, this.name});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class OrderItem {
  int id;
  String name;
  double price;
  int skuId;
  int qty;
  String skuValue;
  String url;

  OrderItem(
      {this.id,
        this.name,
        this.price,
        this.skuId,
        this.qty,
        this.skuValue,
        this.url});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    skuId = json['skuId'];
    qty = json['qty'];
    skuValue = json['skuValue'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['skuId'] = this.skuId;
    data['qty'] = this.qty;
    data['skuValue'] = this.skuValue;
    data['url'] = this.url;
    return data;
  }
}

class DeliveryInfo {
  String name;
  String cityName;
  String townshipName;
  int cityId;
  int townshipId;
  String address;
  String phNo;
  String remark;
  String deliveryDate;
  DeliveryService deliveryService;

  DeliveryInfo(
      {this.name,
        this.cityName,
        this.townshipName,
        this.cityId,
        this.townshipId,
        this.address,
        this.phNo,
        this.remark,
        this.deliveryDate,
        this.deliveryService});

  DeliveryInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cityName = json['cityName'];
    townshipName = json['townshipName'];
    cityId = json['cityId'];
    townshipId = json['townshipId'];
    address = json['address'];
    phNo = json['phNo'];
    remark = json['remark'];
    deliveryDate = json['deliveryDate'];
    deliveryService = json['deliveryService'] != null
        ? new DeliveryService.fromJson(json['deliveryService'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['cityName'] = this.cityName;
    data['townshipName'] = this.townshipName;
    data['cityId'] = this.cityId;
    data['townshipId'] = this.townshipId;
    data['address'] = this.address;
    data['phNo'] = this.phNo;
    data['remark'] = this.remark;
    data['deliveryDate'] = this.deliveryDate;
    if (this.deliveryService != null) {
      data['deliveryService'] = this.deliveryService.toJson();
    }
    return data;
  }
}

class DeliveryService {
  int id;
  String name;
  int fromEstDeliveryDay;
  int toEstDeliveryDay;
  double serviceAmount;
  String imgPath;

  DeliveryService(
      {this.id,
        this.name,
        this.fromEstDeliveryDay,
        this.toEstDeliveryDay,
        this.serviceAmount,
        this.imgPath});

  DeliveryService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fromEstDeliveryDay = json['fromEstDeliveryDay'];
    toEstDeliveryDay = json['toEstDeliveryDay'];
    serviceAmount = json['serviceAmount'];
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fromEstDeliveryDay'] = this.fromEstDeliveryDay;
    data['toEstDeliveryDay'] = this.toEstDeliveryDay;
    data['serviceAmount'] = this.serviceAmount;
    data['imgPath'] = this.imgPath;
    return data;
  }
}

class PaymentInfo {
  int id;
  String transactionDate;
  String approveImg;
  String phoneNo;
  String remark;
  bool isApproved;
  PaymentService paymentService;
  OrderStatus paymentStatus;

  PaymentInfo(
      {this.id,
        this.transactionDate,
        this.approveImg,
        this.phoneNo,
        this.remark,
        this.isApproved,
        this.paymentService,
        this.paymentStatus});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionDate = json['transactionDate'];
    approveImg = json['approveImg'];
    phoneNo = json['phoneNo'];
    remark = json['remark'];
    isApproved = json['isApproved'];
    paymentService = json['paymentService'] != null
        ? new PaymentService.fromJson(json['paymentService'])
        : null;
    paymentStatus = json['paymentStatus'] != null
        ? new OrderStatus.fromJson(json['paymentStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactionDate'] = this.transactionDate;
    data['approveImg'] = this.approveImg;
    data['phoneNo'] = this.phoneNo;
    data['remark'] = this.remark;
    data['isApproved'] = this.isApproved;
    if (this.paymentService != null) {
      data['paymentService'] = this.paymentService.toJson();
    }
    if (this.paymentStatus != null) {
      data['paymentStatus'] = this.paymentStatus.toJson();
    }
    return data;
  }
}

class PaymentService {
  String name;
  String bankName;
  String imgPath;

  PaymentService({this.name, this.bankName, this.imgPath});

  PaymentService.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bankName = json['bankName'];
    imgPath = json['imgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['bankName'] = this.bankName;
    data['imgPath'] = this.imgPath;
    return data;
  }
}