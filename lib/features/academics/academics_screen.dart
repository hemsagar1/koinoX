import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_provider.dart';
import '../../core/services/mock_data_service.dart';
import '../../core/widgets/custom_card.dart';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academics'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.cyanAccent,
          labelColor: AppColors.cyanAccent,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'Attendance'),
            Tab(text: 'Timetable'),
            Tab(text: 'Exams'),
            Tab(text: 'Results'),
            Tab(text: 'Notes & PDFs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceTab(context),
          _buildTimetableTab(context),
          _buildExamsTab(context),
          _buildResultsTab(context),
          _buildNotesTab(context),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final overall = appState.student.attendancePercentage;

    final subjects = [
      {'code': 'CS201', 'name': 'Data Structures & Algorithms', 'present': 38, 'total': 42, 'pct': 90.4},
      {'code': 'CS202', 'name': 'Database Systems', 'present': 33, 'total': 40, 'pct': 82.5},
      {'code': 'CS203', 'name': 'Computer Networks', 'present': 35, 'total': 40, 'pct': 87.5},
      {'code': 'CS204', 'name': 'Software Engineering', 'present': 32, 'total': 38, 'pct': 84.2},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Attendance Card
          CustomCard(
            backgroundColor: AppColors.navyPrimary,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: overall / 100,
                        backgroundColor: AppColors.navySecondary,
                        color: AppColors.cyanAccent,
                        strokeWidth: 8,
                      ),
                    ),
                    Text(
                      '${overall.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Attendance',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        overall >= 75 ? 'Eligible for examinations' : 'Low attendance warning (<75%)',
                        style: TextStyle(
                          color: overall >= 75 ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Subject-wise Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final sub = subjects[index];
              final pct = sub['pct'] as double;

              return CustomCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${sub['code']} — ${sub['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          '${pct.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: pct >= 75 ? AppColors.tealPrimary : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Attended ${sub['present']} out of ${sub['total']} classes',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          pct >= 75 ? AppColors.tealPrimary : AppColors.error,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableTab(BuildContext context) {
    final timetable = MockDataService.todayTimetable;

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: timetable.length,
      itemBuilder: (context, index) {
        final item = timetable[index];

        return CustomCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.navyPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.class_rounded, color: AppColors.cyanAccent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.subjectName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Faculty: ${item.faculty}',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14, color: AppColors.tealPrimary),
                        const SizedBox(width: 4),
                        Text(item.time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 16),
                        const Icon(Icons.room_rounded, size: 14, color: AppColors.tealPrimary),
                        const SizedBox(width: 4),
                        Text(item.room, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExamsTab(BuildContext context) {
    final exams = [
      {'code': 'CS201', 'subject': 'Data Structures & Algorithms', 'date': '15 Oct 2026', 'time': '10:00 AM - 01:00 PM', 'room': 'Hall A-1'},
      {'code': 'CS202', 'subject': 'Database Management Systems', 'date': '17 Oct 2026', 'time': '10:00 AM - 01:00 PM', 'room': 'Hall A-2'},
      {'code': 'CS203', 'subject': 'Computer Networks', 'date': '20 Oct 2026', 'time': '02:00 PM - 05:00 PM', 'room': 'Hall B-1'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.navyPrimary, borderRadius: BorderRadius.circular(8)),
                    child: Text(exam['code']!, style: const TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Text('Venue: ${exam['room']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.tealPrimary)),
                ],
              ),
              const SizedBox(height: 10),
              Text(exam['subject']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(exam['date']!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 6),
                  Text(exam['time']!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultsTab(BuildContext context) {
    final results = MockDataService.semesterResults;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: results.map((sem) {
          return CustomCard(
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Semester ${sem.semester} Results', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.cyanLight, borderRadius: BorderRadius.circular(12)),
                      child: Text('SGPA: ${sem.sgpa}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyPrimary)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                ...sem.subjects.map((sub) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sub.subjectName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                Text('Credits: ${sub.credits} | Marks: ${sub.marks}/100', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.navyPrimary, borderRadius: BorderRadius.circular(8)),
                            child: Text(sub.grade, style: const TextStyle(color: AppColors.cyanAccent, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotesTab(BuildContext context) {
    final notes = [
      {'title': 'Module 1: Binary Trees & Graphs', 'subject': 'Data Structures', 'size': '4.2 MB'},
      {'title': 'SQL Query Optimization & Normalization', 'subject': 'DBMS', 'size': '2.8 MB'},
      {'title': 'TCP/IP Protocol Suite & Routing', 'subject': 'Computer Networks', 'size': '5.1 MB'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return CustomCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 36),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('${note['subject']} • ${note['size']}', style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.navyPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading ${note['title']}...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
