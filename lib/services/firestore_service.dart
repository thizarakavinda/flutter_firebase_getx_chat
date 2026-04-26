import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_getx_chat/models/friend_request_model.dart';
import 'package:flutter_firebase_getx_chat/models/notification_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to Create User: ${e.toString()}');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to Get User: ${e.toString()}');
    }
  }

  Future<void> updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        await _firestore.collection('users').doc(userId).update({
          'isOnline': isOnline,
          'lastSeen': Timestamp.fromDate(DateTime.now()), // ✅ was saving int
        });
      }
    } catch (e) {
      throw Exception('Failed to Update Online Status: ${e.toString()}');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to Delete User: ${e.toString()}');
    }
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to Update User: ${e.toString()}');
    }
  }

  Stream<List<UserModel>> getAllUserStream() {
    return _firestore
        .collection('users')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> sendFriendRequest(FriendRequestModel request) async {
    try {
      await _firestore
          .collection('friendRequests')
          .doc(request.id)
          .set(request.toMap());
    } catch (e) {
      throw Exception('Failed to Send Friend Request: ${e.toString()}');
    }

    String notificationId = 'friend_request_${request.senderId}_${request.receiverId}_${DateTime.now().millisecondsSinceEpoch}';

    await createNotification(NotificationModel(
      id: notificationId,
      userId: request.receiverId,
      title: 'New Friend Request',
      body: 'You have recieved a new friend request',
      type: NotificationType.friendRequest,
      data: {
        'senderId': request.senderId,
        'receiverId': request.id,
      },
      createdAt: DateTime.now(),
    ));
  }
}
