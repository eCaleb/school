import 'package:flutter/material.dart';

class Course {
  final String id;
  final String name;
  final List<String> prerequisites;

  Course({required this.id, required this.name, required this.prerequisites});
}

class Student {
  final String id;
  final String name;
  List<String> enrolledCourses = [];

  Student({required this.id, required this.name});

  List<Course> generateSchedule(List<Course> allCourses) {
    return allCourses
        .where((course) => enrolledCourses.contains(course.id))
        .toList()
      ..sort((a, b) => enrolledCourses
          .indexOf(a.id)
          .compareTo(enrolledCourses.indexOf(b.id)));
  }

  void addCourse(String courseId) {
    enrolledCourses.add(courseId);
  }

  void dropCourse(String courseId) {
    enrolledCourses.remove(courseId);
  }

  bool canAddOrDropCourses(DateTime deadline) {
    return DateTime.now().isBefore(deadline);
  }
}

class CourseRegistrationSystem {
  List<Course> allCourses = [
    Course(id: 'C1', name: 'Introduction to Programming', prerequisites: []),
    Course(id: 'C2', name: 'Data Structures', prerequisites: ['C1']),
    Course(id: 'C3', name: 'Algorithms', prerequisites: ['C2']),
  ];

  List<Student> students = [];

  void enrollStudent(Student student, Course course, VoidCallback updateUI) {
    if (!students.contains(student)) {
      students.add(student);
    }

    if (student.canAddOrDropCourses(DateTime.now())) {
      if (course.prerequisites.every(
          (prerequisite) => student.enrolledCourses.contains(prerequisite))) {
        student.addCourse(course.id);
        // Update UI
        updateUI();
      }
    }
  }

  void dropCourse(Student student, Course course, VoidCallback updateUI) {
    if (student.canAddOrDropCourses(DateTime.now())) {
      student.dropCourse(course.id);
      // Update UI
      updateUI();
    }
  }
}

class CourseRegistration extends StatefulWidget {
  const CourseRegistration({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseRegistrationState createState() => _CourseRegistrationState();
}

class _CourseRegistrationState extends State<CourseRegistration> {
  final CourseRegistrationSystem system = CourseRegistrationSystem();
  final Student student = Student(id: 'S1', name: 'Alice');

  void updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Course Registration'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Available Courses:'),
              for (var course in system.allCourses)
                ListTile(
                  title: Text(course.name),
                  subtitle:
                      Text('Prerequisites: ${course.prerequisites.join(', ')}'),
                  trailing: ElevatedButton.icon(
                    onPressed: () {
                      if (student.enrolledCourses.contains(course.id)) {
                        system.dropCourse(student, course, updateUI);
                      } else {
                        system.enrollStudent(student, course, updateUI);
                      }
                    },
                    icon: Icon(
                      student.enrolledCourses.contains(course.id)
                          ? Icons.check_circle
                          : Icons.add_circle,
                    ),
                    label: Text(
                      student.enrolledCourses.contains(course.id)
                          ? 'Enrolled'
                          : 'Enroll',
                    ),
                  ),
                ),
              const Divider(),
              const Text('Your Schedule:'),
              if (student.enrolledCourses.isNotEmpty)
                for (var course in student.generateSchedule(system.allCourses))
                  ListTile(
                    title: Text(course.name),
                    trailing: ElevatedButton(
                      onPressed: () {
                        system.dropCourse(student, course, updateUI);
                      },
                      child: const Text('Drop'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
