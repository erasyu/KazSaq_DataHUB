import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String title;
  final String titleRu;
  final String titleKz;
  final String content;
  final String contentRu;
  final String contentKz;
  final String imageUrl;
  final DateTime publishedAt;
  final String? universityId;
  final String? category;
  final String? sourceUrl;

  News({
    required this.id,
    required this.title,
    required this.titleRu,
    required this.titleKz,
    required this.content,
    required this.contentRu,
    required this.contentKz,
    required this.imageUrl,
    required this.publishedAt,
    this.universityId,
    this.category,
    this.sourceUrl,
  });

  factory News.fromMap(String id, Map<String, dynamic> map) {
    return News(
      id: id,
      title: map['title'] ?? '',
      titleRu: map['titleRu'] ?? '',
      titleKz: map['titleKz'] ?? '',
      content: map['content'] ?? '',
      contentRu: map['contentRu'] ?? '',
      contentKz: map['contentKz'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      publishedAt: map['publishedAt'] != null
          ? (map['publishedAt'] as Timestamp).toDate()
          : DateTime.now(),
      universityId: map['universityId'],
      category: map['category'],
      sourceUrl: map['sourceUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'titleRu': titleRu,
      'titleKz': titleKz,
      'content': content,
      'contentRu': contentRu,
      'contentKz': contentKz,
      'imageUrl': imageUrl,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'universityId': universityId,
      'category': category,
      'sourceUrl': sourceUrl,
    };
  }
}

