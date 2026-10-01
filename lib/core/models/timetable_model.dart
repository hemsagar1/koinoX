class TimetableItem {
  final String id;
  final String subjectName;
  final String subjectCode;
  final String time;
  final String room;
  final String faculty;
  final String dayOfWeek;

  const TimetableItem({
    required this.id,
    required this.subjectName,
    required this.subjectCode,
    required this.time,
    required this.room,
    required this.faculty,
    required this.dayOfWeek,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectName': subjectName,
        'subjectCode': subjectCode,
        'time': time,
        'room': room,
        'faculty': faculty,
        'dayOfWeek': dayOfWeek,
      };

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      id: json['id'] ?? '',
      subjectName: json['subjectName'] ?? '',
      subjectCode: json['subjectCode'] ?? '',
      time: json['time'] ?? '',
      room: json['room'] ?? '',
      faculty: json['faculty'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? 'Monday',
    );
  }
}
