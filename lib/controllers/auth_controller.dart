import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_getx_chat/routes/app_routes.dart';
import 'package:flutter_firebase_getx_chat/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

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
    // ever(_user, _handleAuthStateChanged);
  }

  // void _handleAuthStateChanged(User? user) async {
  //   if (user == null) {
  //     if (Get.currentRoute != AppRoutes.login) {
  //       Get.offAllNamed(AppRoutes.login);
  //     }
  //   } else {
  //     if (Get.currentRoute != AppRoutes.profile) {
  //       Get.offAllNamed(AppRoutes.profile);
  //     }
  //   }
  //   if (!_isInitialized.value) {
  //     _isInitialized.value = true;
  //   }
  // }

  // void checkInitialAuthState() {
  //   final currentUser = _authService.currentUser;
  //   if (currentUser != null) {
  //     _user.value = currentUser;
  //     Get.offAllNamed(AppRoutes.main);
  //   } else {
  //     Get.offAllNamed(AppRoutes.login);
  //   }
  //   _isInitialized.value = true;
  // }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading.value = true;
      _error.value = "";

      UserModel? userModel = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.profile);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Login');
      Logger().e(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _isLoading.value = true;
      _error.value = "";

      UserModel? userModel = await _authService.registerWithEmailAndPassword(
        email,
        password,
        displayName,
      );
      if (userModel != null) {
        _userModel.value = userModel;
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Create Account');
      Logger().e(e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authService.signOut();
      _userModel.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Sign Out');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading.value = true;
      await _authService.deleteAccount();
      _userModel.value = null;
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar('Error', 'Failed to Delete Account');
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _error.value = "";
  }
}
