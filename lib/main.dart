// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:school/account_store.dart';
import 'package:school/passwordvalidator.dart'; // Assuming you have the necessary import for PasswordField
import 'home.dart';

void main() {
  runApp(const MyApp());
}

final AccountStore accountStore = AccountStore();

List<User> registeredUsers = [];


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load registered users from secure storage
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    registeredUsers = await accountStore.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());

          default:
            // Handle unknown routes, you can return a default route or throw an exception
            throw Exception('Unknown route: ${settings.name}');
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool notFocused = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorText = '';


void _login() async {
  if (_formKey.currentState!.validate()) {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        );
      },
    );

    // Convert the entered matric number to lower case
    final matricNumber = usernameController.text.toLowerCase();
    final password = passwordController.text;

    // Perform login logic here
    try {
      // Find the account, then check the password against its salted hash
      final matchedUsers = registeredUsers
          .where((user) => user.matricNumber == matricNumber)
          .toList();
      final passwordMatches = matchedUsers.isNotEmpty &&
          await AccountStore.verifyPassword(matchedUsers.first, password);

      if (passwordMatches) {
        // Dismiss the loading indicator, clear the error text, and navigate to the home page
        Navigator.of(context).pop();
        setState(() {
          errorText = '';
        });

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Same message whether the account or the password is wrong, so the
        // screen doesn't reveal which matric numbers are registered
        Navigator.of(context).pop();
        setState(() {
          errorText = 'Incorrect matric number or password.';
          usernameController.clear();
          passwordController.clear();
        });
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.of(context).pop();

      // Update error text
      setState(() {
        errorText = 'Incorrect matric number or password.';
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom:58.0),
                        child: Image.asset("assets/images/campushd.png"),
                      ),
                      Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            notFocused = !hasFocus;
                          });
                        },
                        child: TextFormField(
                          style: TextStyle(
                              color: notFocused ? Colors.black : Colors.blue),
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Matric Number',
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            labelStyle: TextStyle(
                              color: notFocused ? Colors.black : Colors.blue,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z0-9]')),
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
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 15,
                            bottom: 15,
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent)),
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
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController matricNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String errorText = '';
  bool notFocused = true;

  @override
  void initState() {
    super.initState();
    // Load registered users from secure storage
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    registeredUsers = await accountStore.load();
  }

 void _register() async {
  if (_formKey.currentState!.validate()) {
    // Perform registration logic here
    try {
      final matricNumber = matricNumberController.text.toLowerCase();

      // Don't let anyone register a matric number that already has an
      // account, otherwise they could set their own password for it
      if (registeredUsers.any((user) => user.matricNumber == matricNumber)) {
        setState(() {
          errorText = 'An account with this matric number already exists.';
        });
        return;
      }

      // Store a salted hash of the password, never the password itself
      final newUser = await accountStore.createUser(
        matricNumber: matricNumber,
        email: emailController.text,
        password: passwordController.text,
      );
      registeredUsers.add(newUser);
      await accountStore.save(registeredUsers);
      setState(() {
        errorText = '';
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
bool matricNumberNotFocused = true;
bool emailNotFocused = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:30.0,left: 16,right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      matricNumberNotFocused = !hasFocus;
                    });
                  },
                  child: TextFormField(
                    style:
                        TextStyle(color: matricNumberNotFocused ? Colors.black : Colors.blue),
                    controller: matricNumberController,
                    decoration: InputDecoration(
                        labelText: 'Matric Number',
                        focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                        labelStyle: TextStyle(
                            color: matricNumberNotFocused ? Colors.black : Colors.blue)),
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
                ),
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      emailNotFocused = !hasFocus;
                    });
                  },
                  child: TextFormField(
                    style:
                        TextStyle(color: emailNotFocused ? Colors.black : Colors.blue),
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)), 
                        labelStyle: TextStyle(
                            color: emailNotFocused ? Colors.black : Colors.blue)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email'; // Add this line
                      }
                      if (!value.contains("@") || !value.contains(".com")) {
                        return 'Please enter a valid email';
                      }
                      // Add additional email validation if needed
                      return null;
                    },
                  ),
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
                  style: const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent)),
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
