import 'package:flutter_firebase_getx_chat/routes/app_routes.dart';
import 'package:get/get.dart';

import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/splash_view.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView()),
    GetPage(name: AppRoutes.register, page: () => const RegisterView()),
    GetPage(name: AppRoutes.login, page: () => const LoginView()),

    // GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordView()),
    // GetPage(name: AppRoutes.changePassword, page: () => const ChangePasswordView()),

    // GetPage(name: AppRoutes.home, page: () => const HomeView(), bindings: BindingsBuilder((){
    // Get.put(HomeController());})),

    // GetPage(name: AppRoutes.main, page: () => const MainView(), bindings: BindingsBuilder((){
    // Get.put(MainController());})),

    // GetPage(name: AppRoutes.profile, page: () => const ProfileView(), bindings: BindingsBuilder((){
    // Get.put(ProfileController());})),

    // GetPage(name: AppRoutes.chat, page: () => const ChatView(), bindings: BindingsBuilder((){
    // Get.put(ChatController());})),

    // GetPage(name: AppRoutes.usersList, page: () => const UsersListView(), bindings: BindingsBuilder((){
    // Get.put(UsersListController());})),

    // GetPage(name: AppRoutes.friends, page: () => const FriendsView(), bindings: BindingsBuilder((){
    // Get.put(FriendsController());})),

    // GetPage(name: AppRoutes.friendRequests, page: () => const FriendRequestsView(), bindings: BindingsBuilder((){
    // Get.put(FriendRequestsController());})),

    // GetPage(name: AppRoutes.notifications, page: () => const NotificationsView(), bindings: BindingsBuilder((){
    // Get.put(NotificationsController());})),
  ];
}
