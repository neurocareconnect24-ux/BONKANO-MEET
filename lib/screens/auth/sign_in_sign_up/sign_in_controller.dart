// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/push_notification_service.dart';
import '../../dashboard/dashboard_controller.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../home/home_controller.dart';
import '../model/login_response.dart';
import '../../../api/auth_apis.dart';
import '../../../utils/app_common.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../utils/local_storage.dart';
import '../services/social_logins.dart';

class SignInController extends GetxController {
  RxBool isNavigateToDashboard = false.obs;
  final GlobalKey<FormState> signInformKey = GlobalKey();

  RxBool isRememberMe = true.obs;
  RxBool isLoading = false.obs;
  RxString userName = "".obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  void toggleSwitch() {
    isRememberMe.value = !isRememberMe.value;
  }

  @override
  void onClose() {
    emailCont.dispose();
    passwordCont.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    if (Get.arguments is bool) {
      isNavigateToDashboard(Get.arguments == true);
    }

    if (appConfigs.value.isDummyCredential != 1) {
      emailCont.text = '';
      passwordCont.text = '';
      isRememberMe.value = false;
    } else {
      emailCont.text = Constants.DEFAULT_EMAIL;
      passwordCont.text = Constants.DEFAULT_PASS;
    }

    final userIsRemeberMe = getValueFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    final userNameFromLocal = getValueFromLocal(SharedPreferenceConst.USER_NAME);
    if (userNameFromLocal is String) {
      userName(userNameFromLocal);
    }
    if (userIsRemeberMe == true) {
      final userEmail = getValueFromLocal(SharedPreferenceConst.USER_EMAIL);
      if (userEmail is String) {
        emailCont.text = userEmail;
      }
      final userPASSWORD = getValueFromLocal(SharedPreferenceConst.USER_PASSWORD);
      if (userPASSWORD is String) {
        passwordCont.text = userPASSWORD;
      }
    }
    super.onInit();
  }

  /// Retourne true si l'identifiant est un numéro de téléphone (pas un email)
  bool _isPhoneNumber(String identifier) => !identifier.contains('@');

  Future<void> saveForm() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    final identifier = emailCont.text.trim();
    final isPhone = _isPhoneNumber(identifier);

    Map<String, dynamic> req = {
      if (isPhone) 'mobile': identifier else 'email': identifier,
      'password': passwordCont.text.trim(),
      UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
    };

    await AuthServiceApis.loginUser(request: req).then((value) async {
      handleLoginResponse(loginResponse: value);
    }).catchError((e) {
      isLoading(false);
      log('SignIn Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
    });
  }

  googleSignIn() async {
    isLoading(true);
    await GoogleSignInAuthService.signInWithGoogle().then((value) async {
      Map request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_GOOGLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true).then((value) async {
        handleLoginResponse(loginResponse: value, isSocialLogin: true);
      }).catchError((e) {
        isLoading(false);
        log('SignIn Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
      });
    }).catchError((e) {
      isLoading(false);
      log('SignIn Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
    });
  }

  appleSignIn() async {
    isLoading(true);
    await GoogleSignInAuthService.signInWithApple().then((value) async {
      Map request = {
        UserKeys.contactNumber: value.mobile,
        UserKeys.email: value.email,
        UserKeys.firstName: value.firstName,
        UserKeys.lastName: value.lastName,
        UserKeys.username: value.userName,
        UserKeys.profileImage: value.profileImage,
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
        UserKeys.loginType: LoginTypeConst.LOGIN_TYPE_APPLE,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await AuthServiceApis.loginUser(request: request, isSocialLogin: true).then((value) async {
        handleLoginResponse(loginResponse: value, isSocialLogin: true);
      }).catchError((e) {
        isLoading(false);
        log('SignIn Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
      });
    }).catchError((e) {
      isLoading(false);
      log('SignIn Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
    });
  }

  void handleLoginResponse({required UserResponse loginResponse, bool isSocialLogin = false}) {
    if (loginResponse.userData.userRole.contains(LoginTypeConst.LOGIN_TYPE_USER)) {
      loginUserData(loginResponse.userData);
      loginUserData.value.isSocialLogin = isSocialLogin;
      setValueToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      // Note: Le mot de passe n'est plus stocké en clair pour des raisons de sécurité.
      // Le token API est utilisé pour la ré-authentification.
      isLoggedIn(true);
      setValueToLocal(SharedPreferenceConst.IS_LOGGED_IN, true);
      setValueToLocal(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);

      isLoading(false);

      try {
        PushNotificationService().registerFCMAndTopics();
      } catch (e) {
        log('FCM registration skipped: $e');
      }

      if (isNavigateToDashboard.value) {
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      } else {
        try {
          DashboardController dashboardController = Get.find();
          dashboardController.reloadBottomTabs();
        } catch (e) {
          log('dashboardController Get.find E: $e');
        }
        try {
          HomeController homeScreenController = Get.find();
          homeScreenController.init();
        } catch (e) {
          log('homeScreenController Get.find E: $e');
        }
        Get.back(result: true);
      }
    } else {
      isLoading(false);
      toast(locale.value.sorryUserCannotSignin);
    }
  }
}
