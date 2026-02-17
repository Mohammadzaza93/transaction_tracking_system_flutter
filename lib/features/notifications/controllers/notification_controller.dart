import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transactiontrackingsystemflutter/core/network/api_service.dart';
import '../models/notification_model.dart'; // الموديل الذي أنشأناه سابقاً

class NotificationController extends GetxController {
  var notifications = <CustomNotification>[].obs;
  var isLoading = true.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  // جلب الإشعارات باستخدام Dio
  Future<void> fetchNotifications() async {
    try {
      isLoading(true);

      // نستخدم ApiService.dio مباشرة هنا
      final response = await ApiService.dio.get("/my-notifications");

      if (response.statusCode == 200) {
        // مع Dio، البيانات تكون محولة تلقائياً لـ Map أو List
        List data = response.data;
        notifications.value = data.map((json) => CustomNotification.fromJson(json)).toList();

        // تحديث عدد الإشعارات غير المقروءة
        _updateUnreadCount();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  // تحديث حالة الإشعار لمقروء
  Future<void> markAsRead(int notificationId) async {
    try {
      // إرسال طلب POST إلى المسار الذي أنشأناه في Laravel
      final response = await ApiService.dio.post("/mark-read/$notificationId");

      if (response.statusCode == 200) {
        // تحديث الحالة محلياً في القائمة دون الحاجة لإعادة الجلب من السيرفر (أداء أسرع)
        int index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          // نغير حالة الإشعار يدوياً في القائمة الـ Observable
          var updatedNotify = notifications[index];
          notifications[index] = CustomNotification(
            id: updatedNotify.id,
            transactionId: updatedNotify.transactionId,
            message: updatedNotify.message,
            isRead: true, // القيمة الجديدة
            createdAt: updatedNotify.createdAt,
          );

          // تحديث عداد الإشعارات غير المقروءة
          _updateUnreadCount();
        }
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحديث حالة الإشعار");
      print("Error: $e");
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      // إرسال طلب الحذف للسيرفر باستخدام ApiService (Dio)
      final response = await ApiService.dio.delete("/notifications/$id");

      if (response.statusCode == 200) {
        // إزالة الإشعار من القائمة المحلية فوراً لتحديث الواجهة
        notifications.removeWhere((notification) => notification.id == id);

        // تحديث عداد الإشعارات غير المقروءة
        _updateUnreadCount();

        Get.snackbar(
          "نجاح",
          "تم حذف الإشعار بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Error deleting notification: $e");
      Get.snackbar("خطأ", "حدث مشكلة أثناء الحذف");
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }


}