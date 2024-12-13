import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylelezza/model/user_model.dart';
import 'package:stylelezza/utils/routes/route_name.dart';
import 'package:stylelezza/utils/utils.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isNewUser = false;
  bool get isNewUser => _isNewUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isTermsAccepted = false;

  bool get isTermsAccepted => _isTermsAccepted;

  void toggleTermsAccepted(bool? value) {
    _isTermsAccepted = value ?? false;
    notifyListeners(); // Notify listeners when the value changes
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool get isSignInEnabled =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void _setLoading(bool value) {
    _isLoading = value;

    if (_isNewUser) {
      nameController.clear(); // Clear name if switching to new user
    }
    emailController.clear(); // Clear email
    passwordController.clear(); // Clear password
    notifyListeners();
    if (kDebugMode) {
      log('Loading state changed: $_isLoading');
    }
  }

  void toggleIsNewUser() {
    _isNewUser = !isNewUser;
    notifyListeners();
    if (kDebugMode) {
      log('New user toggled: $_isNewUser');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when no longer needed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //sign in with email and password
  Future<UserCredential?> signIn(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    notifyListeners();
    if (kDebugMode) {
      log('Attempting to sign in with email: $email');
    }
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _setLoading(false);
      if (kDebugMode) {
        log('Sign in successful for user: ${userCredential.user!.uid}');
      }
      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        // Extract the username from Firestore
        String username = userDoc['name'] ??
            'No Name'; // Default to 'No Name' if not available
        bool isAdmin = userDoc['isAdmin'] ??
            false; // Assuming isAdmin is stored in Firestore

        if (kDebugMode) {
          log('Sign in successful for user: ${userCredential.user!.uid}, username: $username');
        }

        // Save user data to SharedPreferences
        await saveUserDataToSharedPrefs(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          username: username,
          isAdmin: isAdmin,
        );
      } else {
        if (kDebugMode) {
          log('User document not found in Firestore.');
        }
      }
      _setLoading(false);
      notifyListeners();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Sign in error: ${e.message}');
      }
      Utils.flushBarErrorMessage(e.toString(), context);
    }
    return null;
  }

  //sign up with credential
  Future<UserCredential?> signUp(String email, String password, String name,
      BuildContext context, String userDeviceToken) async {
    _setLoading(true);
    notifyListeners();
    if (kDebugMode) {
      log('Attempting to sign up with email: $email');
    }
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          name: name,
          email: userCredential.user!.email.toString(),
          password: password,
          deviceToken: '',
          profilePic: userCredential.user!.photoURL.toString(),
          address: '',
          createdOn: DateTime.now(),
          isAdmin: false,
          isActive: true,
          phoneNumber: userCredential.user!.phoneNumber.toString());
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toJson());

      // Save user data to SharedPreferences
      await saveUserDataToSharedPrefs(
        uid: userCredential.user!.uid,
        email: email,
        username: name,
        isAdmin: false,
      );
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Sign up successful for user: ${userCredential.user!.uid}');
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Sign up error: ${e.message}');
      }
      Utils.flushBarErrorMessage(e.toString(), context);
    }
    return null;
  }

  //sign in with google
  Future<void> signInwithGoogle(BuildContext context) async {
    _setLoading(true);
    notifyListeners();
    if (kDebugMode) {
      log('Attempting to sign in with Google');
    }
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              name: user.displayName.toString(),
              email: user.email.toString(),
              password: '',
              deviceToken: '',
              profilePic: user.photoURL.toString(),
              address: '',
              createdOn: DateTime.now(),
              isAdmin: false,
              isActive: true,
              phoneNumber: user.phoneNumber.toString());
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(userModel.toJson());

          // Save user data to SharedPreferences
          await saveUserDataToSharedPrefs(
            uid: user.uid,
            email: user.email!,
            username: user.displayName!,
            isAdmin: false, // Admin status can be checked later from Firestore
          );
          _setLoading(false);
          notifyListeners();
          if (kDebugMode) {
            log('Google sign-in successful for user: ${user.uid}');
          }
          Navigator.pushReplacementNamed(context, RoutesName.bottombar);
        }
      }
    } catch (e) {
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Google sign-in error: ${e.toString()}');
      }
    }
  }

  //forgot password method
  Future<void> forgotPassword(String email, BuildContext context) async {
    _setLoading(true);
    notifyListeners();
    if (kDebugMode) {
      log('Attempting to send password reset email to: $email');
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Password reset email sent to: $email');
      }
    } catch (e) {
      _setLoading(false);
      notifyListeners();
      if (kDebugMode) {
        log('Password reset error: ${e.toString()}');
      }
      Utils.flushBarErrorMessage(e.toString(), context);
    }
  }

  // Sign out
  Future<void> signOut(BuildContext context) async {
    if (kDebugMode) {
      log('Signing out user');
    }
    await _auth.signOut();
     await Hive.deleteFromDisk();
    await clearUserDataFromSharedPrefs();

    notifyListeners();
    if (kDebugMode) {
      log('User signed out successfully');
    }
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.loginScreen, (route) => false);
  }

  // Save user data to SharedPreferences
  Future<void> saveUserDataToSharedPrefs(
      {required String uid,
      required String email,
      required String username,
      required bool isAdmin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
    await prefs.setString('username', username);
    await prefs.setBool('isAdmin', isAdmin);
    if (kDebugMode) {
      log('User data saved to SharedPreferences: $uid, $email, $username');
    }
  }

  // Retrieve user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? email = prefs.getString('email');
    String? username = prefs.getString('username');
    bool? isAdmin = prefs.getBool('isAdmin');

    if (uid != null && email != null && username != null && isAdmin != null) {
      if (kDebugMode) {
        log('User data retrieved from SharedPreferences: $uid');
      }
      return {
        'uid': uid,
        'email': email,
        'username': username,
        'isAdmin': isAdmin,
      };
    }
    if (kDebugMode) {
      log('No user data found in SharedPreferences');
    }
    return null;
  }

  // Clear user data from SharedPreferences
  Future<void> clearUserDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
    await prefs.remove('username');
    await prefs.remove('isAdmin');
    if (kDebugMode) {
      log('User data cleared from SharedPreferences');
    }
  }

  // Get user data from Firestore
  Future<List<QueryDocumentSnapshot<Object?>>> getUserDataFromFirestore(
      String uid) async {
    final QuerySnapshot docSnapshot =
        await _firestore.collection('users').where('uId', isEqualTo: uid).get();

    return docSnapshot.docs;
  }

  // Sign in with Gmail (Google Sign-In)
Future<void> signInWithGmail(BuildContext context) async {
  _setLoading(true);
  notifyListeners();

  if (kDebugMode) {
    log('Attempting to sign in with Gmail');
  }

  try {
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // If user doesn't exist, save user data to Firestore
          UserModel userModel = UserModel(
            uId: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email ?? 'No Email',
            profilePic: user.photoURL ?? '',
            deviceToken: '',
            address: '',
            createdOn: DateTime.now(),
            isAdmin: false,
            isActive: true,
            phoneNumber: user.phoneNumber ?? '', password: '',
          );

          await _firestore.collection('users').doc(user.uid).set(userModel.toJson());
        }

        // Save user data to SharedPreferences
        await saveUserDataToSharedPrefs(
          uid: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? 'No Name',
          isAdmin: userDoc.exists ? userDoc['isAdmin'] ?? false : false,
        );

        if (kDebugMode) {
          log('Google sign-in successful for user: ${user.uid}');
        }

        // Navigate to the home screen after successful sign-in
        Navigator.pushReplacementNamed(context, RoutesName.bottombar);
      }
    }
  } catch (e) {
    _setLoading(false);
    notifyListeners();

    if (kDebugMode) {
      log('Google sign-in error: ${e.toString()}');
    }

    Utils.flushBarErrorMessage('Failed to sign in with Google: $e', context);
  } finally {
    _setLoading(false);
    notifyListeners();
  }
}

}
