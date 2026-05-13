import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/chat_model.dart';
import 'package:flutter_firebase_getx_chat/models/user_model.dart';
import 'package:flutter_firebase_getx_chat/services/firestore_service.dart';
import 'package:get/get.dart';

import '../models/notification_model.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
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

  List<ChatModel> get chats => _getFilteredChats();
  List<ChatModel> get allChats => _allChats;
  List<ChatModel> get filteredChats => _filteredChats;
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;
  bool get isSearching => _isSearching.value;
  String get activeFilter => _activeFilter.value;
  Map<String, UserModel> get users => _users;

  @override
  void onInit() {
    super.onInit();

    _loadChats();
    _loadUsers();
    _loadNotifications();
  }

  void _loadChats() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _allChats.bindStream(_firestoreService.getUserChatsStream(currentUserId));

      ever(_allChats, (_) {
        if (_isSearching.value && _searchQuery.value.isNotEmpty) {
          _performSearch(_searchQuery.value);
        }
      });

      ever(_activeFilter, (_) {
        if (_searchQuery.value.isNotEmpty) {
          _performSearch(_searchQuery.value);
        }
      });
    }
  }
}
