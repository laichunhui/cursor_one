import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../routes/app_pages.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('壁纸工具', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Get.toNamed(Routes.friends),
            tooltip: '好友列表',
          ),
        ],
      ),
      body: Column(
        children: [
          // 分类按钮组
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => controller.changeCategory(category),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                controller.currentCategory.value == category
                                    ? Colors.black
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  controller.currentCategory.value == category
                                      ? Colors.black
                                      : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            scale:
                                controller.currentCategory.value == category
                                    ? 1.05
                                    : 1.0,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight:
                                      controller.currentCategory.value ==
                                              category
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                  color:
                                      controller.currentCategory.value ==
                                              category
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                                child: Text(
                                  category == 'all' ? '全部' : category,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 图片瀑布流
          Expanded(
            child: Obx(() {
              if (controller.photos.isEmpty && !controller.isLoading.value) {
                return const Center(child: Text('暂无图片'));
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                    controller.loadMore();
                  }
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MasonryGridView.count(
                    crossAxisCount: (MediaQuery.of(context).size.width / 180)
                        .floor()
                        .clamp(2, 4),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount:
                        controller.photos.length +
                        (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == controller.photos.length) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(77),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final photo = controller.photos[index];
                      // 计算比例，让图片显示更自然
                      double aspectRatio = photo.aspectRatio;

                      return GestureDetector(
                        onTap:
                            () => Get.toNamed(
                              Routes.photoDetail,
                              arguments: {'photo': photo},
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: CachedNetworkImage(
                              imageUrl: photo.url,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(77),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(77),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.friends),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.people),
      ),
    );
  }
}
