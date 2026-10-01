class StudentModel {
  final String id;
  final String name;
  final String rollNumber;
  final String email;
  final String course;
  final String year;
  final String department;
  final String hostelBlock;
  final String roomNumber;
  final double attendancePercentage;
  final String avatarUrl;

  const StudentModel({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.email,
    required this.course,
    required this.year,
    required this.department,
    required this.hostelBlock,
    required this.roomNumber,
    required this.attendancePercentage,
    required this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rollNumber': rollNumber,
        'email': email,
        'course': course,
        'year': year,
        'department': department,
        'hostelBlock': hostelBlock,
        'roomNumber': roomNumber,
        'attendancePercentage': attendancePercentage,
        'avatarUrl': avatarUrl,
      };

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      email: json['email'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      department: json['department'] ?? '',
      hostelBlock: json['hostelBlock'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      attendancePercentage: (json['attendancePercentage'] as num?)?.toDouble() ?? 0.0,
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
