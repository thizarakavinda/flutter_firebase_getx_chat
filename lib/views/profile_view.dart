import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/profile_controller.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: controller.isEditing
                  ? controller.toggleEditing
                  : controller.toggleEditing,
              child: Text(
                controller.isEditing ? 'Cancel' : 'Edit',
                style: TextStyle(
                  color: controller.isEditing
                      ? AppTheme.errorColor
                      : AppTheme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Obx(() {
          final user = controller.currentUser;
          if (user == null) {
            Logger().e('User data is null');
            return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: AppTheme.primaryColor,
                          child: (user.photoUrl?.isNotEmpty ?? false)
                              ? ClipOval(
                                  child: Image.network(
                                    user.photoUrl!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultAvatar(user);
                                    },
                                  ),
                                )
                              : _buildDefaultAvatar(user),
                        ),

                        if (controller.isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: context.width * 0.1,
                              height: context.width * 0.1,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Get.snackbar('Info', 'Under Development');
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 16),

                    Text(
                      user.displayName,
                      style: Theme.of(Get.context!).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 4),

                    Text(
                      user.email,
                      style: Theme.of(Get.context!).textTheme.bodyMedium
                          ?.copyWith(color: AppTheme.textSecondaryColor),
                    ),

                    SizedBox(height: 8),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.isOnline
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.textSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: user.isOnline
                                  ? AppTheme.successColor
                                  : AppTheme.textSecondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),

                          SizedBox(width: 6),

                          Text(
                            user.isOnline ? 'Online' : 'Offline',
                            style: Theme.of(Get.context!).textTheme.bodySmall
                                ?.copyWith(
                                  color: user.isOnline
                                      ? AppTheme.successColor
                                      : AppTheme.textSecondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.getJoinedData(),
                      style: Theme.of(Get.context!).textTheme.bodySmall
                          ?.copyWith(color: AppTheme.textSecondaryColor),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                Obx(
                  () => Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: Theme.of(Get.context!)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),

                          SizedBox(height: 20),

                          TextField(
                            style: TextStyle(fontSize: 14),
                            enabled: controller.isEditing,
                            controller: controller.displayNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              labelText: 'Name',
                              prefixIcon: Icon(
                                Icons.person_2_outlined,
                                size: 23,
                              ),
                              labelStyle: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          TextField(
                            style: TextStyle(fontSize: 14),
                            enabled: false,
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined, size: 23),
                              labelStyle: TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                              helperText: 'Email cannot be changed',
                            ),
                          ),

                          if (controller.isEditing) ...[
                            SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: controller.isLoading
                                    ? null
                                    : controller.updateProfile,
                                child: controller.isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text('Save Changes'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32),

                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.security,
                          color: AppTheme.primaryColor,
                        ),
                        title: Text('Change Password'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Get.toNamed('/change-password'),
                      ),

                      Divider(height: 1, color: Colors.grey),

                      ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: AppTheme.errorColor,
                        ),
                        title: Text('Delete Account'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => controller.deleteAccount,
                      ),

                      Divider(height: 1, color: Colors.grey),

                      ListTile(
                        leading: Icon(
                          Icons.logout_outlined,
                          color: AppTheme.errorColor,
                        ),
                        title: Text('Sign Out'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => controller.signOut,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Text(
                  'FluxChat v1.0.0',
                  style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDefaultAvatar(dynamic user) {
    return Text(
      user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
      style: TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
