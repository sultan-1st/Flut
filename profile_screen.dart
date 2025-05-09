import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:login_signup/appAssets/assets.dart';
import 'package:login_signup/providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add FormKey for validation

  File? _newImage;
  bool _isLoading = false; // Boolean to track loading state
  bool _isInitialized = false; // Boolean to track controllers

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.fetchProfile();
  }

  // Function to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Function to validate phone number
  String? _phoneNumberValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (value.length != 10 || !RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number should be 10 digits long';
    }
    return null;
  }

  // Function to validate names
  String? _nameValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _newImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Saved Successfully!'),
          content: const Text("Updated in Firebase"),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to handle profile update with loader
  Future<void> _handleProfileUpdate(ProfileProvider profileProvider) async {
    if (!_formKey.currentState!.validate()) {
      return; // If form is invalid, do nothing
    }

    setState(() {
      _isLoading = true; // Show loader
    });

    await profileProvider.updateProfile(
      _firstNameController.text,
      _lastNameController.text,
      _phoneNumberController.text,
      _emailController.text,
      _newImage,
    );

    setState(() {
      _isLoading = false; // Hide loader
    });
    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color.fromARGB(255, 56, 141, 35);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            if (profileProvider.profile == null) {
              return const Center(
                child: CircularProgressIndicator(color: pinkColor),
              );
            }

            if (!_isInitialized) {
              _firstNameController.text = profileProvider.profile!.firstName;
              _lastNameController.text = profileProvider.profile!.lastName;
              _phoneNumberController.text = profileProvider.profile!.phoneNumber;
              _emailController.text = profileProvider.profile!.email;
              _isInitialized = true; // Prevent re-initialization
            }

            return SingleChildScrollView(
              child: Form(
                key: _formKey, // Wrap in Form widget
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _newImage != null ? FileImage(_newImage!) : (profileProvider.profile!.profileImage != null ? FileImage(profileProvider.profile!.profileImage!) : const AssetImage(Assets.avatar)) as ImageProvider,
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: pinkColor,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('First Name', _firstNameController, _nameValidate),
                    const SizedBox(height: 30),
                    _buildTextField('Last Name', _lastNameController, _nameValidate),
                    const SizedBox(height: 30),
                    _buildTextField('Email', _emailController, _validateEmail),
                    const SizedBox(height: 30),
                    _buildTextField('Phone Number', _phoneNumberController, _phoneNumberValidate),
                    const SizedBox(height: 30),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator(color: pinkColor))
                        : ElevatedButton(
                            onPressed: () {
                              _handleProfileUpdate(profileProvider);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pinkColor,
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? Function(String?) validator) {
    const Color pinkColor = Color.fromARGB(255, 56, 141, 35);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: pinkColor),
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
      validator: validator, // Attach validator function
    );
  }
}
