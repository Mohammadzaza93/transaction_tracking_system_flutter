import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/features/transactions/controllers/transaction_controller.dart';

class AddTransactionSheet extends StatefulWidget {
  final TransactionController controller;

  const AddTransactionSheet({super.key, required this.controller});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  String selectedType = "بيان عائلي";
  final reasonController = TextEditingController();

  // المتغير الذي سيخزن عدد النسخ
  int copiesCount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end, // للتوافق مع اللغة العربية
          children: [
            const Center(
              child: Text("تقديم معاملة جديدة",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              items: ["بيان عائلي", "تجديد هوية", "بيان ولادة", "جواز سفر", "بيان وفاة", "بيان قيد فردي"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedType = val!),
            ),
            const SizedBox(height: 20),

            // --- قسم اختيار عدد النسخ (الذي كان ناقصاً في كودك) ---
            const Text("عدد النسخ المطلوبة:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر الزيادة
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF0D47A1)),
                    onPressed: () => setState(() => copiesCount++),
                  ),

                  // عرض الرقم الحالي
                  Row(
                    children: [
                      const Text("نسخ", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 8),
                      Text(
                        "$copiesCount",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  // زر النقصان
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                    onPressed: () {
                      if (copiesCount > 1) setState(() => copiesCount--);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // حقل تفاصيل الطلب
            TextField(
              controller: reasonController,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: "تفاصيل أو سبب الطلب",
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),

            // زر الإرسال
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: widget.controller.isLoading.value
                    ? null
                    : () => widget.controller.addTransaction(
                    selectedType,
                    reasonController.text,
                    copiesCount // نمرر القيمة هنا للـ Controller
                ),
                child: widget.controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إرسال الطلب الآن",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}