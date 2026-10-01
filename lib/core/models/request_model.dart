enum RequestType {
  bonafide,
  gatePass,
  leave,
  certificate,
}

enum RequestStatus {
  submitted,
  underReview,
  approved,
  rejected,
  documentReady,
}

extension RequestStatusExtension on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.submitted:
        return 'Submitted';
      case RequestStatus.underReview:
        return 'Under Review';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.documentReady:
        return 'Document Ready';
    }
  }
}

class RequestModel {
  final String id;
  final String studentName;
  final String rollNumber;
  final RequestType type;
  final String purpose;
  final DateTime requiredDate;
  final DateTime createdAt;
  final RequestStatus status;
  final String? remarks;
  final String? documentUrl;
  final String? outTime;
  final String? expectedReturn;

  RequestModel({
    required this.id,
    required this.studentName,
    required this.rollNumber,
    required this.type,
    required this.purpose,
    required this.requiredDate,
    required this.createdAt,
    required this.status,
    this.remarks,
    this.documentUrl,
    this.outTime,
    this.expectedReturn,
  });

  RequestModel copyWith({
    String? id,
    String? studentName,
    String? rollNumber,
    RequestType? type,
    String? purpose,
    DateTime? requiredDate,
    DateTime? createdAt,
    RequestStatus? status,
    String? remarks,
    String? documentUrl,
    String? outTime,
    String? expectedReturn,
  }) {
    return RequestModel(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      requiredDate: requiredDate ?? this.requiredDate,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      documentUrl: documentUrl ?? this.documentUrl,
      outTime: outTime ?? this.outTime,
      expectedReturn: expectedReturn ?? this.expectedReturn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'studentName': studentName,
        'rollNumber': rollNumber,
        'type': type.index,
        'purpose': purpose,
        'requiredDate': requiredDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'status': status.index,
        'remarks': remarks,
        'documentUrl': documentUrl,
        'outTime': outTime,
        'expectedReturn': expectedReturn,
      };

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] ?? '',
      studentName: json['studentName'] ?? '',
      rollNumber: json['rollNumber'] ?? '',
      type: json['type'] != null ? RequestType.values[json['type']] : RequestType.bonafide,
      purpose: json['purpose'] ?? '',
      requiredDate: json['requiredDate'] != null ? DateTime.parse(json['requiredDate']) : DateTime.now(),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      status: json['status'] != null ? RequestStatus.values[json['status']] : RequestStatus.submitted,
      remarks: json['remarks'],
      documentUrl: json['documentUrl'],
      outTime: json['outTime'],
      expectedReturn: json['expectedReturn'],
    );
  }
}
