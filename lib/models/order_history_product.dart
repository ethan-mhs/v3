class OrderHistoryByProduct {
  int productId;
  String productName;
  String productUrl;
  int orderCount;
  int totalQty;
  double originalPrice;
  double promotePrice;
  String orderDate;
  List<String> userImage;

  OrderHistoryByProduct(
      {this.productId,
        this.productName,
        this.productUrl,
        this.orderCount,
        this.totalQty,
        this.originalPrice,
        this.promotePrice,
        this.orderDate,
        this.userImage});

  OrderHistoryByProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productUrl = json['productUrl'];
    orderCount = json['orderCount'];
    totalQty = json['totalQty'];
    originalPrice = json['originalPrice'];
    promotePrice = json['promotePrice'];
    orderDate = json['orderDate'];
    userImage = json['userImage'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productUrl'] = this.productUrl;
    data['orderCount'] = this.orderCount;
    data['totalQty'] = this.totalQty;
    data['originalPrice'] = this.originalPrice;
    data['promotePrice'] = this.promotePrice;
    data['orderDate'] = this.orderDate;
    data['userImage'] = this.userImage;
    return data;
  }
}