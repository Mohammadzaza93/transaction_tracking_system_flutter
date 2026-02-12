import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/auth/controllers/auth_controller.dart';
import 'package:transactiontrackingsystemflutter/features/transactions/controllers/transaction_controller.dart';
import '../controllers/home_controller.dart';

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TransactionController controller = Get.find<TransactionController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionDialog(context, controller),
        backgroundColor: const Color(0xFF0D47A1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("معاملة جديدة",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("إحصائيات معاملاتك"),
                  const SizedBox(height: 15),

                  // الإحصائيات مربوطة بالـ Controller
                  Obx(() => _buildQuickStats(
                      controller.stats['total'] ?? controller.transactions.length,
                      controller.stats['pending'] ?? 0
                  )),

                  const SizedBox(height: 30),
                  _buildSectionTitle("تصنيف حسب الحالة"),
                  const SizedBox(height: 12),

                  // 1. شريط الفلترة (جديد)
                  _buildFilterBar(controller),

                  const SizedBox(height: 25),
                  _buildSectionTitle("قائمة المعاملات"),
                  const SizedBox(height: 15),

                  // 2. عرض القائمة المفلترة
                  Obx(() {
                    if (controller.isLoading.value && controller.transactions.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // منطق الفلترة البرمجي بناءً على الحالة المختارة
                    List displayedList = controller.transactions;
                    if (controller.selectedStatus.value != 0) {
                      displayedList = controller.transactions.where((t) =>
                      t['transaction_status_id'] == controller.selectedStatus.value).toList();
                    }

                    if (displayedList.isEmpty) return _buildEmptyState();
                    return _buildRecentTransactionsList(displayedList, context);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- شريط التصنيفات (Filter Bar) ---
  Widget _buildFilterBar(TransactionController controller) {
    final statuses = [
      {'id': 0, 'label': 'الكل', 'icon': Icons.all_inclusive},
      {'id': 1, 'label': 'قيد الدراسة', 'icon': Icons.hourglass_bottom},
      {'id': 3, 'label': 'نواقص', 'icon': Icons.assignment_late},
      {'id': 4, 'label': 'مقبولة', 'icon': Icons.check_circle},
      {'id': 5, 'label': 'مرفوضة', 'icon': Icons.cancel},
    ];

    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final s = statuses[index];
          return Obx(() {
            bool isSelected = controller.selectedStatus.value == s['id'];
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FilterChip(
                label: Text(s['label'] as String),
                selected: isSelected,
                onSelected: (val) => controller.selectedStatus.value = s['id'] as int,
                selectedColor: const Color(0xFF0D47A1),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          });
        },
      ),
    );
  }

  // --- عرض التفاصيل وتحديثات الموظف (Details Sheet) ---
  void _showTransactionDetails(BuildContext context, dynamic t) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("تفاصيل المعاملة #${t['id']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildStatusBadge(t['transaction_status_id'], t['status_relation']?['name']),
              ],
            ),
            const Divider(height: 30),
            _detailRow(Icons.category, "النوع", t['transaction_type']),
            _detailRow(Icons.calendar_today, "تاريخ التقديم", t['created_at']?.split('T')[0]),
            const SizedBox(height: 20),
            const Text(
                "ملاحظات وتحديثات الموظف:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                // تغيير اللون ليكون أخضر فاتح إذا كانت مقبولة، ورمادي إذا كانت قيد التدقيق
                color: t['transaction_status_id'] == 4 ? Colors.green[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: t['transaction_status_id'] == 4 ? Colors.green[200]! : Colors.grey[300]!
                ),
              ),
              child: Text(
                // هنا نستخدم الحقل الجديد admin_notes
                t['notes'] != null && t['notes'].toString().isNotEmpty
                    ? t['notes']
                    : "المعاملة قيد التدقيق، سيقوم الموظف بإضافة الملاحظات فور انتهائه.",
                style: TextStyle(
                  color: t['transaction_status_id'] == 4 ? Colors.green[900] : Colors.black87,
                  fontStyle: t['notes'] == null ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.back(), child: const Text("إغلاق"))),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _detailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [Icon(icon, size: 18, color: Colors.blue), const SizedBox(width: 10), Text("$label: $value")]),
    );
  }

  // --- التعديل على القائمة لدعم الضغط (List) ---
  Widget _buildRecentTransactionsList(List transactions, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        return InkWell(
          onTap: () => _showTransactionDetails(context, t), // فتح التفاصيل عند الضغط
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                _buildTypeIcon(t['transaction_type']),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t['transaction_type'] ?? "معاملة عامة", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("تحديث: ${t['created_at']?.split('T')[0] ?? '---'}", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                ),
                _buildStatusBadge(t['transaction_status_id'], t['status_relation']?['name']),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- تحسين الـ Badge ليعمل مع ألوان الحالات ---
  Widget _buildStatusBadge(int? statusId, String? statusName) {
    Color color;
    switch (statusId) {
      case 1: color = Colors.orange; break;
      case 4: color = Colors.green; break;
      case 5: color = Colors.red; break;
      default: color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(statusName ?? "قيد الدراسة", style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
  void _showSettingsSheet() {
    final authController = Get.find<AuthController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "الإعدادات",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _settingsTile(
              icon: Icons.logout,
              title: "تسجيل الخروج",
              color: Colors.red,
              onTap: () {
                final auth = Get.find<AuthController>();
                auth.logout();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Color color = Colors.black87,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // --- الدوال المساعدة السابقة (تظل كما هي) ---
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: const Color(0xFF0D47A1),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => _showSettingsSheet(),
        ),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        title: Text("لوحة التحكم"),
      ),
    );
  }
  Widget _buildSectionTitle(String title) { return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))); }
  Widget _buildQuickStats(int total, int pending) { return Row(children: [_statCard("إجمالي الطلبات", "$total", Colors.blue, Icons.list_alt_rounded), const SizedBox(width: 15), _statCard("قيد المعالجة", "$pending", Colors.orange, Icons.hourglass_empty_rounded)]); }
  Widget _statCard(String title, String count, Color color, IconData icon) { return Expanded(child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: color, size: 28), const SizedBox(height: 15), Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12))]))); }
  Widget _buildTypeIcon(String? type) { IconData icon = Icons.article_outlined; if (type == "تجديد هوية") icon = Icons.badge_outlined; if (type == "بيان ولادة") icon = Icons.child_care_rounded; return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF0D47A1).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: const Color(0xFF0D47A1))); }
  Widget _buildEmptyState() { return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.cloud_off_outlined, size: 60, color: Colors.grey[300]), const SizedBox(height: 10), Text("لا توجد معاملات حالياً", style: TextStyle(color: Colors.grey[400]))]))); }
  void _showAddTransactionDialog(BuildContext context, TransactionController controller) {
    String selectedType = "بيان عائلي";
    final reasonController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "تقديم معاملة جديدة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // اختيار نوع المعاملة
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "نوع المعاملة",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: ["بيان عائلي", "تجديد هوية", "بيان ولادة", "جواز سفر"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => selectedType = val!,
              ),
              const SizedBox(height: 20),

              // حقل سبب الطلب
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "تفاصيل أو سبب الطلب",
                  hintText: "اكتب هنا تفاصيل إضافية للمعاملة...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 30),

              // زر الإرسال مع حالة التحميل
              Obx(() => SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.addTransaction(selectedType, reasonController.text),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("إرسال الطلب الآن",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }}