import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/friend_request_model.dart';
import 'package:flutter_firebase_getx_chat/models/user_model.dart';
import 'package:flutter_firebase_getx_chat/services/firestore_service.dart';
import 'package:get/get.dart';

class FriendRequestsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();
  final RxList<FriendRequestModel> _receivedRequests =
      <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> _sentRequests = <FriendRequestModel>[].obs;
  final RxMap<String, UserModel> _users = <String, UserModel>{}.obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxInt _selectedTabIndex = 0.obs;

  List<FriendRequestModel> get receivedRequests => _receivedRequests;
  List<FriendRequestModel> get sentRequests => _sentRequests;
  Map<String, UserModel> get users => _users;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  int get selectedTabIndex => _selectedTabIndex.value;

  @override
  void onInit() {
    super.onInit();
    _loadFriendRequests();
    _loadUsers();
  }

  void _loadFriendRequests() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _receivedRequests.bindStream(
        _firestoreService.getFriendRequestsStream(currentUserId),
      );

      _sentRequests.bindStream(
        _firestoreService.getFriendRequestsStream(currentUserId),
      );
    }
  }

  void _loadUsers() {
    _users.bindStream(
      _firestoreService.getAllUserStream().map((userList) {
        Map<String, UserModel> userMap = {};
        for (var user in userList) {
          userMap[user.id] = user;
        }
        return userMap;
      }),
    );
  }
}
