import 'package:get/get.dart';
import '../../data/services/unsplash_service.dart';

class WelcomeController extends GetxController {
  final UnsplashService _unsplashService = Get.find<UnsplashService>();

  final Rx<UnsplashPhoto?> currentPhoto = Rx<UnsplashPhoto?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRandomPhoto();
  }

  Future<void> loadRandomPhoto() async {
    isLoading.value = true;
    try {
      final photo = await _unsplashService.getRandomPhoto();
      currentPhoto.value = photo;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load photo',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
