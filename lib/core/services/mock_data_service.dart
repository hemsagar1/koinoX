import '../models/student_model.dart';
import '../models/complaint_model.dart';
import '../models/request_model.dart';
import '../models/notice_model.dart';
import '../models/event_model.dart';
import '../models/timetable_model.dart';
import '../models/mess_menu_model.dart';
import '../models/result_model.dart';
import '../models/notification_model.dart';

class MockDataService {
  static const StudentModel currentStudent = StudentModel(
    id: 'STU2026001',
    name: 'Aarav Sharma',
    rollNumber: 'BCA2026001',
    email: 'aarav.sharma@koinox.edu',
    course: 'BCA',
    year: '2nd Year',
    department: 'Computer Science',
    hostelBlock: 'Block A',
    roomNumber: 'A-204',
    attendancePercentage: 86.5,
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
  );

  static List<ComplaintModel> get initialComplaints => [
        ComplaintModel(
          id: 'CMP1024',
          category: 'Hostel Maintenance',
          location: 'Block A, Room A-204',
          description: 'Bathroom tap leaking continuously, causing water spillage.',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
          status: ComplaintStatus.assigned,
          assignedTo: 'Ramesh Kumar (Plumber)',
          internalNote: 'Assigned plumber Ramesh to inspect Block A.',
        ),
        ComplaintModel(
          id: 'CMP1019',
          category: 'Wi-Fi / Internet',
          location: 'Block A - 2nd Floor Corridor',
          description: 'Wi-Fi router keeps disconnecting during peak evening hours.',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          status: ComplaintStatus.inProgress,
          assignedTo: 'IT Desk - Suresh',
        ),
        ComplaintModel(
          id: 'CMP1005',
          category: 'Classroom',
          location: 'CS Lab 3, Desk 12',
          description: 'Keyboard key "E" missing on terminal 12.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          status: ComplaintStatus.resolved,
          assignedTo: 'Lab Admin - Rajesh',
          studentConfirmed: true,
        ),
      ];

  static List<RequestModel> get initialRequests => [
        RequestModel(
          id: 'REQ3041',
          studentName: 'Aarav Sharma',
          rollNumber: 'BCA2026001',
          type: RequestType.bonafide,
          purpose: 'Bank Account Opening',
          requiredDate: DateTime.now().add(const Duration(days: 3)),
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
          status: RequestStatus.underReview,
          remarks: 'Verification in progress by Academic Section',
        ),
        RequestModel(
          id: 'REQ2980',
          studentName: 'Aarav Sharma',
          rollNumber: 'BCA2026001',
          type: RequestType.gatePass,
          purpose: 'Weekend Home Visit',
          requiredDate: DateTime.now().add(const Duration(days: 1)),
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          status: RequestStatus.approved,
          outTime: '05:00 PM',
          expectedReturn: '08:00 PM (Sunday)',
        ),
      ];

  static List<NoticeModel> get initialNotices => [
        NoticeModel(
          id: 'NTC881',
          title: 'Mid-Term Examination Schedule - Fall 2026',
          content: 'The Mid-Term examinations for all 2nd & 3rd year BCA/B.Tech students start on 15th October. Detailed seating plan will be released soon.',
          type: NoticeType.examination,
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
          targetAudience: 'BCA / B.Tech 2nd Year',
          isPriority: true,
          isRead: false,
          attachmentName: 'MidTerm_Schedule_2026.pdf',
        ),
        NoticeModel(
          id: 'NTC879',
          title: 'Annual Hackathon Registration Open',
          content: 'Register your 3-member teams for KoinoX Campus Hackathon 2026. Prizes worth ₹1,50,000!',
          type: NoticeType.events,
          publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
          targetAudience: 'All Departments',
          isPriority: false,
          isRead: true,
        ),
        NoticeModel(
          id: 'NTC875',
          title: 'Hostel Water Supply Maintenance Notice',
          content: 'Water supply in Block A & B will be briefly interrupted from 2 PM to 4 PM on Thursday for overhead tank cleaning.',
          type: NoticeType.hostel,
          publishedAt: DateTime.now().subtract(const Duration(days: 1)),
          targetAudience: 'Hostel Block A & B',
          isPriority: true,
          isRead: true,
        ),
      ];

  static List<EventModel> get initialEvents => [
        EventModel(
          id: 'EVT101',
          title: 'KoinoX Hackathon 2026',
          description: 'A 24-hour campus hackathon to solve real university and societal challenges. Mentors, meals, and exciting prizes provided!',
          date: DateTime.now().add(const Duration(days: 5)),
          time: '09:00 AM - 09:00 AM (24 Hrs)',
          venue: 'Main Auditorium & CS Labs',
          organizer: 'Department of Computer Science',
          category: 'Hackathon',
          bannerUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600',
          capacity: 200,
          registeredCount: 142,
          isRegistered: false,
        ),
        EventModel(
          id: 'EVT102',
          title: 'Tech Fest "Ignite 2026"',
          description: 'Annual technical symposium featuring paper presentations, robotics showdown, gaming tournaments, and tech talks by industry leaders.',
          date: DateTime.now().add(const Duration(days: 12)),
          time: '10:00 AM - 05:00 PM',
          venue: 'University Grounds & Open Theater',
          organizer: 'Student Activity Council',
          category: 'Tech Fest',
          bannerUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600',
          capacity: 500,
          registeredCount: 310,
          isRegistered: true,
          passQrCode: 'KOINOX-EVT102-BCA2026001',
        ),
        EventModel(
          id: 'EVT103',
          title: 'Cultural Night & Music Evening',
          description: 'Join us for an electrifying evening of music, dance performances, and band showdowns with popular guest artists.',
          date: DateTime.now().add(const Duration(days: 18)),
          time: '06:00 PM - 10:00 PM',
          venue: 'Outdoor Amphitheater',
          organizer: 'Cultural Society',
          category: 'Cultural',
          bannerUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600',
          capacity: 800,
          registeredCount: 520,
          isRegistered: false,
        ),
      ];

  static List<TimetableItem> get todayTimetable => const [
        TimetableItem(
          id: 'TT01',
          subjectName: 'Data Structures & Algorithms',
          subjectCode: 'CS201',
          time: '09:00 AM - 10:15 AM',
          room: 'Room 102',
          faculty: 'Dr. R. K. Varma',
          dayOfWeek: 'Monday',
        ),
        TimetableItem(
          id: 'TT02',
          subjectName: 'Database Management Systems',
          subjectCode: 'CS202',
          time: '10:30 AM - 11:45 AM',
          room: 'CS Lab 3',
          faculty: 'Prof. S. Sen',
          dayOfWeek: 'Monday',
        ),
        TimetableItem(
          id: 'TT03',
          subjectName: 'Computer Networks',
          subjectCode: 'CS203',
          time: '01:30 PM - 02:45 PM',
          room: 'Room 204',
          faculty: 'Dr. A. Patel',
          dayOfWeek: 'Monday',
        ),
        TimetableItem(
          id: 'TT04',
          subjectName: 'Software Engineering',
          subjectCode: 'CS204',
          time: '03:00 PM - 04:15 PM',
          room: 'Room 105',
          faculty: 'Prof. M. Gupta',
          dayOfWeek: 'Monday',
        ),
      ];

  static List<MessMenuModel> get weeklyMessMenu => const [
        MessMenuModel(
          day: 'Monday',
          breakfast: 'Poha, Jalebi, Boiled Eggs / Fruit, Tea',
          lunch: 'Paneer Butter Masala, Dal Tadka, Roti, Rice, Boondi Raita',
          snacks: 'Samosa, Green Chutney, Hot Coffee',
          dinner: 'Dal Makhani, Mix Veg, Chapati, Kheer',
        ),
        MessMenuModel(
          day: 'Tuesday',
          breakfast: 'Idli, Sambhar, Coconut Chutney, Tea',
          lunch: 'Rajma Masala, Steamed Rice, Chapati, Salad',
          snacks: 'Veg Sandwich, Tea',
          dinner: 'Aloo Gobi, Chana Dal, Chapati, Gulab Jamun',
        ),
        MessMenuModel(
          day: 'Wednesday',
          breakfast: 'Aloo Paratha, Curd, Pickle, Tea',
          lunch: 'Kadi Pakoda, Jeera Rice, Chapati, Fryums',
          snacks: 'Pav Bhaji, Lemonade',
          dinner: 'Kadai Paneer / Chicken Curry, Butter Naan, Rice',
        ),
        MessMenuModel(
          day: 'Thursday',
          breakfast: 'Upma, Coconut Chutney, Banana, Tea',
          lunch: 'Chole Bhature, Onion Salad, Mint Lassi',
          snacks: 'Kachori, Tea',
          dinner: 'Mix Veg, Yellow Dal, Rice, Chapati, Ice Cream',
        ),
        MessMenuModel(
          day: 'Friday',
          breakfast: 'Masala Dosa, Sambhar, Chutney, Tea',
          lunch: 'Veg Biryani, Mirchi Ka Salan, Raita',
          snacks: 'Bread Pakoda, Coffee',
          dinner: 'Matar Paneer, Dal Fry, Chapati, Halwa',
        ),
      ];

  static List<SemesterResult> get semesterResults => const [
        SemesterResult(
          semester: 3,
          sgpa: 8.85,
          cgpa: 8.72,
          subjects: [
            SubjectGrade(subjectCode: 'CS201', subjectName: 'Data Structures & Algorithms', credits: 4, grade: 'A+', marks: 91),
            SubjectGrade(subjectCode: 'CS202', subjectName: 'Database Systems', credits: 4, grade: 'A', marks: 85),
            SubjectGrade(subjectCode: 'CS203', subjectName: 'Computer Networks', credits: 3, grade: 'A+', marks: 89),
            SubjectGrade(subjectCode: 'MA201', subjectName: 'Discrete Mathematics', credits: 3, grade: 'B+', marks: 76),
          ],
        ),
        SemesterResult(
          semester: 2,
          sgpa: 8.60,
          cgpa: 8.65,
          subjects: [
            SubjectGrade(subjectCode: 'CS101', subjectName: 'Object Oriented Programming', credits: 4, grade: 'A+', marks: 92),
            SubjectGrade(subjectCode: 'CS102', subjectName: 'Digital Logic', credits: 3, grade: 'A', marks: 84),
          ],
        ),
      ];

  static List<NotificationItem> get initialNotifications => [
        NotificationItem(
          id: 'NTF01',
          title: 'Complaint Updated',
          message: 'Your complaint CMP1024 has been assigned to Ramesh Kumar (Plumber).',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          type: 'complaint',
        ),
        NotificationItem(
          id: 'NTF02',
          title: 'Gate Pass Approved',
          message: 'Your gate pass REQ2980 for Weekend Home Visit has been approved.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          type: 'bonafide',
        ),
        NotificationItem(
          id: 'NTF03',
          title: 'New Notice Published',
          message: 'Mid-Term Examination Schedule - Fall 2026 is now available.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: 'notice',
        ),
      ];
}
