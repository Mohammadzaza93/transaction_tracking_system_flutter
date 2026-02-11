import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء المتحكم وربطه بالواجهة
    final HomeController controller = Get.put(HomeController());

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
          // 1. رأس الصفحة العلوي
          _buildSliverAppBar(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("إحصائيات معاملاتك"),
                  const SizedBox(height: 15),

                  // 2. تحديث الإحصائيات لتكون تفاعلية
                  Obx(() => _buildQuickStats(controller.transactions.length)),

                  const SizedBox(height: 30),
                  _buildSectionTitle("آخر المعاملات المقدمة"),
                  const SizedBox(height: 15),

                  // 3. عرض قائمة المعاملات الحقيقية باستخدام Obx
                  Obx(() {
                    if (controller.isLoading.value && controller.transactions.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (controller.transactions.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildRecentTransactionsList(controller.transactions);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- دوال بناء الواجهة (Methods) ---

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: const Color(0xFF0D47A1),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 16),
        title: const Text("لوحة التحكم",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A237E)),
    );
  }

  Widget _buildQuickStats(int total) {
    return Row(
      children: [
        _statCard("إجمالي الطلبات", "$total", Colors.blue, Icons.list_alt_rounded),
        const SizedBox(width: 15),
        _statCard("قيد المعالجة", "جديد", Colors.orange, Icons.hourglass_empty_rounded),
      ],
    );
  }

  Widget _statCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 15),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(List transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final t = transactions[index];
        return Container(
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
                    Text(t['transaction_type'] ?? "معاملة عامة",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("بتاريخ: ${t['created_at']?.split('T')[0] ?? '---'}",
                        style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
              ),
              _buildStatusBadge(t['status_name'] ?? "قيد الدراسة"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
            color: Colors.orange,
            fontSize: 10,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTypeIcon(String? type) {
    IconData icon = Icons.article_outlined;
    if (type == "تجديد هوية") icon = Icons.badge_outlined;
    if (type == "بيان ولادة") icon = Icons.child_care_rounded;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: const Color(0xFF0D47A1).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: const Color(0xFF0D47A1)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.cloud_off_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text("لا توجد معاملات حالياً",
                style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, HomeController controller) {
    // متغيرات لتخزين القيم المدخلة
    String selectedType = "بيان عائلي";
    final reasonCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("تقديم معاملة جديدة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              // 1. حقل اختيار نوع المعاملة
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                  labelText: "نوع المعاملة",
                  prefixIcon: const Icon(Icons.category_outlined),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
                items: ["بيان عائلي", "تجديد هوية", "بيان ولادة", "جواز سفر"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => selectedType = val!,
              ),

              const SizedBox(height: 15),

              // 2. حقل سبب المعاملة (Reason)
              TextField(
                controller: reasonCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "سبب الطلب / التفاصيل",
                  hintText: "اكتب هنا سبب تقديم المعاملة...",
                  prefixIcon: const Icon(Icons.edit_note),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),

              const SizedBox(height: 25),

              // 3. زر الإرسال مع حالة التحميل
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
                      : () {
                    if (reasonCtrl.text.isEmpty) {
                      Get.snackbar("تنبيه", "يرجى كتابة سبب المعاملة", backgroundColor: Colors.orange);
                      return;
                    }
                    // استدعاء الدالة بالمسميات الجديدة
                    controller.addTransaction(selectedType, reasonCtrl.text);
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("إرسال الطلب الآن", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}