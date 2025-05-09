import 'package:flutter/material.dart';
import 'package:login_signup/appAssets/assets.dart';
import 'package:login_signup/res/res.dart';
import 'package:login_signup/routes/routes.dart';
import 'package:login_signup/screens/authentication/authenticationWidgets/register_success_modal_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_auth/auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _obscureConfirmPassword = true;
  String? errorMessage = '';

  void _togglePasswordVisibility() {
  setState(() {
    _obscurePassword = !_obscurePassword;
    _obscureConfirmPassword = !_obscureConfirmPassword;
  });
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Function to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _phoneNumberValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (value.length != 10) {
      return 'Phone number should be of 10 digits';
    }
    return null;
  }

  String? _nameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  // Function to validate passwords
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  // Function to validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Function to handle registration
  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;  // Show loader
      });
      try {
        // Create user with email and password
        await createUserWithEmailAndPassword();

        // Show success modal sheet if registration is successful
        if (mounted) {
          showModalBottomSheet(
              context: context,
              builder: (context) => const RegisterSuccessModalSheet());

          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          await firestore.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
            'First Name': _firstNameController.text.trim(),
            'Last Name': _lastNameController.text.trim(),
            'Email': _emailController.text.trim(),
            "Phone Number": _phoneNumberController.text.trim(),
          });

          // Navigate to dashboard
          router.go(Routes.onDashboard);
        }
      } on FirebaseAuthException catch (e) {
        // Show an error dialog if registration fails
        _showErrorDialog(e.message ?? 'Registration failed. Please try again.');
      } catch (e) {
        // Handle any other errors
        _showErrorDialog('An unexpected error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;  // Hide loader after login attempt
        });
      }
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Firebase registration function
  Future<void> createUserWithEmailAndPassword() async {
    print("Attempting to register user...");
    await Auth().createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    print("User registered successfully");
  }

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color.fromARGB(255, 56, 141, 35);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20, vertical: getHeight() * 0.002),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo or icon
                  Row(
                    children: [
                      Image.asset(Assets.companyLogo,
                          height: getHeight() * 0.035),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Title
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Subtitle
                  Text(
                    "Let's Get Started!",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 40),
                  // First Name
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      floatingLabelStyle: const TextStyle(color: pinkColor),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          Assets.userIcon, // Your custom icon path
                          width: 10, // Adjust size
                          height: 10, // Adjust size
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: pinkColor),
                      ),
                    ),
                    validator: _nameValidate,
                  ),
                  const SizedBox(height: 20),
                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      floatingLabelStyle: const TextStyle(color: pinkColor),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          Assets.userIcon, // Your custom icon path
                          width: 10, // Adjust size
                          height: 10, // Adjust size
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: pinkColor),
                      ),
                    ),
                    validator: _nameValidate,
                  ),
                  const SizedBox(height: 20),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      floatingLabelStyle: const TextStyle(color: pinkColor),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: pinkColor),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 20),
                  // Phone Number Field
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      floatingLabelStyle: const TextStyle(color: pinkColor),
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: pinkColor),
                      ),
                    ),
                    validator: _phoneNumberValidate,
                  ),
                  const SizedBox(height: 20),
                  // Password field
TextFormField(
  controller: _passwordController,
  obscureText: _obscurePassword,
  decoration: InputDecoration(
    labelText: 'Password',
    floatingLabelStyle: const TextStyle(color: pinkColor),
    prefixIcon: const Icon(Icons.lock_outline),
    suffixIcon: IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: _togglePasswordVisibility,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: pinkColor),
    ),
  ),
  validator: _validatePassword,
),

const SizedBox(height: 20),

TextFormField(
  controller: _confirmPasswordController,
  obscureText: _obscureConfirmPassword,
  decoration: InputDecoration(
    labelText: 'Confirm Password',
    floatingLabelStyle: const TextStyle(color: pinkColor),
    prefixIcon: const Icon(Icons.lock_outline),
    suffixIcon: IconButton(
      icon: Icon(
        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
      ),
      onPressed: _togglePasswordVisibility,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: pinkColor),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
),
                  const SizedBox(height: 30),
                  // Register button
                  _isLoading
                      ? Center(child: CircularProgressIndicator(color: pinkColor))
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pinkColor,
                            shadowColor: Colors.white,
                            splashFactory: InkSparkle.splashFactory,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 30),
                  // Already have an account text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to login
                          router.go(Routes.onLoginRoute);
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: pinkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: getHeight() * 0.02)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}