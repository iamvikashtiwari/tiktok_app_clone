import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_app_clone/constants.dart';
import 'package:tiktok_app_clone/models/user_model.dart' as model;
import 'package:tiktok_app_clone/views/screens/auth/login_screen.dart';
import 'package:tiktok_app_clone/views/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile picture',
          'You have successfully selected your profile picture');
    }

    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }

  ///Upload to firestorage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  ///registering the user
  Future<void> registerUser() async {
    if (profilePhoto == null || profilePhoto == '') {
      Get.snackbar('Error', 'Please Select Image');
    } else if (userNameController.text.isEmpty) {
      Get.snackbar('Error', 'Please Enter User Name');
    } else if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please Enter Email');
    } else if (passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please Enter Password');
    } else {
      try {
        if (userNameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          //save  out user to out auth and firebase firestore
          UserCredential cred =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          String downloadUrl = await _uploadToStorage(profilePhoto!);
          model.User user = model.User(
            name: userNameController.text.trim(),
            profilePhotos: downloadUrl,
            email: emailController.text.trim(),
            uid: cred.user!.uid,
          );

          await firestore
              .collection('users')
              .doc(cred.user!.uid)
              .set(user.toJson());
        } else if (profilePhoto == null) {
          Get.snackbar(
              'Error while creating Account', 'Please Select Profile Picture');
        } else {
          Get.snackbar(
              'Error while creating Account', 'Please Enter all the fields');
        }
      } catch (e) {
        Get.snackbar('Error while creating Account', e.toString());
      }
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar('Error while Login', 'Please Enter all the fields');
      }
    } catch (e) {
      Get.snackbar('Error while Login', e.toString());
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }
}
