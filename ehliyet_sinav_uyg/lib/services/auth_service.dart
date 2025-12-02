import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Delete user account
  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }

    try {
      if (!user.isAnonymous) {
        await _firestore.collection('users').doc(user.uid).delete();
      }
      await user.delete();
      await signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (user.providerData.any((info) => info.providerId == GoogleAuthProvider.PROVIDER_ID)) {
          try {
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
            if (googleUser == null) {
              throw Exception("Account deletion cancelled: Re-authentication failed.");
            }
            
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
            final AuthCredential credential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
            );

            await user.reauthenticateWithCredential(credential);
            
            await user.delete();
            await signOut();
          } catch (reauthError) {
            throw Exception("Failed to re-authenticate. Could not delete account.");
          }
        } else {
          throw Exception("Re-authentication required. Please sign in again to delete your account.");
        }
      } else {
        throw Exception("An error occurred while deleting your account: ${e.message}");
      }
    } catch (e) {
      throw Exception("An unexpected error occurred during account deletion.");
    }
  }
}
