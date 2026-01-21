class RecentTransactionModel {
  bool? success;
  int? status;
  String? message;
  List<DashboardTransactionData>? data;

  RecentTransactionModel({this.success, this.status, this.message, this.data});

  RecentTransactionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DashboardTransactionData>[];
      json['data'].forEach((v) {
        data!.add(DashboardTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashboardTransactionData {
  String? orderId;
  String? customerName;
  String? amount;
  String? date;
  String? status;

  DashboardTransactionData({
    this.orderId,
    this.customerName,
    this.amount,
    this.date,
    this.status,
  });

  DashboardTransactionData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerName = json['customer_name'];
    amount = json['amount'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['customer_name'] = customerName;
    data['amount'] = amount;
    data['date'] = date;
    data['status'] = status;
    return data;
  }
}
