import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';

class SolveitGoogleSignInClient {
  static final _googleSignIn = (Platform.isIOS || Platform.isMacOS)
      ? GoogleSignIn(
          // clientId: "276422042400-u6qonnk5u0hmkqpktbkhd7tvdph3pqis.apps.googleusercontent.com",
          clientId:
              "276422042400-jh8j4i9r19h777993bh01am2joarfsti.apps.googleusercontent.com",
          scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"],
        )
      : GoogleSignIn(scopes: [
          'email',
          "https://www.googleapis.com/auth/userinfo.profile"
        ]);

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}

const webClientId =
    "185164129893-rjcac9q49uafp436u10mf5e5he1mvm0b.apps.googleusercontent.com";
const androidClientId =
    "185164129893-bu8mjqsn2v0k5lun2adfs47drbhshmp7.apps.googleusercontent.com";
