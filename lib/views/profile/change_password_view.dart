import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/change_password_controller.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/get.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChangePasswordController>();
    return Scaffold(
      appBar: AppBar(title: Text('Change Password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                Center(
                  child: Container(
                    width: 100,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security_rounded,
                      size: 40,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 26),

                Text(
                  'Update Your Password',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 6),

                Text(
                  'Enter your new password below to update your account security.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: 40),

                Obx(
                  () => TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    style: TextStyle(fontSize: 14),
                    controller: controller.currentPasswordController,
                    obscureText: controller.obscureCurrentPassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      labelText: 'Current Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 23,
                        color: AppTheme.textSecondaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: AppTheme.textSecondaryColor,
                          size: 23,
                          controller.obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.toggleCurrentPasswordVisibility,
                      ),
                      hintText: 'Enter your current password',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    validator: controller.validateCurrentPassword,
                  ),
                ),

                SizedBox(height: 20),

                Obx(
                  () => TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    style: TextStyle(fontSize: 14),
                    controller: controller.newPasswordController,
                    obscureText: controller.obscureNewPassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      labelText: 'New Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 23,
                        color: AppTheme.textSecondaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: AppTheme.textSecondaryColor,
                          size: 23,
                          controller.obscureNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.toggleNewPasswordVisibility,
                      ),
                      hintText: 'Enter your new password',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    validator: controller.validateNewPassword,
                  ),
                ),

                SizedBox(height: 20),

                Obx(
                  () => TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    style: TextStyle(fontSize: 14),
                    controller: controller.confirmPasswordController,
                    obscureText: controller.obscureConfirmPassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        size: 23,
                        color: AppTheme.textSecondaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: AppTheme.textSecondaryColor,
                          size: 23,
                          controller.obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                      hintText: 'Enter your confirm password',
                      hintStyle: TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    validator: controller.validateConfirmPassword,
                  ),
                ),

                SizedBox(height: 40),

                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      icon: controller.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.security),
                      onPressed: controller.isLoading
                          ? null
                          : controller.changePassword,
                      label: Text(
                        controller.isLoading ? 'Updating' : 'Update Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
