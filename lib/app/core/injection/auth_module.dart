import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AuthModule {
  @singleton
  FirebaseAuth get auth => FirebaseAuth.instance;

  @singleton
  GoogleSignIn get googleSignIn => GoogleSignIn.standard();
}
