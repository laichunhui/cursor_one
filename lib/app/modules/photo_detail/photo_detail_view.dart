import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'photo_detail_controller.dart';

class PhotoDetailView extends GetView<PhotoDetailController> {
  const PhotoDetailView({super.key});

  static const double _minScale = 0.5;
  static const double _maxScale = 4.0;
  static const double _progressIndicatorSize = 48.0;
  static const double _progressIndicatorStrokeWidth = 4.0;
  static const double _progressTextSize = 16.0;
  static const double _progressTextSpacing = 16.0;
  static const double _savingIndicatorSize = 24.0;
  static const double _savingIndicatorStrokeWidth = 2.0;
  static const int _backgroundColorAlpha = 77;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('图片详情'),
      actions: [_buildSaveButton(), _buildShareButton()],
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => IconButton(
        icon:
            controller.isSaving.value
                ? SizedBox(
                  width: _savingIndicatorSize,
                  height: _savingIndicatorSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: _savingIndicatorStrokeWidth,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Icon(Icons.download),
        onPressed: controller.isSaving.value ? null : controller.savePhoto,
      ),
    );
  }

  Widget _buildShareButton() {
    return IconButton(
      icon: const Icon(Icons.share),
      onPressed: controller.sharePhoto,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: controller.toggleFullScreen,
      child: Obx(
        () => InteractiveViewer(
          minScale: _minScale,
          maxScale: _maxScale,
          child: Transform.rotate(
            angle: controller.rotation.value,
            child: Stack(
              fit: StackFit.expand,
              children: [_buildBackground(), _buildImage()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(color: Colors.black);
  }

  Widget _buildImage() {
    return Center(
      child: CachedNetworkImage(
        imageUrl: controller.photo.url,
        fit: BoxFit.contain,
        errorWidget:
            (context, url, error) => const Icon(
              Icons.error,
              color: Colors.white,
              size: _progressIndicatorSize,
            ),
        progressIndicatorBuilder: (context, url, progress) {
          if (progress.progress != null) {
            controller.updateLoadingProgress(
              (progress.progress! * 100).toInt(),
            );
          }
          return _buildLoadingIndicator();
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _progressIndicatorSize,
              height: _progressIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: _progressIndicatorStrokeWidth,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.white.withAlpha(_backgroundColorAlpha),
              ),
            ),
            const SizedBox(height: _progressTextSpacing),
            Text(
              '${controller.loadingProgress.value}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: _progressTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
