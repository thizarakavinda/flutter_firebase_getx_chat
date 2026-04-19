import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/forgot_password_controller.dart';
import '../../theme/app_theme.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                    ),

                    SizedBox(width: 8),

                    Text(
                      'Forgot Password',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Enter your email address to receive a password reset link.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ),

                SizedBox(height: 50),

                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 50,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 40),

                Obx(() {
                  if (controller.emailSent) {
                    return _builtEmailSentContent(controller);
                  } else {
                    return _buildEmailField(controller);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildEmailField(ForgotPasswordController controller) {
  return Column(
    children: [
      TextFormField(
        style: TextStyle(fontSize: 14),
        onTapOutside: (event) => FocusScope.of(Get.context!).unfocus(),
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 14),
          labelStyle: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 14,
          ),
          labelText: 'Email Address',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppTheme.textSecondaryColor,
            size: 23,
          ),
        ),
        validator: controller.validateEmail,
      ),

      SizedBox(height: 32),

      Obx(
        () => SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            onPressed: controller.isLoading
                ? null
                : controller.sendPasswordResetEmail,
            icon: controller.isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.send),
            label: Text(
              controller.isLoading ? 'Sending...' : 'Send Reset Link',
            ),
          ),
        ),
      ),

      SizedBox(height: 32),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Remember your password?'),
          TextButton(
            onPressed: controller.goBackToLogin,
            child: Text(
              'Sign In',
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _builtEmailSentContent(ForgotPasswordController controller) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
        ),

        child: Column(
          children: [
            Icon(
              Icons.mark_email_read_rounded,
              size: 60,
              color: AppTheme.successColor,
            ),

            SizedBox(height: 16),

            Text(
              'Email Sent!',
              style: Theme.of(Get.context!).textTheme.headlineSmall?.copyWith(
                color: AppTheme.successColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            Text(
              "We've sent a password reset link to:",
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4),

            Text(
              controller.emailController.text,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 12),

            Text(
              'Please check your inbox and follow the instructions to reset your password.',
              style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      SizedBox(height: 32),

      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: controller.reSendEmail,
          label: Text('Resend Email'),
          icon: Icon(Icons.refresh),
        ),
      ),

      SizedBox(height: 16),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: controller.goBackToLogin,
          label: Text('Back to Sign In'),
          icon: Icon(Icons.arrow_back),
        ),
      ),

      SizedBox(height: 24),

      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: AppTheme.secondaryColor),

            SizedBox(width: 12),

            Expanded(
              child: Text(
                'Didn\'t receive the email? Check your spam folder or try again',
                style: Theme.of(
                  Get.context!,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.secondaryColor),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
