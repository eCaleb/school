import 'dart:math';

import 'package:flutter/material.dart';

class Hostel {
  final String name;
  final String gender;
  final List<int> levels;

  Hostel({required this.name, required this.gender, required this.levels});
}

List<Hostel> hostels = [
  Hostel(name: "Mark Block", gender: "Male", levels: [100]),
  Hostel(name: "John Block", gender: "Male", levels: [200]),
  Hostel(name: "Luke Block", gender: "Male", levels: [300]),
  Hostel(name: "Matthew Block", gender: "Male", levels: [300, 400]),
  Hostel(name: "NH boys", gender: "Male", levels: [400, 500]),
  Hostel(name: "Block", gender: "Female", levels: [100]),
  Hostel(name: "UPE", gender: "Female", levels: [200]),
  Hostel(name: "NH girls", gender: "Female", levels: [300]),
  Hostel(name: "288", gender: "Female", levels: [400, 500]),
];

class HostelManagement extends StatefulWidget {
  const HostelManagement({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HostelManagementState createState() => _HostelManagementState();
}

class _HostelManagementState extends State<HostelManagement> {
  String? selectedGender;
  int? selectedLevel;
  List<Hostel> filteredHostels = [];
  bool hasAppliedForRoom = false;

  @override
  void initState() {
    super.initState();
    filterHostels();
  }

  void filterHostels() {
    setState(() {
      filteredHostels = hostels
          .where(
            (hostel) =>
                hostel.gender == selectedGender &&
                hostel.levels.contains(selectedLevel),
          )
          .toList();
    });
  }

  void _applyForRoom(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            SizedBox(width: 20),
            Text("Applying for room..."),
          ],
        ),
      );
    },
  );

  // Simulate a delay to mimic an asynchronous operation
  Future.delayed(const Duration(seconds: 2), () {
    Navigator.pop(context); // Close the loading dialog

    // Update the state to indicate that the user has applied for a room
    setState(() {
      hasAppliedForRoom = true;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Applied Successfully!"),
          content: Text("Your room number is ${_generateRoomNumber()}"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  });
}

  int _generateRoomNumber() {
    // Generate a random room number between 1 and 60
    return 1 + Random().nextInt(60);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Select Hostel", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          DropdownButton<String>(
            value:
                selectedGender ?? '', // Set a default value or leave it empty
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
                filterHostels();
              });
            },
            items: <String>['', 'Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.isEmpty ? 'Select Gender' : value),
              );
            }).toList(),
          ),
          DropdownButton<int>(
            value: selectedLevel ?? 0, // Set a default value or leave it as 0
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
                filterHostels();
              });
            },
            items: <int>[0, 100, 200, 300, 400, 500]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value == 0 ? 'Select Level' : '$value Level'),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredHostels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    filteredHostels[index].name,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  subtitle: Text(
                    "${filteredHostels[index].gender} - Levels: ${filteredHostels[index].levels.join(', ')}",
                  ),
                  tileColor: Colors.blue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textColor: Colors.white,
                );
              },
            ),
          ),
Padding(
  padding: const EdgeInsets.only(bottom:248.0),
  child: ElevatedButton(
    style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Color.fromARGB(255, 225, 234, 242))),
    onPressed: () {
  if (selectedGender == null || selectedLevel == null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Selection"),
          content: const Text("Please select both gender and level before applying for a room."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  } else if (!hasAppliedForRoom) {
    _applyForRoom(context);
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Already Applied"),
          content: const Text("You have already applied for a room."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
},

    child: const Text('Apply for Room',style: TextStyle(color: Colors.blue),),
  ),
),
        ],
      ),
    );
  }
}
