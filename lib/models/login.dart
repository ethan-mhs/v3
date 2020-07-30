class Login {
  String emailOrPhoneNo;
  String password;
  String userType;
  int applicationConfigId;

  Login(
      { this.emailOrPhoneNo,
        this.password,
        this.userType = 'seller',
        this.applicationConfigId = 3});

  Login.fromJson(Map<String, dynamic> json) {
    emailOrPhoneNo = json['emailOrPhoneNo'];
    password = json['password'];
    userType = json['userType'];
    applicationConfigId = json['applicationConfigId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailOrPhoneNo'] = this.emailOrPhoneNo;
    data['password'] = this.password;
    data['userType'] = this.userType;
    data['applicationConfigId'] = this.applicationConfigId;
    return data;
  }
}