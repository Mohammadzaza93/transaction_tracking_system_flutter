import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final dynamic transaction;

  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("تفاصيل المعاملة #${t['id']}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildBadge(t['transaction_status_id'], t['status_relation']?['name']),
            ],
          ),
          const Divider(height: 30),
          _detailRow(Icons.category, "النوع", t['transaction_type']),
          _detailRow(Icons.calendar_today, "التاريخ", t['created_at']?.split('T')[0]),
          const SizedBox(height: 20),
          const Text("ملاحظات الموظف:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 10),
          _buildNotesContainer(t),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.back(), child: const Text("إغلاق"))),
        ],
      ),
    );
  }

  Widget _buildNotesContainer(dynamic t) {
    bool isAccepted = t['transaction_status_id'] == 4;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAccepted ? Colors.green[200]! : Colors.grey[300]!),
      ),
      child: Text(t['notes'] ?? "المعاملة قيد التدقيق حالياً..."),
    );
  }

  Widget _detailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [Icon(icon, size: 18, color: Colors.blue), const SizedBox(width: 10), Text("$label: $value")]),
    );
  }

  Widget _buildBadge(int? id, String? name) {
    Color c = id == 4 ? Colors.green : (id == 5 ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(name ?? "قيد الدراسة", style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}