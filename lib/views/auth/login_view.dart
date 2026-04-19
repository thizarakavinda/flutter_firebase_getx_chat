import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/routes/app_routes.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();
  bool _obsecurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 40),

                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

                SizedBox(height: 32),

                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: 8),

                Text(
                  'Sign in to continue chatting with friends & family',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),

                SizedBox(height: 40),

                TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _emailController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),

                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textSecondaryColor,
                      size: 23,
                    ),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value!)) {
                      return 'Plase enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 22),

                TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _passwordController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obsecurePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppTheme.textSecondaryColor,
                      size: 23,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 23,
                        color: AppTheme.textSecondaryColor,
                        _obsecurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      },
                    ),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    if (value!.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: Text('Forgot password?'),
                  ),
                ),

                SizedBox(height: 24),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      onPressed: _authController.isLoading
                          ? null
                          : () {
                              if (_formkey.currentState?.validate() ?? false) {
                                _authController.signInWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              }
                            },
                      child: _authController.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text('Sign In'),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(child: Divider(color: AppTheme.borderColor)),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: AppTheme.borderColor)),
                  ],
                ),

                SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
