import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController controller = Get.find<AuthController>();

  // متحكمات النصوص
  final nameCtrl = TextEditingController();
  final nationalCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final selectedRoleId = 1.obs; // 1 = مواطن
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // خلفية انسيابية علوية أصغر قليلاً من صفحة الدخول
          _buildHeader(size),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // زر العودة
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ),

                  const Text(
                    "انضم إلينا 📝",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // بطاقة التسجيل الرئيسية
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: nameCtrl,
                          label: "الاسم الكامل",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: nationalCtrl,
                          label: "الرقم الوطني",
                          icon: Icons.badge_outlined,
                          type: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: emailCtrl,
                          label: "البريد الإلكتروني",
                          icon: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: passCtrl,
                          label: "كلمة المرور",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: confirmCtrl,
                          label: "تأكيد كلمة المرور",
                          icon: Icons.lock_reset,
                          isPassword: true,
                        ),

                        const SizedBox(height: 24),

                        // اختيار نوع الحساب بتصميم عصري
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text("نوع الحساب",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                        ),
                        const SizedBox(height: 12),
                        _buildRoleSelector(),

                        const SizedBox(height: 32),

                        // زر إنشاء الحساب
                        Obx(() {
                          return controller.loading.value
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                              ),
                              onPressed: () {
                                controller.register(
                                  fullName: nameCtrl.text.trim(),
                                  nationalId: nationalCtrl.text.trim(),
                                  email: emailCtrl.text.trim(),
                                  password: passCtrl.text.trim(),
                                  passwordConfirm: confirmCtrl.text.trim(),
                                  roleId: selectedRoleId.value,
                                );
                              },
                              child: const Text("إنشاء الحساب",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      height: size.height * 0.3,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2), size: 22),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, size: 20),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        )
            : null,
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 1.5),
        ),
      ),
    );
  }

  // اختيار الدور بتصميم Buttons بدلاً من Radio التقليدي
  Widget _buildRoleSelector() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _roleButton("مواطن", 1, Icons.person_outline),
        _roleButton("موظف", 2, Icons.badge_outlined),
        _roleButton("مشرف", 3, Icons.admin_panel_settings_outlined),
      ],
    ));
  }

  Widget _roleButton(String label, int value, IconData icon) {
    bool isSelected = selectedRoleId.value == value;
    return GestureDetector(
      onTap: () => selectedRoleId.value = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF0D47A1) : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("لديك حساب بالفعل؟"),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("تسجيل الدخول", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
        ),
      ],
    );
  }
}