import 'package:get/get.dart';
import 'photo_detail_controller.dart';

class PhotoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PhotoDetailController>(() => PhotoDetailController());
  }
}
