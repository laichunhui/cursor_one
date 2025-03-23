import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UnsplashPhoto {
  final String id;
  final String url;
  final String thumbUrl;
  final String photographer;
  final String photographerUrl;

  UnsplashPhoto({
    required this.id,
    required this.url,
    required this.thumbUrl,
    required this.photographer,
    required this.photographerUrl,
  });

  factory UnsplashPhoto.fromJson(Map<String, dynamic> json) {
    return UnsplashPhoto(
      id: json['id'],
      url: json['urls']['regular'],
      thumbUrl: json['urls']['thumb'],
      photographer: json['user']['name'],
      photographerUrl: json['user']['links']['html'],
    );
  }
}

class UnsplashService extends GetxService {
  static const String _baseUrl = 'https://api.unsplash.com';
  static const String _clientId = '1Xam6YFzMAmHy92-vKgEaK5i5TXUtSDt74IL9rbCg9s';
  static const int _perPage = 30;
  late final Dio _dio;

  Future<UnsplashService> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        headers: {'Authorization': 'Client-ID $_clientId'},
      ),
    );
    return this;
  }

  /// 获取随机图片
  ///
  /// [query] - 搜索关键词
  /// [orientation] - 图片方向 (landscape, portrait, squarish)
  ///
  /// 返回 [Future<UnsplashPhoto>]
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

  /// 获取图片列表
  ///
  /// [category] - 图片分类
  /// [page] - 页码
  ///
  /// 返回 [Future<List<UnsplashPhoto>>]
  Future<List<UnsplashPhoto>> getPhotos({
    required String category,
    required int page,
  }) async {
    try {
      final query = category == 'all' ? '' : category;
      final response = await _dio.get(
        '/search/photos',
        queryParameters: {
          'page': page,
          'per_page': _perPage,
          'query': query,
          'order_by': 'relevant',
        },
      );
      final List<dynamic> data = response.data['results'];
      return data.map((json) => UnsplashPhoto.fromJson(json)).toList();
    } catch (e) {
      Get.log('Error in getPhotos: $e', isError: true);
      throw Exception('Failed to load photos: $e');
    }
  }
}
