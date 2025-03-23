import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'photo_detail_controller.dart';

class PhotoDetailView extends GetView<PhotoDetailController> {
  const PhotoDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图片详情'),
        actions: [
          Obx(
            () => IconButton(
              icon:
                  controller.isSaving.value
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Icon(Icons.download),
              onPressed:
                  controller.isSaving.value ? null : controller.savePhoto,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.sharePhoto,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: controller.toggleFullScreen,
        child: Obx(
          () => InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Transform.rotate(
              angle: controller.rotation.value,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 背景色
                  Container(color: Colors.black),
                  // 大图
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: controller.photo.url,
                      fit: BoxFit.contain,
                      errorWidget:
                          (context, url, error) => const Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 48,
                          ),
                      progressIndicatorBuilder: (context, url, progress) {
                        if (progress.progress != null) {
                          controller.updateLoadingProgress(
                            (progress.progress! * 100).toInt(),
                          );
                        }
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                    backgroundColor: Colors.white.withAlpha(77),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '${controller.loadingProgress.value}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
