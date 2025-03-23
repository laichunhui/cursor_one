import 'package:get/get.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/welcome/welcome_binding.dart';
import '../modules/welcome/welcome_view.dart';
import '../modules/photo_detail/photo_detail_binding.dart';
import '../modules/photo_detail/photo_detail_view.dart';
import '../modules/friends/friends_binding.dart';
import '../modules/friends/friends_view.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.welcome;

  static final routes = [
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeView(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.photoDetail,
      page: () => const PhotoDetailView(),
      binding: PhotoDetailBinding(),
    ),
    GetPage(
      name: Routes.friends,
      page: () => const FriendsView(),
      binding: FriendsBinding(),
    ),
  ];
}
