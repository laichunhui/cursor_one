import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Unsplash API 响应模型
class UnsplashPhoto {
  final String id;
  final String url;
  final String photographer;
  final String photographerUrl;

  UnsplashPhoto({
    required this.id,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'],
      url: json['urls']['regular'],
      photographer: json['user']['name'],
      photographerUrl: json['user']['links']['html'],
    );
  }
}

/// Unsplash API 服务
class UnsplashService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _clientId =
      '1Xam6YFzMAmHy92-vKgEaK5i5TXUtSDt74IL9rbCg9s'; // 需要替换为实际的 Unsplash Access Key
  late final Dio _dio;

  UnsplashService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Authorization': 'Client-ID $_clientId'},
      ),
    );
  }

  /// 获取随机图片
  ///
  /// [query] - 搜索关键词
  /// [orientation] - 图片方向 (landscape, portrait, squarish)
  ///
  /// 返回 [UnsplashPhoto] 对象，包含图片信息和作者信息
  Future<UnsplashPhoto> getRandomPhoto({
    String query = 'nature',
    String orientation = 'landscape',
  }) async {
    try {
      final response = await _dio.get(
        '/photos/random',
        queryParameters: {'query': query, 'orientation': orientation},
      );
      return UnsplashPhoto.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load photo: $e');
    }
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final UnsplashService _unsplashService = UnsplashService();
  UnsplashPhoto? _currentPhoto;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRandomPhoto();
  }

  Future<void> _loadRandomPhoto() async {
    setState(() => _isLoading = true);
    try {
      final photo = await _unsplashService.getRandomPhoto();
      setState(() {
        _currentPhoto = photo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('加载图片失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_currentPhoto != null)
            CachedNetworkImage(
              imageUrl: _currentPhoto!.url,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(77),
                  Colors.black.withAlpha(179),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withAlpha(51),
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _loadRandomPhoto,
                          icon:
                              _isLoading
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
                                  : const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Get Started'),
                      ),
                    ],
                  ),
                ),
                if (_currentPhoto != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Photo by ${_currentPhoto!.photographer}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
