import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/transactions/controllers/transaction_controller.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final dynamic transaction;

  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionController>();
    final t = transaction;

    final int currentStatusId = t['transaction_status_id'] ?? 1;
    final bool isPending = currentStatusId == 1;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// العنوان + الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("تفاصيل المعاملة #${t['id']}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                _buildBadge(currentStatusId,
                    t['status_relation']?['name']),
              ],
            ),

            const Divider(height: 30),

            /// مسار الحالة
            const Text("حالة المعاملة:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 20),
            _buildTransactionStepper(currentStatusId),

            const Divider(height: 30),

            /// التفاصيل
            _detailRow(Icons.category, "النوع", t['transaction_type']),
            _detailRow(Icons.calendar_today, "التاريخ",
                t['created_at']?.split('T')[0]),

            const SizedBox(height: 20),

            const Text("ملاحظات الموظف:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            const SizedBox(height: 10),
            _buildNotesContainer(t),

            /// أزرار التعديل والحذف (فقط Pending)
            if (isPending) ...[
              const SizedBox(height: 25),
              Row(
                children: [

                  /// تعديل
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.edit,
                          color: Colors.white),
                      label: const Text("تعديل",
                          style: TextStyle(
                              color: Colors.white)),
                      onPressed: () {
                        _showEditDialog(controller, t);
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// حذف
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.delete,
                          color: Colors.white),
                      label: const Text("حذف",
                          style: TextStyle(
                              color: Colors.white)),
                      onPressed: () {
                        _confirmDelete(
                            controller, t['id']);
                      },
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            /// زر إغلاق
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12)),
                ),
                onPressed: () => Get.back(),
                child: const Text("إغلاق",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
      TransactionController controller, dynamic t) {

    final copiesController =
    TextEditingController(text: t['copies_count'].toString());

    final RxString selectedType =
        (t['transaction_type'] as String).obs;

    final List<String> transactionTypes = [
      "بيان قيد",
      "بيان عائلي",
      "إخراج قيد",
      "شهادة ميلاد",
      "شهادة وفاة",
      "صورة قيد فردي",
    ];


    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "تعديل المعاملة",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// نوع المعاملة (Dropdown)
              Obx(() => DropdownButtonFormField<String>(
                value: selectedType.value,
                items: transactionTypes
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: "نوع المعاملة",
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    selectedType.value = value;
                  }
                },
              )),

              const SizedBox(height: 20),

              /// عدد النسخ
              TextField(
                controller: copiesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "عدد النسخ",
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  /// زر حفظ
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                      ),
                      onPressed: () {

                        int copies =
                            int.tryParse(copiesController.text) ?? 0;

                        if (copies <= 0) {
                          Get.snackbar("خطأ",
                              "عدد النسخ يجب أن يكون أكبر من صفر");
                          return;
                        }

                        controller.updateTransaction(
                          t['id'],
                          selectedType.value,
                          copies,
                        );

                        Get.back(); // اغلاق dialog
                        Get.back(); // اغلاق bottom sheet
                      },
                      child: const Text("حفظ",
                          style: TextStyle(
                              color: Colors.white)),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// زر إلغاء
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("إلغاء"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// Dialog تأكيد الحذف
  void _confirmDelete(
      TransactionController controller, int id) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد من حذف المعاملة؟",
      textConfirm: "نعم",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // إغلاق Dialog
        Get.back(); // إغلاق BottomSheet
        controller.deleteTransaction(id);
      },
    );
  }

  /// Stepper
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
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF0D47A1)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted &&
                        currentId > step['id']
                        ? const Icon(Icons.check,
                        color: Colors.white, size: 16)
                        : Text("${step['id']}",
                        style: TextStyle(
                            color: isCompleted
                                ? Colors.white
                                : Colors.grey[600],
                            fontSize: 12)),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted
                        ? const Color(0xFF0D47A1)
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 4),
                child: Text(
                  step['label'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isCompleted
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isCompleted
                        ? Colors.black87
                        : Colors.grey[500],
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getStatusExplanation(int id) {
    switch (id) {
      case 1:
        return "تم استلام طلبك، وهو بانتظار المراجعة.";
      case 2:
        return "يرجى مراجعة القسم المختص لتثبيت البيانات.";
      case 3:
        return "يرجى التوجه لقسم المحاسبة لدفع الرسوم.";
      case 4:
        return "المعاملة قيد المعالجة النهائية الآن.";
      case 5:
        return "جاهزة! يمكنك استلام معاملتك الآن.";
      default:
        return "المعاملة قيد التدقيق حالياً...";
    }
  }

  Widget _buildNotesContainer(dynamic t) {
    int id = t['transaction_status_id'] ?? 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border:
        Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        t['notes'] ?? _getStatusExplanation(id),
        style: const TextStyle(
            fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _detailRow(
      IconData icon, String label, String? value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(icon,
            size: 18,
            color: const Color(0xFF0D47A1)),
        const SizedBox(width: 10),
        Text("$label: ",
            style: const TextStyle(
                fontWeight: FontWeight.w500)),
        Text(value ?? "---"),
      ]),
    );
  }

  Widget _buildBadge(int? id, String? name) {
    Color c = id == 5
        ? Colors.green
        : (id == 4
        ? Colors.blue
        : Colors.orange);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: c.withOpacity(0.1),
          borderRadius:
          BorderRadius.circular(8)),
      child: Text(
        name ?? "قيد الدراسة",
        style: TextStyle(
            color: c,
            fontSize: 10,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
