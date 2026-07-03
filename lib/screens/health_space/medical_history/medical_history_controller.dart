import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/health_apis.dart';
import '../../../main.dart';
import '../health_space_controller.dart';
import '../model/health_models.dart';

class MedicalHistoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<MedicalHistoryData> list = <MedicalHistoryData>[].obs;

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
      list(await HealthServiceApis.getMedicalHistory());
    } catch (e) {
      log('MedicalHistory loadData Error: $e');
      hasError(true);
      errorMessage(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> saveItem(Map<String, dynamic> request) async {
    isLoading(true);
    try {
      await HealthServiceApis.saveMedicalHistory(request: request);
      toast(locale.value.savedSuccessfully);
      await loadData();
      _refreshParent();
      Get.back();
    } catch (e) {
      log('MedicalHistory saveItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> deleteItem(int id) async {
    isLoading(true);
    try {
      await HealthServiceApis.deleteMedicalHistory(id: id);
      toast(locale.value.deletedSuccessfully);
      await loadData();
      _refreshParent();
    } catch (e) {
      log('MedicalHistory deleteItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  void _refreshParent() {
    try {
      Get.find<HealthSpaceController>().loadMedicalHistory();
    } catch (_) {}
  }
}
