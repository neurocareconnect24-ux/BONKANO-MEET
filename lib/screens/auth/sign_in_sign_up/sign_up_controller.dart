import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/constants.dart';
import '../../../api/auth_apis.dart';
import 'sign_in_controller.dart';

class SignUpController extends GetxController {
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> signUpformKey = GlobalKey();

  RxBool agree = false.obs;
  RxBool isAcceptedTc = false.obs;
  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  
  // Phone Number Fields
  Rx<Country> pickedPhoneCode = defaultCountry.obs;
  TextEditingController mobileCont = TextEditingController();
  TextEditingController phoneCodeCont = TextEditingController(text: defaultCountry.phoneCode);
  FocusNode mobileFocus = FocusNode();
  FocusNode phoneCodeFocus = FocusNode();

  FocusNode emailFocus = FocusNode();
  FocusNode fisrtNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void onClose() {
    emailCont.dispose();
    firstNameCont.dispose();
    lastNameCont.dispose();
    passwordCont.dispose();
    mobileCont.dispose();
    phoneCodeCont.dispose();
    mobileFocus.dispose();
    phoneCodeFocus.dispose();
    emailFocus.dispose();
    fisrtNameFocus.dispose();
    lastNameFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

  saveForm() async {
    if (isAcceptedTc.value) {
      isLoading(true);
      hideKeyBoardWithoutContext();
      
      final phone = '+${pickedPhoneCode.value.phoneCode}${mobileCont.text.trim()}';
      final cleanPhone = mobileCont.text.trim().replaceAll(RegExp(r'\D'), '');
      final emailStr = emailCont.text.trim().isNotEmpty
          ? emailCont.text.trim()
          : '$cleanPhone@neurocare.com';

      Map<String, dynamic> req = {
        "email": emailStr,
        "first_name": firstNameCont.text.trim(),
        "last_name": lastNameCont.text.trim(),
        "password": passwordCont.text.trim(),
        "mobile": phone,
        "contact_number": phone,
        UserKeys.userType: LoginTypeConst.LOGIN_TYPE_USER,
      };

      await AuthServiceApis.createUser(request: req).then((value) async {
        toast(value.message.toString(), print: true);
        try {
          final SignInController sCont = Get.find();
          sCont.emailCont.text = emailStr;
          sCont.passwordCont.text = passwordCont.text.trim();
          sCont.isNavigateToDashboard(true);
          sCont.userName("${firstNameCont.text.trim()} ${lastNameCont.text.trim()}");
          isLoading(true);
          sCont.saveForm().whenComplete(() => isLoading(false));
        } catch (e) {
          log('E: $e');
          log('SignUp Error: $e');
          toast(locale.value.somethingWentWrong, print: true);
        }
      }).catchError((e) {
        isLoading(false);
        log('SignUp Error: $e');
        toast(locale.value.somethingWentWrong, print: true);
      }).whenComplete(() => isLoading(false));
    } else {
      toast(locale.value.pleaseAcceptTermsAnd);
    }
  }
}
