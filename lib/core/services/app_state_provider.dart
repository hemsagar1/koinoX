import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_model.dart';
import '../models/complaint_model.dart';
import '../models/request_model.dart';
import '../models/notice_model.dart';
import '../models/event_model.dart';
import '../models/notification_model.dart';
import 'mock_data_service.dart';

class AppStateProvider extends ChangeNotifier {
  // Current user role: 'student', 'admin', or 'staff'
  String _currentRole = 'student';
  bool _isOnline = true;
  bool _isDarkMode = false;
  bool _isLoading = false;

  StudentModel _student = MockDataService.currentStudent;
  List<ComplaintModel> _complaints = [];
  List<RequestModel> _requests = [];
  List<NoticeModel> _notices = [];
  List<EventModel> _events = [];
  List<NotificationItem> _notifications = [];

  // Getters
  String get currentRole => _currentRole;
  bool get isOnline => _isOnline;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;
  StudentModel get student => _student;

  List<ComplaintModel> get complaints => List.unmodifiable(_complaints);
  List<RequestModel> get requests => List.unmodifiable(_requests);
  List<NoticeModel> get notices => List.unmodifiable(_notices);
  List<EventModel> get events => List.unmodifiable(_events);
  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  // Unread count
  int get unreadNoticeCount => _notices.where((n) => !n.isRead).length;
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  // Sync count
  int get pendingSyncCount => _complaints.where((c) => c.isPendingSync).length;

  AppStateProvider() {
    _initData();
  }

  Future<void> _initData() async {
    _complaints = MockDataService.initialComplaints;
    _requests = MockDataService.initialRequests;
    _notices = MockDataService.initialNotices;
    _events = MockDataService.initialEvents;
    _notifications = MockDataService.initialNotifications;
    
    await _loadFromPrefs();
    notifyListeners();
  }

  // --- Role & Mode Switchers ---
  void setRole(String role) {
    _currentRole = role;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void updateStudent(StudentModel student) {
    _student = student;
    notifyListeners();
  }

  // --- Offline / Online Simulation ---
  Future<void> setOnlineStatus(bool online) async {
    _isOnline = online;
    notifyListeners();

    if (_isOnline) {
      await _syncPendingComplaints();
    }
  }

  Future<void> _syncPendingComplaints() async {
    bool updated = false;
    for (int i = 0; i < _complaints.length; i++) {
      if (_complaints[i].isPendingSync) {
        _complaints[i] = _complaints[i].copyWith(
          status: ComplaintStatus.submitted,
          isPendingSync: false,
        );
        updated = true;
      }
    }

    if (updated) {
      addNotification(
        title: 'Sync Complete',
        message: 'Your offline complaint(s) have been successfully synced to campus servers.',
        type: 'complaint',
      );
      await _saveToPrefs();
      notifyListeners();
    }
  }

  // --- Complaint Operations ---
  Future<String> createComplaint({
    required String category,
    required String location,
    required String description,
    String? imagePath,
  }) async {
    final newId = 'CMP${1025 + _complaints.length}';
    final isOffline = !_isOnline;

    final newComplaint = ComplaintModel(
      id: newId,
      category: category,
      location: location,
      description: description,
      createdAt: DateTime.now(),
      status: isOffline ? ComplaintStatus.waitingForSync : ComplaintStatus.submitted,
      imagePath: imagePath,
      isPendingSync: isOffline,
    );

    _complaints.insert(0, newComplaint);

    if (isOffline) {
      addNotification(
        title: 'Saved Offline',
        message: 'Complaint $newId created in offline mode. Will sync automatically when online.',
        type: 'complaint',
      );
    } else {
      addNotification(
        title: 'Complaint Submitted',
        message: 'Complaint $newId submitted successfully. Campus team notified.',
        type: 'complaint',
      );
    }

    await _saveToPrefs();
    notifyListeners();
    return newId;
  }

  Future<void> updateComplaintStatus({
    required String complaintId,
    required ComplaintStatus status,
    String? assignedTo,
    String? internalNote,
  }) async {
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(
        status: status,
        assignedTo: assignedTo ?? _complaints[index].assignedTo,
        internalNote: internalNote ?? _complaints[index].internalNote,
      );

      addNotification(
        title: 'Complaint Status Update',
        message: 'Complaint $complaintId status updated to "${status.displayName}".',
        type: 'complaint',
      );

      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> confirmComplaintResolution(String complaintId) async {
    final index = _complaints.indexWhere((c) => c.id == complaintId);
    if (index != -1) {
      _complaints[index] = _complaints[index].copyWith(studentConfirmed: true);
      addNotification(
        title: 'Resolution Confirmed',
        message: 'Thank you for confirming resolution for $complaintId.',
        type: 'complaint',
      );
      await _saveToPrefs();
      notifyListeners();
    }
  }

  // --- Bonafide & Request Operations ---
  Future<String> createRequest({
    required RequestType type,
    required String purpose,
    required DateTime requiredDate,
    String? outTime,
    String? expectedReturn,
  }) async {
    final newId = 'REQ${3042 + _requests.length}';
    final newRequest = RequestModel(
      id: newId,
      studentName: _student.name,
      rollNumber: _student.rollNumber,
      type: type,
      purpose: purpose,
      requiredDate: requiredDate,
      createdAt: DateTime.now(),
      status: RequestStatus.submitted,
      outTime: outTime,
      expectedReturn: expectedReturn,
    );

    _requests.insert(0, newRequest);
    addNotification(
      title: '${type == RequestType.bonafide ? "Bonafide" : "Gate Pass"} Submitted',
      message: 'Request $newId generated. Under review by administration.',
      type: 'bonafide',
    );

    await _saveToPrefs();
    notifyListeners();
    return newId;
  }

  Future<void> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? remarks,
  }) async {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = _requests[index].copyWith(
        status: status,
        remarks: remarks ?? _requests[index].remarks,
      );

      final req = _requests[index];
      addNotification(
        title: 'Request Update: ${req.id}',
        message: 'Your request for "${req.purpose}" is now ${status.displayName}.',
        type: 'bonafide',
      );

      await _saveToPrefs();
      notifyListeners();
    }
  }

  // --- Event Operations ---
  Future<void> registerForEvent(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final event = _events[index];
      if (!event.isRegistered) {
        _events[index] = event.copyWith(
          isRegistered: true,
          registeredCount: event.registeredCount + 1,
          passQrCode: 'KOINOX-${event.id}-${_student.rollNumber}',
        );

        addNotification(
          title: 'Event Registration Confirmed!',
          message: 'You are registered for ${event.title}. Digital Pass ready.',
          type: 'event',
        );

        await _saveToPrefs();
        notifyListeners();
      }
    }
  }

  Future<void> addEvent({
    required String title,
    required String description,
    required String venue,
    required String category,
    required DateTime date,
    required String time,
    required int capacity,
    String? organizer,
    String? bannerUrl,
  }) async {
    final newEvent = EventModel(
      id: 'EVT${_events.length + 101}',
      title: title,
      description: description,
      venue: venue,
      category: category,
      bannerUrl: bannerUrl ?? 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      date: date,
      time: time,
      capacity: capacity,
      registeredCount: 0,
      organizer: organizer ?? 'Student Affairs Office',
    );
    _events.insert(0, newEvent);
    addNotification(
      title: 'New Campus Event',
      message: '"$title" has been announced! Check details and register.',
      type: 'event',
    );
    await _saveToPrefs();
    notifyListeners();
  }

  // --- Notice Operations ---
  Future<void> addNotice({
    required String title,
    required String content,
    required NoticeType type,
    required String targetAudience,
    bool isPriority = false,
  }) async {
    final newNotice = NoticeModel(
      id: 'NTC${882 + _notices.length}',
      title: title,
      content: content,
      type: type,
      publishedAt: DateTime.now(),
      targetAudience: targetAudience,
      isPriority: isPriority,
      isRead: false,
    );

    _notices.insert(0, newNotice);
    addNotification(
      title: 'New Official Notice',
      message: title,
      type: 'notice',
    );

    await _saveToPrefs();
    notifyListeners();
  }

  void markNoticeAsRead(String noticeId) {
    final index = _notices.indexWhere((n) => n.id == noticeId);
    if (index != -1) {
      _notices[index] = _notices[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  // --- Notification Helpers ---
  void addNotification({
    required String title,
    required String message,
    String? type,
  }) {
    final item = NotificationItem(
      id: 'NTF${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      type: type,
    );
    _notifications.insert(0, item);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  // --- Local Persistence ---
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final complaintsJson = _complaints.map((c) => c.toJson()).toList();
      await prefs.setString('koinox_complaints', jsonEncode(complaintsJson));

      final requestsJson = _requests.map((r) => r.toJson()).toList();
      await prefs.setString('koinox_requests', jsonEncode(requestsJson));
    } catch (_) {}
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final complaintsString = prefs.getString('koinox_complaints');
      if (complaintsString != null) {
        final List list = jsonDecode(complaintsString);
        _complaints = list.map((item) => ComplaintModel.fromJson(item)).toList();
      }

      final requestsString = prefs.getString('koinox_requests');
      if (requestsString != null) {
        final List list = jsonDecode(requestsString);
        _requests = list.map((item) => RequestModel.fromJson(item)).toList();
      }
    } catch (_) {}
  }
}
