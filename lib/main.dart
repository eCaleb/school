// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:school/passwordvalidator.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

List<String> registeredUsers = [];

Future<void> saveRegisteredUsers(List<String> users) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('registered_users', users);
}

Future<List<String>> getRegisteredUsers() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('registered_users') ?? [];
}

bool notFocused = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorText = '';

  @override
  void initState() {
    super.initState();
    // Load registered users from file
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsersList = prefs.getStringList('registered_users');
    if (registeredUsersList != null) {
      registeredUsers = registeredUsersList;
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Perform login logic here
      try {
        // Simulate a delay for login logic
        await Future.delayed(const Duration(seconds: 2));

        // Check if the entered matric number and password match any registered user
        final matricNumber = usernameController.text;
        final password = passwordController.text;
        if (registeredUsers.contains(matricNumber) &&
            registeredUsers.contains(password)) {
          // If a matching user is found, dismiss the loading indicator, clear the error text, and navigate to the home page
          Navigator.of(context).pop();
          setState(() {
            errorText = '';
          });
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          // If no matching user is found, dismiss the loading indicator and update the error text
          Navigator.of(context).pop();
          setState(() {
            errorText = "Account doesn't exist, please register.";
            usernameController.clear();
            passwordController.clear();
          });
        }
      } catch (e) {
        // Hide loading indicator
        Navigator.of(context).pop();

        // Update error text
        setState(() {
          errorText = "Account doesn't exist, please register.";
        });
      }
    }
  }

  List<String> registeredUsers = [];
  bool notFocused = true;
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                                        controller: usernameController,
                    decoration:  InputDecoration(
                      
                      labelText: 'Matric Number',
                      labelStyle: TextStyle(
                          color: !notFocused ? Colors.black : Colors.blue),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        usernameController.clear();
                        return 'Please enter your matric number';
                      }
                      if (value.length < 11 || value.length > 11) {
                        usernameController.clear();
                        return 'Matric number must be 11 characters or less';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  PasswordField(
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        passwordController.clear();
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        passwordController.clear();
                        return 'Password must be at least 8 characters';
                      }
                      if (!value.contains(RegExp(r'[A-Za-z]')) ||
                          !value.contains(RegExp(r'\d'))) {
                        passwordController.clear();
                        return 'Password must include both letters and numbers';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _login();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      ).then((value) {
                        setState(() {
                          errorText = '';
                        });
                      });
                    },
                    child: const Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  if (errorText.isNotEmpty)
                    Text(
                      errorText,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController matricNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorText = '';

  Future<void> _saveRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('registered_users', registeredUsers);
  }

  @override
  void initState() {
    super.initState();
    // Load registered users from file
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsersList = prefs.getStringList('registered_users');
    if (registeredUsersList != null) {
      registeredUsers = registeredUsersList;
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Perform registration logic here
      try {
        // Simulate a delay for registration logic
        await Future.delayed(const Duration(seconds: 2));

        // Add the new user to the registeredUsers list
        setState(() {
          registeredUsers.add(matricNumberController.text);
          registeredUsers.add(passwordController.text);
          _saveRegisteredUsers();
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful. Please log in.'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the text fields
        matricNumberController.clear();
        passwordController.clear();

        // Navigate back to login page
        Navigator.pop(context);
      } catch (e) {
        // Handle any errors that occur during registration
        print('Error registering user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: matricNumberController,
                decoration: const InputDecoration(
                  labelText: 'Matric Number',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your matric number';
                  }
                  if (value.length < 11 || value.length > 11) {
                    return 'Matric number must be 11 characters or less';
                  }
                  return null;
                },
              ),
              PasswordField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!value.contains(RegExp(r'[A-Za-z]')) ||
                      !value.contains(RegExp(r'\d'))) {
                    return 'Password must include both letters and numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _register();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate back to login page
                  Navigator.pop(context);
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              if (errorText.isNotEmpty)
                Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

bool validateInputs(String matricNumber, String password) {
  // Check if the matricNumber is up to 11 characters
  if (matricNumber.length < 11 || matricNumber.length > 11) {
    print('Matric number must be 11 characters or less.');
    return false;
  }

  // Check if the password is at least 8 characters and a mixture of characters
  if (password.length < 8) {
    print(
        'Password must be at least 8 characters and include both letters and numbers.');
    return false;
  }

  // Check if both fields are empty
  if (matricNumber.isEmpty && password.isEmpty) {
    print('Matric number and password cannot be empty.');
    return false;
  }

  // Check if the password contains both letters and numbers
  if (!containsLetters(password) || !containsDigits(password)) {
    print('Password must include both letters and numbers.');
    return false;
  }

  // Validation passed
  return true;
}

bool containsLetters(String value) {
  return value.contains(RegExp(r'[A-Za-z]'));
}

bool containsDigits(String value) {
  return value.contains(RegExp(r'\d'));
}
