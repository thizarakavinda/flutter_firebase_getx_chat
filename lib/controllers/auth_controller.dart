import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_getx_chat/services/auth_service.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<User?> _user = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = "".obs;
  final RxBool _isInitialized = false.obs;
  User? get user => _user.value;
  UserModel? get userModel => _userModel.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isAuthenticated => user != null;
  bool get isInitialized => _isInitialized.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_authService.authStateChange);
    ever(_user, _handleAuthStateChanged);
  }

  void _handleAuthStateChanged(User? user) async {
    
  }
}
