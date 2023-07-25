import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final int petID;

  EditPage({required this.petID});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController startedDateController = TextEditingController();
  TextEditingController feedController = TextEditingController();
  TextEditingController soreSpotController = TextEditingController();
  TextEditingController profileUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pet Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Pet Information for Pet ID ${widget.petID}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: speciesController,
                decoration: InputDecoration(labelText: 'Species'),
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight'),
              ),
              TextField(
                controller: startedDateController,
                decoration: InputDecoration(labelText: 'Started Date'),
              ),
              TextField(
                controller: feedController,
                decoration: InputDecoration(labelText: 'Feed'),
              ),
              TextField(
                controller: soreSpotController,
                decoration: InputDecoration(labelText: 'Sore Spot'),
              ),
              TextField(
                controller: profileUrlController,
                decoration: InputDecoration(labelText: 'Profile URL'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updatePetInformation();
                },
                child: Text('Update Pet Information'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePetInformation() async {
    final apiUrl = 'http://54.180.70.169/api/pets/modify/${widget.petID}';

    final requestBody = {
      "name": nameController.text,
      "age": int.parse(ageController.text),
      "species": speciesController.text,
      "gender": genderController.text,
      "weight": double.parse(weightController.text),
      "startedDate": startedDateController.text,
      "feed": feedController.text,
      "soreSpot": soreSpotController.text,
      "profile_url": profileUrlController.text,
    };

    try {
      final response = await http.patch(Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(requestBody));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // TODO: 수정 성공 처리 및 갱신 로직 추가
        Navigator.pop(context);
      } else {
        print(
            'Failed to update pet information. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update pet information')),
        );
      }
    } catch (e) {
      print('An error occurred while updating pet information: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while updating pet information')),
      );
    }
  }
}
