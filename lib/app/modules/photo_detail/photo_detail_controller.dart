import 'package:get/get.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import '../../data/services/unsplash_service.dart';

class PhotoDetailController extends GetxController {
  final UnsplashPhoto photo = Get.arguments['photo'] as UnsplashPhoto;
  final RxDouble scale = 1.0.obs;
  final RxDouble rotation = 0.0.obs;
  final RxBool isFullScreen = false.obs;
  final RxInt loadingProgress = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool isSaving = false.obs;
  final _dio = Dio();

  void toggleFullScreen() {
    isFullScreen.value = !isFullScreen.value;
  }

  void resetTransform() {
    scale.value = 1.0;
    rotation.value = 0.0;
  }

  void sharePhoto() {
    // TODO: 实现分享功能
    Get.snackbar('分享', '分享功能开发中...', snackPosition: SnackPosition.BOTTOM);
  }

  void updateLoadingProgress(int progress) {
    loadingProgress.value = progress;
    if (progress >= 100) {
      isLoading.value = false;
    }
  }

  Future<void> savePhoto() async {
    if (isSaving.value) return;

    try {
      isSaving.value = true;

      // 下载图片数据
      final response = await _dio.get<List<int>>(
        photo.url,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageData = Uint8List.fromList(response.data!);

      // 生成文件名
      final fileName = 'unsplash_${photo.id}.jpg';

      // 保存图片
      final result = await SaverGallery.saveImage(
        imageData,
        fileName: fileName,
        skipIfExists: true,
      );

      if (result.isSuccess) {
        Get.snackbar('成功', '图片已保存到相册', snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception('保存失败');
      }
    } catch (e) {
      Get.snackbar(
        '错误',
        '保存图片失败: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
