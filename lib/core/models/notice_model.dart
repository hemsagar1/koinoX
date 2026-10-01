enum NoticeType {
  academic,
  examination,
  hostel,
  events,
  emergency,
  general,
}

class NoticeModel {
  final String id;
  final String title;
  final String content;
  final NoticeType type;
  final DateTime publishedAt;
  final String targetAudience; // e.g. "BCA 2nd Year", "All Students"
  final bool isPriority;
  final bool isRead;
  final String? attachmentName;

  NoticeModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.publishedAt,
    required this.targetAudience,
    this.isPriority = false,
    this.isRead = false,
    this.attachmentName,
  });

  NoticeModel copyWith({
    String? id,
    String? title,
    String? content,
    NoticeType? type,
    DateTime? publishedAt,
    String? targetAudience,
    bool? isPriority,
    bool? isRead,
    String? attachmentName,
  }) {
    return NoticeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      publishedAt: publishedAt ?? this.publishedAt,
      targetAudience: targetAudience ?? this.targetAudience,
      isPriority: isPriority ?? this.isPriority,
      isRead: isRead ?? this.isRead,
      attachmentName: attachmentName ?? this.attachmentName,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'type': type.index,
        'publishedAt': publishedAt.toIso8601String(),
        'targetAudience': targetAudience,
        'isPriority': isPriority,
        'isRead': isRead,
        'attachmentName': attachmentName,
      };

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] != null ? NoticeType.values[json['type']] : NoticeType.general,
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : DateTime.now(),
      targetAudience: json['targetAudience'] ?? 'All',
      isPriority: json['isPriority'] ?? false,
      isRead: json['isRead'] ?? false,
      attachmentName: json['attachmentName'],
    );
  }
}
