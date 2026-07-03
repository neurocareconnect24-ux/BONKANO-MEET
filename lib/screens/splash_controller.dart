// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bonkano_meet/screens/home/home_controller.dart';
import 'package:bonkano_meet/screens/walkthrough/walkthrough_screen.dart';
import 'package:bonkano_meet/utils/app_common.dart';
import 'package:bonkano_meet/utils/local_storage.dart';
import '../api/auth_apis.dart';
import '../main.dart';
import '../utils/common_base.dart';
import '../utils/constants.dart';
import 'auth/model/app_configuration_res.dart';
import 'auth/model/login_response.dart';
import 'dashboard/dashboard_screen.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //Get Package Info
    getPackageInfo().then((value) => currentPackageinfo(value));
    getAppConfigurations();
  }

  @override
  void onReady() {
    try {
      final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
      if (getThemeFromLocal is int) {
        toggleThemeMode(themeId: getThemeFromLocal);
      } else {
        toggleThemeMode(themeId: THEME_MODE_LIGHT);
      }
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
    super.onReady();
  }

  ///Get ChooseService List
  getAppConfigurations() {
    AuthServiceApis.getAppConfigurations().then((value) {
      // Si l'API renvoie la devise par défaut (USD/Doller),
      // on force FCFA car le backend NeuroCare est configuré pour le Bénin
      if (value.currency.currencyCode == 'USD' || value.currency.currencyName == 'Doller') {
        appCurrency(Currency());  // Utilise les défauts FCFA
      } else {
        appCurrency(value.currency);
      }
      appConfigs(value);

      ///Navigation logic
      navigationLogic();
    }).onError((error, stackTrace) {
      log('SplashController init Error: $error');
      toast(locale.value.somethingWentWrong);

      ///Navigation logic
      navigationLogic();
    });
  }

  void navigationLogic() {
    if ((getValueFromLocal(SharedPreferenceConst.FIRST_TIME) ?? false) == false) {
      Get.offAll(() => WalkthroughScreen());
    } else if (getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true) {
      try {
        final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
        if (userData != null && userData is Map) {
          isLoggedIn(true);
          loginUserData(UserData.fromJson(Map<String, dynamic>.from(userData)));
        } else {
          log('SplashScreenController: Invalid userData in cache, clearing session');
          isLoggedIn(false);
          removeValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN);
          removeValueFromLocal(SharedPreferenceConst.USER_DATA);
        }
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      } catch (e) {
        log('SplashScreenController Err: $e');
        isLoggedIn(false);
        removeValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN);
        removeValueFromLocal(SharedPreferenceConst.USER_DATA);
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeController());
        }));
      }
    } else {
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        Get.put(HomeController());
      }));
    }
  }
}
