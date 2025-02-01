import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ResultProcessing extends StatefulWidget {
  const ResultProcessing({super.key});

  @override
  ResultProcessingState createState() => ResultProcessingState();
}

class ResultProcessingState extends State<ResultProcessing> {
  String selectedSession = '2023/2024';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result Processing"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          DropdownButton<String>(
            value: selectedSession,
            onChanged: (String? newValue) {
              setState(() {
                selectedSession = newValue!;
              });
            },
            items: <String>['2023/2024', '2022/2023', '2021/2022']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () => _launchURL('https://bowenstudent.bowen.edu.ng//$selectedSession'),
            child: const Text('View Results'),
          ),
        ],
      ),
    );
  }

 Future<void> _launchURL(String url) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: url,
    );
    await launchUrl(launchUri);
  }
}