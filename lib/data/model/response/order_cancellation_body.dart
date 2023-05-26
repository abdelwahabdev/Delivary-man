class OrderCancellationBody {
  int totalSize;
  String limit;
  String offset;
  List<CancellationData> reasons;

  OrderCancellationBody({this.totalSize, this.limit, this.offset, this.reasons});

  OrderCancellationBody.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['reasons'] != null) {
      reasons = <CancellationData>[];
      json['reasons'].forEach((v) {
        reasons.add(new CancellationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.reasons != null) {
      data['reasons'] = this.reasons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CancellationData {
  int id;
  String reason;
  String userType;
  int status;
  String createdAt;
  String updatedAt;

  CancellationData(
      {this.id,
        this.reason,
        this.userType,
        this.status,
        this.createdAt,
        this.updatedAt});

  CancellationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    userType = json['user_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason'] = this.reason;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}