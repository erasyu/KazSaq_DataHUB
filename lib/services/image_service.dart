import 'package:http/http.dart' as http;

class ImageService {
  // Попытка получить изображение с сайта университета
  static Future<String?> getImageFromWebsite(String websiteUrl) async {
    if (websiteUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(websiteUrl);
      final baseUrl = '${uri.scheme}://${uri.host}';

      // Попробуем стандартные пути для логотипов и изображений
      final possiblePaths = [
        '/logo.png',
        '/logo.jpg',
        '/images/logo.png',
        '/images/logo.jpg',
        '/img/logo.png',
        '/img/logo.jpg',
        '/assets/logo.png',
        '/assets/logo.jpg',
        '/static/logo.png',
        '/static/logo.jpg',
        '/wp-content/uploads/logo.png',
        '/wp-content/uploads/logo.jpg',
      ];

      for (final path in possiblePaths) {
        try {
          final imageUrl = '$baseUrl$path';
          final response = await http.head(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final contentType = response.headers['content-type'] ?? '';
            if (contentType.startsWith('image/')) {
              return imageUrl;
            }
          }
        } catch (e) {
          continue;
        }
      }

      // Попробуем получить через Open Graph или мета-теги
      try {
        final response = await http.get(Uri.parse(websiteUrl));
        if (response.statusCode == 200) {
          final html = response.body;
          
          // Ищем Open Graph изображение
          final ogImagePattern = '<meta\\s+property=["\']og:image["\']\\s+content=["\']([^"\']+)["\']';
          final ogImageMatch = RegExp(ogImagePattern, caseSensitive: false).firstMatch(html);
          
          if (ogImageMatch != null && ogImageMatch.groupCount > 0) {
            var imageUrl = ogImageMatch.group(1)!;
            if (!imageUrl.startsWith('http')) {
              imageUrl = baseUrl + (imageUrl.startsWith('/') ? imageUrl : '/$imageUrl');
            }
            return imageUrl;
          }

          // Ищем favicon или apple-touch-icon
          final iconPattern = '<link\\s+rel=["\'](?:apple-touch-icon|icon|shortcut icon)["\']\\s+href=["\']([^"\']+)["\']';
          final iconMatch = RegExp(iconPattern, caseSensitive: false).firstMatch(html);
          
          if (iconMatch != null && iconMatch.groupCount > 0) {
            var imageUrl = iconMatch.group(1)!;
            if (!imageUrl.startsWith('http')) {
              imageUrl = baseUrl + (imageUrl.startsWith('/') ? imageUrl : '/$imageUrl');
            }
            return imageUrl;
          }
        }
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    } catch (e) {
      // Игнорируем ошибки
    }

    return null;
  }

  // Получить изображение обложки (cover image)
  static Future<String?> getCoverImageFromWebsite(String websiteUrl) async {
    if (websiteUrl.isEmpty) return null;

    try {
      final uri = Uri.parse(websiteUrl);
      final baseUrl = '${uri.scheme}://${uri.host}';

      // Попробуем стандартные пути для обложек
      final possiblePaths = [
        '/images/cover.jpg',
        '/images/cover.png',
        '/img/cover.jpg',
        '/img/cover.png',
        '/assets/cover.jpg',
        '/assets/cover.png',
        '/static/cover.jpg',
        '/static/cover.png',
        '/wp-content/uploads/cover.jpg',
        '/wp-content/uploads/cover.png',
        '/images/banner.jpg',
        '/images/banner.png',
        '/img/banner.jpg',
        '/img/banner.png',
      ];

      for (final path in possiblePaths) {
        try {
          final imageUrl = '$baseUrl$path';
          final response = await http.head(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            final contentType = response.headers['content-type'] ?? '';
            if (contentType.startsWith('image/')) {
              return imageUrl;
            }
          }
        } catch (e) {
          continue;
        }
      }

      // Попробуем получить через Open Graph
      try {
        final response = await http.get(Uri.parse(websiteUrl));
        if (response.statusCode == 200) {
          final html = response.body;
          
          // Ищем Open Graph изображение
          final ogImagePattern = '<meta\\s+property=["\']og:image["\']\\s+content=["\']([^"\']+)["\']';
          final ogImageMatch = RegExp(ogImagePattern, caseSensitive: false).firstMatch(html);
          
          if (ogImageMatch != null && ogImageMatch.groupCount > 0) {
            var imageUrl = ogImageMatch.group(1)!;
            if (!imageUrl.startsWith('http')) {
              imageUrl = baseUrl + (imageUrl.startsWith('/') ? imageUrl : '/$imageUrl');
            }
            return imageUrl;
          }
        }
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    } catch (e) {
      // Игнорируем ошибки
    }

    return null;
  }
}
