import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/controllers/main_controller.dart';
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
    );
  }
}
