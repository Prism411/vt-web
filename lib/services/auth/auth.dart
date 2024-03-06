import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Substitua 'YOUR_CLIENT_ID' pelo seu Client ID do Google.
final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: '973375648827-aeiuugrmodv6ergklvcdp5o0uipump8k.apps.googleusercontent.com',
);


Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    }
  } catch (error) {
    print("Erro ao fazer login com Google: $error");
    return null;
  }
}
