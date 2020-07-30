class NotificationModel {
  int id;
  String body;
  String url;
  String redirectAction;
  String referenceAttribute;
  String notificationDate;
  int count;
  bool isSeen;

  NotificationModel(
      {this.id,
        this.body,
        this.url,
        this.redirectAction,
        this.referenceAttribute,
        this.notificationDate,
        this.count,
        this.isSeen});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    url = json['url'];
    redirectAction = json['redirectAction'];
    referenceAttribute = json['referenceAttribute'];
    notificationDate = json['notificationDate'];
    count = json['count'];
    isSeen = json['isSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['body'] = this.body;
    data['url'] = this.url;
    data['redirectAction'] = this.redirectAction;
    data['referenceAttribute'] = this.referenceAttribute;
    data['notificationDate'] = this.notificationDate;
    data['count'] = this.count;
    data['isSeen'] = this.isSeen;
    return data;
  }
}