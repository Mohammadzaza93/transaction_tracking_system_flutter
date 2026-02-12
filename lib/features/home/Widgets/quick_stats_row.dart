import 'package:flutter/material.dart';

class QuickStatsRow extends StatelessWidget {
  final int total;
  final int pending;

  const QuickStatsRow({super.key, required this.total, required this.pending});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("إجمالي الطلبات", "$total", Colors.blue, Icons.list_alt_rounded),
        const SizedBox(width: 15),
        _statCard("قيد المعالجة", "$pending", Colors.orange, Icons.hourglass_empty_rounded),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
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
}