class LoginRespond {
  Token token;
  User user;

  LoginRespond({this.token, this.user});

  LoginRespond.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class Token {
  String accessToken;
  double accessTokenExpiration;
  String refreshToken;

  DateTime get expiryDate {
    return DateTime.now().add(
      Duration(
        seconds: accessTokenExpiration.toInt(),
      ),
    );
  }

  Token({this.accessToken, this.accessTokenExpiration, this.refreshToken});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExpiration = json['accessTokenExpiration'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['accessTokenExpiration'] = this.accessTokenExpiration;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

class User {
  int id;
  String phoneNo;
  String email;
  String name;
  int cityId;
  int townshipId;

  User(
      {this.id,
        this.phoneNo,
        this.email,
        this.name,
        this.cityId,
        this.townshipId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    name = json['name'];
    cityId = json['cityId'];
    townshipId = json['townshipId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNo'] = this.phoneNo;
    data['email'] = this.email;
    data['name'] = this.name;
    data['cityId'] = this.cityId;
    data['townshipId'] = this.townshipId;
    return data;
  }
}