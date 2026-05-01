import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/friend_request_model.dart';
import 'package:flutter_firebase_getx_chat/models/friendship_model.dart';
import 'package:flutter_firebase_getx_chat/models/user_model.dart';
import 'package:flutter_firebase_getx_chat/services/firestore_service.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:uuid/uuid.dart';

enum UserRelationshipStatus {
  none,
  friendRequestSent,
  friendRequestReceived,
  friends,
  blocked,
}

class UsersListController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();
  final Uuid _uuid = Uuid();

  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<UserModel> _filteredUsers = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _error = ''.obs;

  final RxMap<String, UserRelationshipStatus> _userRelationships =
      <String, UserRelationshipStatus>{}.obs;
  final RxList<FriendRequestModel> _sentRequests = <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> _receivedRequests =
      <FriendRequestModel>[].obs;

  final RxList<FriendshipModel> _friendships = <FriendshipModel>[].obs;

  List<UserModel> get users => _users;
  List<UserModel> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  String get error => _error.value;
  Map<String, UserRelationshipStatus> get userRelationships =>
      _userRelationships;

  @override
  void onInit() {
    super.onInit();
    _loadUsers();
    _loadRelationships();

    debounce(
      _sentRequests,
      (_) => _filterUsers(),
      time: Duration(milliseconds: 300),
    );
  }

  void _loadUsers() async {
    _users.bindStream(_firestoreService.getAllUserStream());

    ever(_users, (List<UserModel> userList) {
      final currentUserId = _authController.user?.uid;
      final otherUsers = userList
          .where((user) => user.id != currentUserId)
          .toList();

      if (_searchQuery.isEmpty) {
        _filteredUsers.value = otherUsers;
      } else {
        _filterUsers();
      }
    });
  }

  void _loadRelationships() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      // Load sent friend requests
      _sentRequests.bindStream(
        _firestoreService.getSentFriendRequestsStream(currentUserId),
      );

      // Load received friend requests
      _receivedRequests.bindStream(
        _firestoreService.getFriendRequestsStream(currentUserId),
      );

      // Load friendships/ friends list
      _friendships.bindStream(
        _firestoreService.getFriendsStream(currentUserId),
      );

      // Update relationship status whenever any of the streams change
      ever(_sentRequests, (_) => _updateAllRelationshipsStatus());
      ever(_receivedRequests, (_) => _updateAllRelationshipsStatus());
      ever(_friendships, (_) => _updateAllRelationshipsStatus());

      ever(_users, (_) => _updateAllRelationshipsStatus());
    }
  }

  void _updateAllRelationshipsStatus() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId == null) return;

    for (var user in _users) {
      if (user.id != currentUserId) {
        final status = _calculateUserRelationshipStatus(user.id);
        _userRelationships[user.id] = status;
      }
    }
  }

  UserRelationshipStatus _calculateUserRelationshipStatus(String userId) {
    final currentUserId = _authController.user?.uid;

    if (currentUserId == null) return UserRelationshipStatus.none;

    final friendship = _friendships.firstWhereOrNull(
      (f) =>
          (f.user1Id == currentUserId && f.user2Id == userId) ||
          (f.user1Id == userId && f.user2Id == currentUserId),
    );

    if (friendship != null) {
      if (friendship.isBlocked) {
        return UserRelationshipStatus.blocked;
      } else {
        return UserRelationshipStatus.friends;
      }
    }

    // Check if there's a pending friend request sent to this user
    final sentRequest = _sentRequests.firstWhereOrNull(
      (r) => r.receiverId == userId && r.status == FriendRequestStatus.pending,
    );

    if (sentRequest != null) {
      return UserRelationshipStatus.friendRequestSent;
    }

    // Check if there's a pending friend request received from this user
    final receivedRequest = _receivedRequests.firstWhereOrNull(
      (r) => r.senderId == userId && r.status == FriendRequestStatus.pending,
    );

    if (receivedRequest != null) {
      return UserRelationshipStatus.friendRequestReceived;
    }
    return UserRelationshipStatus.none;
  }

  void _filterUsers() {
    final query = _searchQuery.value.toLowerCase();
    final currentUserId = _authController.user?.uid;

    if (query.isEmpty) {
      _filteredUsers.value = _users
          .where((user) => user.id != currentUserId)
          .toList();
    } else {
      _filteredUsers.value = _users.where((user) {
        return user.id != currentUserId &&
            (user.displayName.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query));
      }).toList();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearSearchQuery() {
    _searchQuery.value = '';
  }

  Future<void> sendFriendRequest(UserModel user) async {
    try {
      Get.snackbar(
        'Sending Request',
        'Friend Request Sent to ${user.displayName}',
      );
    } catch (e) {
      _userRelationships[user.id] = UserRelationshipStatus.none;
      _error.value = e.toString();
      Logger().e('Error sending friend request: $e');
      Get.snackbar('Error', 'Failed to send friend request');
    } finally {
      _isLoading.value = false;
    }
  }
}
