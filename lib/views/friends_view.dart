import 'package:flutter/material.dart';
import 'package:flutter_firebase_getx_chat/theme/app_theme.dart';
import 'package:get/state_manager.dart';

import '../controllers/friends_controller.dart';

class FriendsView extends GetView<FriendsController> {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        leading: SizedBox(),
        actions: [
          IconButton(
            onPressed: controller.openFriendRequest,
            icon: Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.borderColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
