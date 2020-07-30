class Profile {
  int id;
  String phoneNo;
  String email;
  String name;
  String userTypeName;
  String description;
  String cityName;
  String townName;
  String url;
  int cityId;
  int townId;

  Profile(
      {this.id,
        this.phoneNo,
        this.email,
        this.name,
        this.userTypeName,
        this.description,
        this.cityName,
        this.townName,
        this.url,
        this.cityId,
        this.townId});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNo = json['phoneNo'];
    email = json['email'];
    name = json['name'];
    userTypeName = json['userTypeName'];
    description = json['description'];
    cityName = json['cityName'];
    townName = json['townName'];
    url = json['url'];
    cityId = json['cityId'];
    townId = json['townId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNo'] = this.phoneNo;
    data['email'] = this.email;
    data['name'] = this.name;
    data['userTypeName'] = this.userTypeName;
    data['description'] = this.description;
    data['cityName'] = this.cityName;
    data['townName'] = this.townName;
    data['url'] = this.url;
    data['cityId'] = this.cityId;
    data['townId'] = this.townId;
    return data;
  }
}