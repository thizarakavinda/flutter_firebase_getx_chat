import 'package:flutter_firebase_getx_chat/controllers/auth_controller.dart';
import 'package:flutter_firebase_getx_chat/models/friend_request_model.dart';
import 'package:flutter_firebase_getx_chat/services/firestore_service.dart';
import 'package:get/get.dart';

class FriendRequestsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();
  final RxList<FriendRequestModel> _receivedRequests = <FriendRequestModel>[].obs;
  final RxList<FriendRequestModel> _sentRequests = <FriendRequestModel>[].obs;
}
