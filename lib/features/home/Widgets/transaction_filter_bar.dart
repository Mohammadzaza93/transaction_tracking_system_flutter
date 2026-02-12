import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/transactions/controllers/transaction_controller.dart';

class TransactionFilterBar extends StatelessWidget {
  final TransactionController controller;

  const TransactionFilterBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {'id': 0, 'label': 'الكل'},
      {'id': 1, 'label': 'قيد الدراسة'},
      {'id': 3, 'label': 'نواقص'},
      {'id': 4, 'label': 'مقبولة'},
      {'id': 5, 'label': 'مرفوضة'},
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
                side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.shade200),
              ),
            );
          });
        },
      ),
    );
  }
}