import 'package:flutter/material.dart';

class Course {
  final String name;
  final String department;
  final List<int> levels;
  final List<String> pdfNotes;
  final List<String> videoLectures;
  final List<String> assignments;
  final List<String> assessments;

  Course({
    required this.name,
    required this.department,
    required this.levels,
    required this.pdfNotes,
    required this.videoLectures,
    required this.assignments,
    required this.assessments,
  });
}

List<Course> courses = [
  Course(
    name: "Introduction to Programming",
    department: "Computer Science",
    levels: [100],
    pdfNotes: ["Introduction.pdf", "Variables.pdf"],
    videoLectures: ["IntroVideo.mp4", "VariablesVideo.mp4"],
    assignments: ["Assignment1.pdf", "Assignment2.pdf"],
    assessments: ["MidtermExam.pdf"],
  ),
  // Add more courses as needed
];


class Elearning extends StatefulWidget {
  const Elearning({super.key});

  @override
  ElearningState createState() => ElearningState();
}

class ElearningState extends State<Elearning> {
  String selectedDepartment = 'Computer Science';
  int selectedLevel = 100;
  String selectedCourse = 'Introduction to Programming';
  Course? currentCourse;

@override
void initState() {
  super.initState();
  filterCourses();
  if (courses.isNotEmpty) {
    currentCourse = courses.first;
  }
}
void filterCourses() {
  setState(() {
    currentCourse = courses.firstWhere(
      (course) => course.department == selectedDepartment && course.levels.contains(selectedLevel) && course.name == selectedCourse,
      orElse: () => courses.first,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Learning"),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
  value: selectedDepartment,
  onChanged: (value) {
    setState(() {
      selectedDepartment = value!;
      filterCourses();
    });
  },
  items: courses
      .where((course) => course.levels.contains(selectedLevel))
      .map<DropdownMenuItem<String>>((Course course) {
    return DropdownMenuItem<String>(
      value: course.department,
      child: Text(course.department),
    );
  }).toList(),
),
          DropdownButton<int>(
            value: selectedLevel,
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
                filterCourses();
              });
            },
            items: <int>[100, 200, 300, 400].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("Level $value"),
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: selectedCourse,
            onChanged: (value) {
              setState(() {
                selectedCourse = value!;
                filterCourses();
              });
            },
            items: courses
                .where((course) =>
                    course.department == selectedDepartment && course.levels.contains(selectedLevel))
                .map<DropdownMenuItem<String>>((Course course) {
              return DropdownMenuItem<String>(
                value: course.name,
                child: Text(course.name),
              );
            }).toList(),
          ),
          if (currentCourse != null) ...[
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("PDF Notes"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentCourse!.pdfNotes.map((note) => Text(note)).toList(),
                    ),
                  ),
                  ListTile(
                    title: const Text("Video Lectures"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentCourse!.videoLectures.map((video) => Text(video)).toList(),
                    ),
                  ),
                  ListTile(
                    title: const Text("Assignments"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentCourse!.assignments.map((assignment) => Text(assignment)).toList(),
                    ),
                  ),
                  ListTile(
                    title: const Text("Assessments"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentCourse!.assessments.map((assessment) => Text(assessment)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}