import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/main_controller.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:flutter_firebase_getx_chat/views/profile/profile_view.dart';
import 'package:get/get.dart';

class MainView extends GetView<MainController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          Container(color: Colors.red), // HomeView(),
          Container(color: Colors.green), // FriendsView(),
          Container(color: Colors.blue), // UsersListView(),
          ProfileView(), // ProfileView(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondaryColor,
          backgroundColor: Colors.white,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: _buildIconWithBadge(
                Icons.chat_outlined,
                controller.getUnreadCount(),
              ),
              activeIcon: _buildIconWithBadge(
                Icons.chat,
                controller.getUnreadCount(),
              ),
              label: 'Chats',
            ),
          ],
        ),
      ),
    );
  }
}
