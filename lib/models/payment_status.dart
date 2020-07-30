class PaymentStatus {
  int paymentInfoId;
  int paymentStatusId;

  PaymentStatus({this.paymentInfoId, this.paymentStatusId});

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    paymentInfoId = json['paymentInfoId'];
    paymentStatusId = json['paymentStatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentInfoId'] = this.paymentInfoId;
    data['paymentStatusId'] = this.paymentStatusId;
    return data;
  }
}