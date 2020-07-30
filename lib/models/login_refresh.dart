class LoginRefresh {
  String accessToken;
  String refreshToken;
  int applicationConfigId;

  LoginRefresh({this.accessToken, this.refreshToken, this.applicationConfigId = 3});

  LoginRefresh.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    applicationConfigId = json['applicationConfigId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['applicationConfigId'] = this.applicationConfigId;
    return data;
  }
}