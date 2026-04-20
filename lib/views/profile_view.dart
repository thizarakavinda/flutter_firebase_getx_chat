import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/profile_controller.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/get.dart';

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

      body: Obx(() {
        final user = controller.currentUser;
        if (user == null) {
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
                              border: Border.all(color: Colors.white, width: 2),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    style: Theme.of(Get.context!).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
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
