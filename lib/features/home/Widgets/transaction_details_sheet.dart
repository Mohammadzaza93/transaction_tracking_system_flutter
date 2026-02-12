import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final dynamic transaction;

  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    // استخراج الحالة الحالية (Status ID)
    final int currentStatusId = t['transaction_status_id'] ?? 1;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView( // أضفنا ScrolView لضمان ظهور المحتوى كاملاً
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("تفاصيل المعاملة #${t['id']}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBadge(currentStatusId, t['status_relation']?['name']),
              ],
            ),
            const Divider(height: 30),

            // --- قسم تتبع حالة المعاملة (المستوحى من الصورة) ---
            const Text("حالة المعاملة:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0D47A1))),
            const SizedBox(height: 20),
            _buildTransactionStepper(currentStatusId),

            const Divider(height: 30),

            _detailRow(Icons.category, "النوع", t['transaction_type']),
            _detailRow(Icons.calendar_today, "التاريخ", t['created_at']?.split('T')[0]),

            const SizedBox(height: 20),
            const Text("ملاحظات الموظف:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 10),
            _buildNotesContainer(t),

            const SizedBox(height: 25),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("إغلاق", style: TextStyle(color: Colors.white))
                )
            ),
          ],
        ),
      ),
    );
  }

  // ويدجيت رسم المسار الزمني (Stepper)
  Widget _buildTransactionStepper(int currentId) {
    final List<Map<String, dynamic>> steps = [
      {'id': 1, 'label': 'المعاملة قيد الانشاء'},
      {'id': 2, 'label': 'بحاجة الى تثبيت'},
      {'id': 3, 'label': 'بحاجة الى دفع رسوم'},
      {'id': 4, 'label': 'قيد الانجاز'},
      {'id': 5, 'label': 'منجزة'},
    ];

    return Column(
      children: steps.map((step) {
        int index = steps.indexOf(step);
        bool isCompleted = currentId >= step['id'];
        bool isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رسم الدائرة والخط
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF0D47A1) : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted && currentId > step['id']
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text("${step['id']}",
                        style: TextStyle(color: isCompleted ? Colors.white : Colors.grey[600], fontSize: 12)),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted && currentId > step['id'] + 1 ? const Color(0xFF0D47A1) : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 15),
            // النص
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  step['label'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.black87 : Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // شرح بسيط لحالة المعاملة (يظهر داخل صندوق الملاحظات إذا كانت فارغة)
  String _getStatusExplanation(int id) {
    switch (id) {
      case 1: return "تم استلام طلبك، وهو بانتظار المراجعة.";
      case 2: return "يرجى مراجعة القسم المختص لتثبيت البيانات.";
      case 3: return "يرجى التوجه لقسم المحاسبة لدفع الرسوم.";
      case 4: return "المعاملة قيد المعالجة النهائية الآن.";
      case 5: return "جاهزة! يمكنك استلام معاملتك الآن.";
      default: return "المعاملة قيد التدقيق حالياً...";
    }
  }

  Widget _buildNotesContainer(dynamic t) {
    int id = t['transaction_status_id'] ?? 1;
    bool isAccepted = id == 4;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isAccepted ? Colors.green[200]! : Colors.grey[200]!),
      ),
      child: Text(
        t['notes'] ?? _getStatusExplanation(id),
        style: const TextStyle(fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon, size: 18, color: const Color(0xFF0D47A1)),
        const SizedBox(width: 10),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value ?? "---"),
      ]),
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