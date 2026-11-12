import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../model/login_response.dart';

//region FIREBASE AUTH
final FirebaseAuth auth = FirebaseAuth.instance;
//endregion

class GoogleSignInAuthService {
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<UserData> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await auth.signInWithCredential(credential);
      final User user = authResult.user!;
      assert(!user.isAnonymous);

      final User currentUser = auth.currentUser!;
      assert(user.uid == currentUser.uid);

      log('CURRENTUSER: $currentUser');

      await googleSignIn.signOut();

      String firstName = '';
      String lastName = '';
      if (currentUser.displayName.validate().split(' ').isNotEmpty) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      /// Create a temporary request to send
      UserData tempUserData = UserData()
        ..mobile = currentUser.phoneNumber.validate()
        ..email = currentUser.email.validate()
        ..firstName = firstName.validate()
        ..lastName = lastName.validate()
        ..profileImage = currentUser.photoURL.validate()
        ..loginType = LoginTypeConst.LOGIN_TYPE_GOOGLE
        ..userName = currentUser.displayName.validate();

      return tempUserData;
    } else {
      throw locale.value.userNotCreated;
    }
  }

  // region Apple Sign
  static Future<UserData> signInWithApple() async {
    final bool isAvailable = await SignInWithApple.isAvailable();
    if (!isAvailable) {
      throw locale.value.appleSigninIsNot;
    }

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String appleUserId = credential.userIdentifier.validate();
      if (appleUserId.isEmpty) {
        throw locale.value.signInFailed;
      }

      // Apple returns email only on the very first authorization.
      // However, it can also be extracted from the JWT identityToken.
      String email = credential.email.validate();

      if (email.isEmpty && credential.identityToken != null) {
        try {
          final parts = credential.identityToken!.split('.');
          if (parts.length >= 2) {
            final normalized = base64Url.normalize(parts[1]);
            final payload = utf8.decode(base64Url.decode(normalized));
            final data = jsonDecode(payload);
            if (data is Map && data['email'] != null) {
              email = data['email'].toString().trim();
            }
          }
        } catch (e) {
          log('Apple identityToken decode error: $e');
        }
      }

      // Check local cache for previously saved email for this Apple User ID
      final String cacheEmailKey = 'apple_email_$appleUserId';
      if (email.isNotEmpty) {
        setValueToLocal(cacheEmailKey, email);
      } else {
        email = getValueFromLocal(cacheEmailKey) ?? '';
      }

      // Final fallback if email is still empty
      if (email.isEmpty) {
        email = '$appleUserId@privaterelay.appleid.com';
      }

      // Apple returns fullName only on the first authorization.
      String firstName = credential.givenName.validate();
      String lastName = credential.familyName.validate();

      final String cacheFirstKey = 'apple_first_name_$appleUserId';
      final String cacheLastKey = 'apple_last_name_$appleUserId';

      if (firstName.isNotEmpty) {
        setValueToLocal(cacheFirstKey, firstName);
      } else {
        firstName = getValueFromLocal(cacheFirstKey) ?? '';
      }

      if (lastName.isNotEmpty) {
        setValueToLocal(cacheLastKey, lastName);
      } else {
        lastName = getValueFromLocal(cacheLastKey) ?? '';
      }

      if (firstName.isEmpty && lastName.isEmpty) {
        firstName = 'Utilisateur';
        lastName = 'Apple';
      }

      String fullName = '$firstName $lastName'.trim();

      UserData tempUserData = UserData()
        ..mobile = ''
        ..email = email
        ..firstName = firstName
        ..lastName = lastName
        ..profileImage = ''
        ..loginType = LoginTypeConst.LOGIN_TYPE_APPLE
        ..userName = fullName;

      return tempUserData;
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw locale.value.userCancelled;
      }
      throw "${locale.value.signInFailed}: ${e.message}";
    } catch (e) {
      log('Apple Sign In error: $e');
      rethrow;
    }
  }
}
