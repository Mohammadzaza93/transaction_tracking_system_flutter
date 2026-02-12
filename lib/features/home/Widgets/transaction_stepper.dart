import 'package:flutter/material.dart';

class TransactionStepper extends StatelessWidget {
  final int currentStatusId;

  const TransactionStepper({super.key, required this.currentStatusId});

  @override
  Widget build(BuildContext context) {
    // تعريف المراحل بناءً على الصورة التي أرفقتها
    final List<Map<String, dynamic>> steps = [
      {'id': 1, 'label': 'المعاملة قيد الانشاء'},
      {'id': 2, 'label': 'بحاجة الى تثبيت'},
      {'id': 3, 'label': 'بحاجة الى دفع رسوم'},
      {'id': 4, 'label': 'قيد الانجاز'},
      {'id': 5, 'label': 'منجزة'},
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final bool isCompleted = currentStatusId >= step['id'];
        final bool isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العمود الجانبي (الدائرة والخط)
            Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF0D47A1) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted && currentStatusId > step['id']
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text("${step['id']}",
                        style: TextStyle(color: isCompleted ? Colors.white : Colors.grey[600], fontSize: 14)),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted && currentStatusId > step['id']
                        ? const Color(0xFF0D47A1)
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 20),
            // النص الشارح للمرحلة
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                step['label'],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  color: isCompleted ? Colors.black87 : Colors.grey[500],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}