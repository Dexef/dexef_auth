import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';

GoogleSignInAuthentication? googleAuth;
GoogleSignIn googleSignIn = GoogleSignIn();
GoogleSignIn googleSignInIOS = GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);
GoogleSignInAccount? googleSignInAccount;

Future<AuthCredential> DefaultSignInGoogle() async {
  if(Platform.isIOS){
    googleSignInAccount = await googleSignInIOS.signIn();
  }else{
    googleSignInAccount = await googleSignIn.signIn();
  }
  googleAuth = await googleSignInAccount?.authentication;
  AuthCredential? credentialGoogle = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  debugPrint('==============login with google =============${credentialGoogle.token}');
  debugPrint('==============login with google =============${credentialGoogle.accessToken}');
  return credentialGoogle;
}

