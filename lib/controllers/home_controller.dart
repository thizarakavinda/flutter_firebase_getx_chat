import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/chat_model.dart';
import 'package:flutter_firebase_getx_chat/models/user_model.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';

class HomeController extends GetxController {

  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();

  final RxList<ChatModel> _allChats = <ChatModel>[].obs;
  final RxList<ChatModel> _filteredChats = <ChatModel>[].obs;
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxMap<String, UserModel> _users = <String, UserModel>{}.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isSearching = false.obs;
  final RxString _activeFilter = 'All'.obs;
 
}