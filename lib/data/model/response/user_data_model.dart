class UserDataModel {
  int totalSize;
  int limit;
  int offset;
  List<Data> data;

  UserDataModel({this.totalSize, this.limit, this.offset, this.data});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String fName;
  String lName;
  String image;
  String phone;
  String email;
  int userId;
  int vendorId;
  int deliverymanId;

  Data({
    this.id,
    this.fName,
    this.lName,
    this.image,
    this.phone,
    this.email,
    this.userId,
    this.vendorId,
    this.deliverymanId,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['fName'];
    lName = json['lName'];
    image = json['image'];
    phone = json['phone'];
    email = json['email'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    deliverymanId = json['deliveryman_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fName'] = this.fName;
    data['lName'] = this.lName;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['user_id'] = this.userId;
    data['vendor_id'] = this.vendorId;
    data['deliveryman_id'] = this.deliverymanId;

    return data;
  }
}