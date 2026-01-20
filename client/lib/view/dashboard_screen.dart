import 'package:client/core/services/session_manager.dart';
import 'package:client/model/dashboard_overview.dart';
import 'package:client/model/recent_transaction.dart';
import 'package:client/core/services/auth_api_service.dart';
import 'package:client/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  DashboardOverview? dashboardData;
  RecentTransactionModel? recentTransactions;

  final List<String> menuItems = [
    "Dashboard",
    "Users",
    "Products",
    "Reports",
    "Settings",
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_rounded,
    Icons.people_alt_rounded,
    Icons.shopping_bag_rounded,
    Icons.bar_chart_rounded,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  bool isDashboardOverviewLoading = false;
  String errorMessage = "";
  final authApi = AuthApiService();

  Future<void> getUserDetails() async {
    try {
      if (mounted) {
        setState(() => isDashboardOverviewLoading = true);
      }

      await Future.delayed(const Duration(milliseconds: 2000));

      if (!mounted) return;

      dashboardData = await authApi.dashboardOverview();
      recentTransactions = await authApi.recentTransaction();
      setState(() {
        isDashboardOverviewLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isDashboardOverviewLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 900;

    return Skeletonizer(
      enabled: isDashboardOverviewLoading,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        drawer: isMobile ? Drawer(child: _sidebar(isMobile: true)) : null,
        appBar: isMobile
            ? AppBar(
                title: const Text("Dashboard"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/profile");
                      },
                      child: CircleAvatar(
                        radius: 18,
                        child: const Icon(Icons.person_rounded),
                      ),
                    ),
                  ),
                ],
              )
            : null,
        body: Row(
          children: [
            if (!isMobile) _sidebar(),

            // MAIN CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // TOP BAR
                    if (!isMobile) _topBar(),

                    const SizedBox(height: 18),

                    // CONTENT BODY
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // STATS CARDS
                            _statsCards(isMobile),

                            const SizedBox(height: 24),

                            // TABLE
                            _recentTransactionsTable(),

                            const SizedBox(height: 24),

                            // CHART PLACEHOLDER
                            _chartPlaceholder(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- SIDEBAR ----------------
  Widget _sidebar({bool isMobile = false}) {
    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 16),

          // LOGO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF2563EB),
                  child: Icon(Icons.dashboard, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text(
                  "Admin Panel",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final selected = index == selectedIndex;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFEFF6FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      menuIcons[index],
                      color: selected
                          ? const Color(0xFF2563EB)
                          : Colors.black54,
                    ),
                    title: Text(
                      menuItems[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? const Color(0xFF2563EB)
                            : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      setState(() => selectedIndex = index);

                      if (isMobile) Navigator.pop(context); // close drawer
                    },
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // LOGOUT
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
            ),
            onTap: () async {
              await SessionManager.instance.logout().then((_) {
                if (!mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              });
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Welcome Back, ${dashboardData?.data?.name ?? "-"} 👋",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),

          // SEARCH
          SizedBox(
            width: 280,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // NOTIFICATION
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),

          const SizedBox(width: 12),

          // PROFILE
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/profile");
            },
            child: const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person_rounded),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STATS CARDS ----------------
  Widget _statsCards(bool isMobile) {
    final cards = [
      _statCard(
        title: "Total Users",
        value: AmountFormatter.inr(dashboardData?.data?.totalUsers ?? "0"),
        icon: Icons.people_alt_rounded,
      ),
      _statCard(
        title: "Revenue",
        value: AmountFormatter.inr(dashboardData?.data?.totalRevenue ?? "0"),
        icon: Icons.currency_rupee_rounded,
      ),
      _statCard(
        title: "Orders",
        value: dashboardData?.data?.totalOrders ?? "0",
        icon: Icons.shopping_cart_rounded,
      ),
      _statCard(
        title: "Pending",
        value: dashboardData?.data?.pendingOrders ?? "0",
        icon: Icons.pending_actions_rounded,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 1 : 4,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: isMobile ? 3.5 : 1.9,
      children: cards,
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFEFF6FF),
            child: Icon(icon, color: const Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TABLE ----------------
  Widget _recentTransactionsTable() {
    final rows = recentTransactions?.data ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Transactions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          rows.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: Center(
                    child: Text(
                      "No recent transactions found",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      const Color(0xFFF3F4F6),
                    ),

                    columns: const [
                      DataColumn(label: Text("Order ID")),
                      DataColumn(label: Text("Customer")),
                      DataColumn(label: Text("Amount")),
                      DataColumn(label: Text("Status")),
                    ],
                    rows: rows.map((row) {
                      final status = row.status ?? "Unknown";
                      Color statusColor = Colors.green;

                      if (status == "Pending") statusColor = Colors.orange;
                      if (status == "Failed") statusColor = Colors.red;

                      return DataRow(
                        cells: [
                          DataCell(Text(row.orderId ?? "")),
                          DataCell(Text(row.customerName ?? "")),
                          DataCell(
                            Text(
                              AmountFormatter.inr(
                                row.amount ?? "0",
                                showDecimal: true,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const .symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
        ],
      ),
    );
  }

  // ---------------- CHART PLACEHOLDER ----------------
  Widget _chartPlaceholder() {
    return Container(
      height: 260,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Sales Chart",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 14),
          Expanded(
            child: Center(
              child: Text(
                "Chart Placeholder (You can add charts here)",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
