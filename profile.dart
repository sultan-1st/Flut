import 'dart:io';

class Profile {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  File? profileImage;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.profileImage,
  });
}