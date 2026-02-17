import 'package:flutter/material.dart';
import 'package:transactiontrackingsystemflutter/features/notifications/controllers/notification_controller.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        // زر العودة للخلف
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), // استخدمت ios لشكل أجمل
          onPressed: () => Get.back(), // العودة للصفحة السابقة
        ),
        title: Text("التنبيهات", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white, // يفضل تغيير الخلفية لتتناسب مع التصميم الحديث
      ),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CircularProgressIndicator());
        if (controller.notifications.isEmpty) return _buildEmptyState();

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notify = controller.notifications[index];
            return Dismissible(
              key: Key(notify.id.toString()),
              direction: DismissDirection.startToEnd,
              onDismissed: (_) => controller.deleteNotification(notify.id),
              background: _buildDeleteBackground(),
              child: Card(
                elevation: 0.5,
                color: notify.isRead ? Colors.white : Colors.blue.shade50,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: notify.isRead ? Colors.grey.shade100 : Colors.blue.shade100,
                    child: Icon(Icons.notifications_active,
                        color: notify.isRead ? Colors.grey : Colors.blue),
                  ),
                  title: Text(
                    notify.message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notify.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      notify.createdAt.toString().substring(0, 16),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  trailing: !notify.isRead ? Icon(Icons.circle, size: 12, color: Colors.blue) : null,
                  onTap: () => controller.markAsRead(notify.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      child: Icon(Icons.delete_sweep, color: Colors.white, size: 30),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text("لا توجد تنبيهات حالياً", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}