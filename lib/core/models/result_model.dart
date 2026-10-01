class SubjectGrade {
  final String subjectCode;
  final String subjectName;
  final int credits;
  final String grade;
  final int marks;

  const SubjectGrade({
    required this.subjectCode,
    required this.subjectName,
    required this.credits,
    required this.grade,
    required this.marks,
  });
}

class SemesterResult {
  final int semester;
  final double sgpa;
  final double cgpa;
  final List<SubjectGrade> subjects;

  const SemesterResult({
    required this.semester,
    required this.sgpa,
    required this.cgpa,
    required this.subjects,
  });
}
