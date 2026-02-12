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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 25, right: 25, top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 25,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("تقديم معاملة جديدة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: InputDecoration(
                labelText: "نوع المعاملة",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: ["بيان عائلي", "تجديد هوية", "بيان ولادة", "جواز سفر"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedType = val!),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "تفاصيل أو سبب الطلب",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: widget.controller.isLoading.value
                    ? null
                    : () => widget.controller.addTransaction(selectedType, reasonController.text),
                child: widget.controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إرسال الطلب الآن", style: TextStyle(color: Colors.white)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}