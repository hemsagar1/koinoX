class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String venue;
  final String organizer;
  final String category;
  final String bannerUrl;
  final int capacity;
  final int registeredCount;
  final bool isRegistered;
  final String? passQrCode;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.organizer,
    required this.category,
    required this.bannerUrl,
    required this.capacity,
    required this.registeredCount,
    this.isRegistered = false,
    this.passQrCode,
  });

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    String? venue,
    String? organizer,
    String? category,
    String? bannerUrl,
    int? capacity,
    int? registeredCount,
    bool? isRegistered,
    String? passQrCode,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      category: category ?? this.category,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      capacity: capacity ?? this.capacity,
      registeredCount: registeredCount ?? this.registeredCount,
      isRegistered: isRegistered ?? this.isRegistered,
      passQrCode: passQrCode ?? this.passQrCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'time': time,
        'venue': venue,
        'organizer': organizer,
        'category': category,
        'bannerUrl': bannerUrl,
        'capacity': capacity,
        'registeredCount': registeredCount,
        'isRegistered': isRegistered,
        'passQrCode': passQrCode,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      time: json['time'] ?? '',
      venue: json['venue'] ?? '',
      organizer: json['organizer'] ?? '',
      category: json['category'] ?? 'General',
      bannerUrl: json['bannerUrl'] ?? '',
      capacity: json['capacity'] ?? 100,
      registeredCount: json['registeredCount'] ?? 0,
      isRegistered: json['isRegistered'] ?? false,
      passQrCode: json['passQrCode'],
    );
  }
}
