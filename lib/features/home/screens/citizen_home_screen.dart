import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/home/Widgets/add_transaction_sheet.dart%20%20Dart.dart';
import 'package:transactiontrackingsystemflutter/features/home/Widgets/transaction_list_item.dart';
import '../Widgets/quick_stats_row.dart';
import '../Widgets/transaction_filter_bar.dart';
import '../../transactions/controllers/transaction_controller.dart';
// استيراد الـ Widgets الجديدة التي سننشئها بالأسفل
import '../Widgets/transaction_details_sheet.dart';
import '../Widgets/settings_sheet.dart';

class CitizenHomeScreen extends GetView<TransactionController> {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.bottomSheet(
          AddTransactionSheet(controller: controller),
          isScrollControlled: true,
        ),
        backgroundColor: const Color(0xFF0D47A1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("معاملة جديدة",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: CustomScrollView(
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
                    Obx(() => QuickStatsRow(
                      total: controller.stats['total'] ?? controller.transactions.length,
                      pending: controller.stats['pending'] ?? 0,
                    )),
                    const SizedBox(height: 30),
                    _buildSectionTitle("تصنيف حسب الحالة"),
                    const SizedBox(height: 12),
                    TransactionFilterBar(controller: controller),
                    const SizedBox(height: 25),
                    _buildSectionTitle("قائمة المعاملات"),
                    const SizedBox(height: 15),
                    _buildTransactionsList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.transactions.isEmpty) {
        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
      }

      // منطق الفلترة
      final displayedList = controller.selectedStatus.value == 0
          ? controller.transactions
          : controller.transactions.where((t) => t['transaction_status_id'] == controller.selectedStatus.value).toList();

      if (displayedList.isEmpty) return _buildEmptyState();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayedList.length,
        itemBuilder: (context, index) {
          final t = displayedList[index];
          return TransactionListItem(
            transaction: t,
            onTap: () => Get.bottomSheet(
              TransactionDetailsSheet(transaction: t),
              isScrollControlled: true,
            ),
          );
        },
      );
    });
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: const Color(0xFF0D47A1),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () => Get.bottomSheet(const SettingsSheet()),
        ),
      ],
      flexibleSpace: const FlexibleSpaceBar(title: Text("لوحة التحكم")),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)));

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(children: [
        Icon(Icons.cloud_off_outlined, size: 60, color: Colors.grey[300]),
        const SizedBox(height: 10),
        Text("لا توجد معاملات حالياً", style: TextStyle(color: Colors.grey[400]))
      ]),
    ),
  );
}