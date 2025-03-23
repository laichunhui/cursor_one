import 'package:get/get.dart';
import '../../data/services/unsplash_service.dart';

/// 首页控制器
class HomeController extends GetxController {
  final UnsplashService _unsplashService = Get.find<UnsplashService>();

  /// 当前选中的分类
  final RxString currentCategory = 'all'.obs;

  /// 图片列表
  final RxList<UnsplashPhoto> photos = <UnsplashPhoto>[].obs;

  /// 是否正在加载
  final RxBool isLoading = false.obs;

  /// 是否还有更多数据
  final RxBool hasMore = true.obs;

  /// 当前页码
  final RxInt currentPage = 1.obs;

  /// 分类列表
  final List<String> categories = [
    'all',
    'nature',
    'architecture',
    'people',
    'animals',
    'food',
    'travel',
    'technology',
    'fashion',
    'sports',
  ];

  @override
  void onInit() {
    super.onInit();
    loadPhotos();
  }

  /// 加载图片列表
  ///
  /// [category] - 图片分类
  /// [page] - 页码
  ///
  /// 返回 [Future<void>]
  Future<void> loadPhotos({String? category, int? page}) async {
    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading.value = true;
      final newPhotos = await _unsplashService.getPhotos(
        category: category ?? currentCategory.value,
        page: page ?? currentPage.value,
      );

      if (newPhotos.isEmpty) {
        hasMore.value = false;
      } else {
        if (page == 1) {
          photos.clear();
        }
        photos.addAll(newPhotos);
        currentPage.value++;
      }
    } catch (e) {
      Get.log('Error loading photos: $e', isError: true);
      Get.snackbar(
        'Error',
        'Failed to load photos',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 切换分类
  ///
  /// [category] - 新的分类
  ///
  /// 返回 [Future<void>]
  Future<void> changeCategory(String category) async {
    if (category == currentCategory.value) return;

    currentCategory.value = category;
    currentPage.value = 1;
    hasMore.value = true;
    await loadPhotos(category: category, page: 1);
  }

  /// 加载更多图片
  ///
  /// 返回 [Future<void>]
  Future<void> loadMore() async {
    if (!isLoading.value && hasMore.value) {
      await loadPhotos();
    }
  }
}
