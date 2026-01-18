class DashboardOverview {
  bool? success;
  int? status;
  String? message;
  DashboardOverviewData? data;

  DashboardOverview({this.success, this.status, this.message, this.data});

  DashboardOverview.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? DashboardOverviewData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DashboardOverviewData {
  String? name;
  String? role;
  String? profileImage;
  String? totalUsers;
  String? totalRevenue;
  String? totalOrders;
  String? pendingOrders;

  DashboardOverviewData({
    this.name,
    this.role,
    this.profileImage,
    this.totalUsers,
    this.totalRevenue,
    this.totalOrders,
    this.pendingOrders,
  });

  DashboardOverviewData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    profileImage = json['profile_image'];
    totalUsers = json['total_users'];
    totalRevenue = json['total_revenue'];
    totalOrders = json['total_orders'];
    pendingOrders = json['pending_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['role'] = role;
    data['profile_image'] = profileImage;
    data['total_users'] = totalUsers;
    data['total_revenue'] = totalRevenue;
    data['total_orders'] = totalOrders;
    data['pending_orders'] = pendingOrders;
    return data;
  }
}
