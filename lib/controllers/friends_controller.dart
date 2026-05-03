import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/friendship_model.dart';
import 'package:flutter_firebase_getx_chat/models/user_model.dart';
import 'package:flutter_firebase_getx_chat/services/firestore_service.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();

  final RxList<FriendshipModel> _friendships = <FriendshipModel>[].obs;
  final RxList<UserModel> _friends = <UserModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxList<UserModel> _filteredFriends = <UserModel>[].obs;

  StreamSubscription? _friendshipsSubscriptions;

  List<FriendshipModel> get friendships => _friendships.toList();
  List<UserModel> get friends => _friends;
  List<UserModel> get filteredFriends => _filteredFriends;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    _loadFriends();

    debounce(
      _searchQuery,
      (_) => _filteredFriends(),
      time: Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _friendshipsSubscriptions?.cancel();
    super.onClose();
  }

  void _loadFriends() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _friendshipsSubscriptions?.cancel();

      _friendshipsSubscriptions = _firestoreService
          .getFriendsStream(currentUserId)
          .listen((friendshipList) {
            _friendships.value = friendshipList;
            _loadFriendDetails(currentUserId, friendshipList);
          });
    }
  }

  Future<void> _loadFriendDetails(
    String currentUserId,
    List<FriendshipModel> friendshipList,
  ) async {
    try {
      _isLoading.value = true;

      List<UserModel> friendUsers = [];

      final futures = friendshipList.map((friendship) async {
        String friendId = friendship.getOtherUserId(currentUserId);
        return await _firestoreService.getUserById(friendId);
      }).toList();

      final results = await Future.wait(futures);

      for (var friend in results) {
        if (friend != null) {
          friendUsers.add(friend);
        }
      }

      _friends.value = friendUsers;
      _filterFriends();
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void _filterFriends() {
    final query = _searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      _filteredFriends.value = _friends;
    } else {
      _filteredFriends.value = _friends.where((friend) {
        return friend.displayName.toLowerCase().contains(query) ||
            friend.email.toLowerCase().contains(query);
      }).toList();
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void clearSearch() {
    _searchQuery.value = '';
  }

  Future<void> refreshFriends() async {
    final currentUserId = _authController.user?.uid;
    if (currentUserId != null) {
      _loadFriends();
    }
  }
}
