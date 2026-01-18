class LoginResponseModel {
  String? message;
  LoginData? data;
  String? accessToken;
  String? refreshToken;

  LoginResponseModel({
    this.message,
    this.data,
    this.accessToken,
    this.refreshToken,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}

class LoginData {
  int? id;
  String? name;
  String? mobile;
  String? email;
  String? role;
  String? profileImage;
  Address? address;
  String? createdAt;

  LoginData({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.role,
    this.profileImage,
    this.address,
    this.createdAt,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    role = json['role'];
    profileImage = json['profileImage'];
    address = json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['role'] = role;
    data['profileImage'] = profileImage;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;

  Address({this.street, this.city, this.state, this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    return data;
  }
}
