import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // استدعاء المتحكم الخاص بالـ Auth
  final AuthController controller = Get.find<AuthController>();

  // متحكمات النصوص
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  // حالة رؤية كلمة المرور
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Stack(
        children: [
          // 1. الخلفية العلوية (Gradient Header)
          _buildHeader(size),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.07),

                  // شعار النظام
                  _buildLogo(),

                  const SizedBox(height: 20),
                  const Text(
                    "نظام إدارة المعاملات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // بطاقة تسجيل الدخول
                  _buildLoginCard(),

                  const SizedBox(height: 40),

                  // رابط إنشاء حساب
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ودجت الخلفية الملونة
  Widget _buildHeader(Size size) {
    return Container(
      height: size.height * 0.45,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
    );
  }

  // ودجت الشعار
  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: const Icon(
        Icons.account_balance_rounded,
        size: 65,
        color: Colors.white,
      ),
    );
  }

  // بطاقة الحقول والأزرار
  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "مرحباً بك مجدداً 👋",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
          ),
          const SizedBox(height: 8),
          Text(
            "قم بتسجيل الدخول لمتابعة معاملاتك",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
          const SizedBox(height: 35),

          // حقل البريد
          _buildTextField(
            controller: emailCtrl,
            label: "البريد الإلكتروني",
            icon: Icons.alternate_email_rounded,
            type: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

          // حقل كلمة المرور
          _buildTextField(
            controller: passCtrl,
            label: "كلمة المرور",
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                color: const Color(0xFF1976D2),
                size: 22,
              ),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {},
              child: const Text("نسيت كلمة المرور؟", style: TextStyle(color: Color(0xFF1976D2))),
            ),
          ),

          const SizedBox(height: 25),

          // زر الدخول مع حالة التحميل
          Obx(() {
            return controller.loading.value
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 6,
                  shadowColor: Colors.blue.withOpacity(0.4),
                ),
                onPressed: () {
                  controller.login(emailCtrl.text.trim(), passCtrl.text.trim());
                },
                child: const Text(
                  "دخول للنظام",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // تصميم حقل الإدخال الموحد
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType type = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      keyboardType: type,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF1976D2), size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF0F4F8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF1976D2), width: 1.5),
        ),
      ),
    );
  }

  // الجزء السفلي لإنشاء حساب
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("لا تمتلك حساباً بعد؟", style: TextStyle(color: Colors.grey[700])),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          child: const Text(
            "أنشئ حساباً جديداً",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1), fontSize: 15),
          ),
        ),
      ],
    );
  }
}