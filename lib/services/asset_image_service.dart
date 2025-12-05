class AssetImageService {
  // Маппинг ID университетов к именам файлов в assets
  // Поддерживает различные варианты написания ID
  static const Map<String, String> _universityImageMap = {
    // KazNU
    'kaznu': 'assets/uniphoto/KazNU.jpg',
    'kaznu-al-farabi': 'assets/uniphoto/KazNU.jpg',
    'al-farabi-kazakh-national-university': 'assets/uniphoto/KazNU.jpg',
    
    // KBTU
    'kbtu': 'assets/uniphoto/KBTU.jpg',
    'kazakh-british-technical-university': 'assets/uniphoto/KBTU.jpg',
    
    // ENU
    'enu': 'assets/uniphoto/ENU.jpg',
    'ln-gumilyov-enu': 'assets/uniphoto/ENU.jpg',
    'eurasian-national-university': 'assets/uniphoto/ENU.jpg',
    
    // KIMEP
    'kimep': 'assets/uniphoto/KIMEP.jpg',
    'kimep-university': 'assets/uniphoto/KIMEP.jpg',
    
    // SDU
    'sdu': 'assets/uniphoto/SDU.jpeg',
    'suleyman-demirel-university': 'assets/uniphoto/SDU.jpeg',
  };

  // Получить путь к изображению университета из assets
  static String? getUniversityCoverImage(String universityId) {
    return _universityImageMap[universityId.toLowerCase()];
  }

  // Получить путь к логотипу (если есть отдельный файл)
  static String? getUniversityLogo(String universityId) {
    // Можно добавить отдельные логотипы, если они будут
    return _universityImageMap[universityId.toLowerCase()];
  }

  // Проверить, есть ли изображение для университета
  static bool hasUniversityImage(String universityId) {
    return _universityImageMap.containsKey(universityId.toLowerCase());
  }

  // Получить все доступные ID университетов с изображениями
  static List<String> getAvailableUniversityIds() {
    return _universityImageMap.keys.toList();
  }
}

