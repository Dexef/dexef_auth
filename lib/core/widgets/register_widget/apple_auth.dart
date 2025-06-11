import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppleAuth extends StatefulWidget {
  const AppleAuth({super.key});

  @override
  State<AppleAuth> createState() => _AppleAuthState();
}

class _AppleAuthState extends State<AppleAuth> {
  @override
  Widget build(BuildContext context) {
    return Center(
           child: MaterialButton(onPressed: () async  {
             UserCredential userCredential = await  signInWithApple();
             print(userCredential);
           },
            child: const Text('Sign in With Apple'),
           ),

    );
  }


  Future<UserCredential> signInWithApple() async {
    // Create and configure an OAuthProvider for Sign In with Apple.
    final provider = OAuthProvider("apple.com")
      ..addScope('email')
      ..addScope('name');

    // Sign in the user with Firebase.
    return await FirebaseAuth.instance.signInWithPopup(provider);
  }
}
