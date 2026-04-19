import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/get.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formkey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                SizedBox(height: 32),

                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: 8),

                Text(
                  'Sign Up with your details to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),

                SizedBox(height: 40),

                TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _displayNameController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),

                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.person_2_outlined,
                      color: AppTheme.textSecondaryColor,
                      size: 23,
                    ),
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 22),

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

                SizedBox(height: 22),

                TextFormField(
                  style: TextStyle(fontSize: 14),
                  controller: _confirmPasswordController,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obsecureConfirmPassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    labelText: 'Confirm Password',
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
                        _obsecureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obsecureConfirmPassword = !_obsecureConfirmPassword;
                        });
                      },
                    ),
                    hintText: 'Confirm your password',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
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
                                _authController.registerWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                  _displayNameController.text.trim(),
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
                          : Text('Create Account'),
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
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Sign In',
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
