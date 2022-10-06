class UserModel {
  String? uid;
  String? name;
  String? number;
  String? altNumber;
  String? gmail;
  String? location;
  String? landmark;
  String? fcmToken;
  String? pinCode;

  UserModel(
      {this.uid,
        this.name,
        this.number,
        this.altNumber,
        this.gmail,
        this.location,
        this.landmark,
        this.pinCode,
        this.fcmToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    number = json['number'];
    altNumber = json['altNumber'];
    gmail = json['gmail'];
    location = json['location'];
    landmark = json['landmark'];
    fcmToken = json['fcmToken'];
    pinCode = json['pinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['number'] = this.number;
    data['altNumber'] = this.altNumber;
    data['gmail'] = this.gmail;
    data['location'] = this.location;
    data['landmark'] = this.landmark;
    data['fcmToken'] = this.fcmToken;
    data['pinCode'] = this.pinCode;
    return data;
  }
}
