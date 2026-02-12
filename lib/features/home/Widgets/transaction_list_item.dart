import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final dynamic transaction;
  final VoidCallback onTap;

  const TransactionListItem({super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            _buildTypeIcon(transaction['transaction_type']),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction['transaction_type'] ?? "معاملة عامة",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("تحديث: ${transaction['created_at']?.split('T')[0] ?? '---'}",
                      style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                ],
              ),
            ),
            _StatusBadge(statusId: transaction['transaction_status_id'],
                statusName: transaction['status_relation']?['name']),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon(String? type) {
    IconData icon = Icons.article_outlined;
    if (type == "تجديد هوية") icon = Icons.badge_outlined;
    if (type == "بيان ولادة") icon = Icons.child_care_rounded;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFF0D47A1).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: const Color(0xFF0D47A1)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final int? statusId;
  final String? statusName;

  const _StatusBadge({this.statusId, this.statusName});

  @override
  Widget build(BuildContext context) {
    Color color = statusId == 4 ? Colors.green : (statusId == 5 ? Colors.red : (statusId == 1 ? Colors.orange : Colors.blue));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(statusName ?? "قيد الدراسة",
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}