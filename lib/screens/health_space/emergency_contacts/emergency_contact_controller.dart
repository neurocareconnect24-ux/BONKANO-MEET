import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/health_apis.dart';
import '../../../main.dart';
import '../health_space_controller.dart';
import '../model/health_models.dart';

class EmergencyContactController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<EmergencyContactData> list = <EmergencyContactData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    hasError(false);
    errorMessage('');
    try {
      list(await HealthServiceApis.getEmergencyContacts());
    } catch (e) {
      log('EmergencyContact loadData Error: $e');
      hasError(true);
      errorMessage(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> saveItem(Map<String, dynamic> request) async {
    isLoading(true);
    try {
      await HealthServiceApis.saveEmergencyContact(request: request);
      toast(locale.value.savedSuccessfully);
      await loadData();
      _refreshParent();
      Get.back();
    } catch (e) {
      log('EmergencyContact saveItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> deleteItem(int id) async {
    isLoading(true);
    try {
      await HealthServiceApis.deleteEmergencyContact(id: id);
      toast(locale.value.deletedSuccessfully);
      await loadData();
      _refreshParent();
    } catch (e) {
      log('EmergencyContact deleteItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  void _refreshParent() {
    try {
      Get.find<HealthSpaceController>().loadEmergencyContacts();
    } catch (_) {}
  }
}
