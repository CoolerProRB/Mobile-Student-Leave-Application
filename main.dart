import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentLeaveApplication extends StatefulWidget {
  @override
  _StudentLeaveApplicationState createState() => _StudentLeaveApplicationState();
}

class _StudentLeaveApplicationState extends State<StudentLeaveApplication> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Leave Application'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.mail),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your email address';
                  }
                  // Add email validation if needed
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject / Reason',
                  prefixIcon: Icon(Icons.lightbulb),
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter the subject/reason';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Your Description',
                ),
                validator: (value) {
                  if (value == "") {
                    return 'Please enter your description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    // Access the form field values using the controller values
    String name = _nameController.text;
    String email = _emailController.text;
    String subject = _subjectController.text;
    String description = _descController.text;

    // Create the request body
    var requestBody = {
      'name': name,
      'email': email,
      'subject': subject,
      'desc': description,
    };

    // Send a POST request to your PHP endpoint
    var url = 'https://desmondai.online/temp.php';
    var response = await http.post(Uri.parse(url), body: requestBody);

    if (response.statusCode == 200) {
      // Form submitted successfully
      var responseData = jsonDecode(response.body);
      var status = responseData['status'];

      if (status == 'success') {
        // Redirect to the second page and pass form data as arguments
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(formData: requestBody),
          ),
        );
      } else {
        if(responseData['name'] != ""){
          _showResultDialog('Failure', responseData['name']);
        }if(responseData['email'] != ""){
          _showResultDialog('Failure', responseData['email']);
        }
      }
    } else {
      // Error occurred while submitting the form
      _showResultDialog('Error', 'An error occurred. Please try again later.');
    }

    // Clear the form fields after submission
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _descController.clear();
  }

  void _showResultDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class SecondPage extends StatelessWidget {
  final Map<String, String> formData;

  const SecondPage({Key? key, required this.formData}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Leave Application Confirmation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${formData['name']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              'Email: ${formData['email']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              'Subject: ${formData['subject']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              'Description: ${formData['desc']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),ElevatedButton(
              onPressed: () {
                _submitForm(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    // Access the form field values using the controller values
    String? name = formData["name"];
    String? email = formData["email"];
    String? subject = formData["subject"];
    String? description = formData["desc"];

    // Create the request body
    var requestBody = {
      'name': name,
      'email': email,
      'subject': subject,
      'desc': description,
    };

    var url = 'https://desmondai.online/process.php';
    var response = await http.post(Uri.parse(url), body: requestBody);

    if (response.statusCode == 200) {
      // Form submitted successfully
      var responseData = jsonDecode(response.body);
      var status = responseData['status'];

      if (status == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThirdPage(),
          ),
        );
      }
    }
  }
}

class ThirdPage extends StatelessWidget{
  const ThirdPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result"),
      ),
      body: Column(
        children: [
          Text(
            "Your application has been submitted!",
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            "Please check your email for update regarding your application.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentLeaveApplication(),
  ));
}
