enum ComplaintStatus {
  waitingForSync,
  submitted,
  assigned,
  inProgress,
  resolved,
}

extension ComplaintStatusExtension on ComplaintStatus {
  String get displayName {
    switch (this) {
      case ComplaintStatus.waitingForSync:
        return 'Waiting for sync';
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.assigned:
        return 'Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }
}

class ComplaintModel {
  final String id;
  final String category;
  final String location;
  final String description;
  final DateTime createdAt;
  final ComplaintStatus status;
  final String? assignedTo;
  final String? imagePath;
  final bool isPendingSync;
  final bool studentConfirmed;
  final String? internalNote;

  ComplaintModel({
    required this.id,
    required this.category,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.status,
    this.assignedTo,
    this.imagePath,
    this.isPendingSync = false,
    this.studentConfirmed = false,
    this.internalNote,
  });

  ComplaintModel copyWith({
    String? id,
    String? category,
    String? location,
    String? description,
    DateTime? createdAt,
    ComplaintStatus? status,
    String? assignedTo,
    String? imagePath,
    bool? isPendingSync,
    bool? studentConfirmed,
    String? internalNote,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      imagePath: imagePath ?? this.imagePath,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      studentConfirmed: studentConfirmed ?? this.studentConfirmed,
      internalNote: internalNote ?? this.internalNote,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'location': location,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'status': status.index,
        'assignedTo': assignedTo,
        'imagePath': imagePath,
        'isPendingSync': isPendingSync,
        'studentConfirmed': studentConfirmed,
        'internalNote': internalNote,
      };

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      status: json['status'] != null ? ComplaintStatus.values[json['status']] : ComplaintStatus.submitted,
      assignedTo: json['assignedTo'],
      imagePath: json['imagePath'],
      isPendingSync: json['isPendingSync'] ?? false,
      studentConfirmed: json['studentConfirmed'] ?? false,
      internalNote: json['internalNote'],
    );
  }
}
