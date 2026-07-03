import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/health_apis.dart';
import '../../../main.dart';
import '../health_space_controller.dart';
import '../model/health_models.dart';

class LabResultController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<LabResultData> list = <LabResultData>[].obs;

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
      list(await HealthServiceApis.getLabResults());
    } catch (e) {
      log('LabResult loadData Error: $e');
      hasError(true);
      errorMessage(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> saveItem(Map<String, dynamic> request) async {
    isLoading(true);
    try {
      await HealthServiceApis.saveLabResult(request: request);
      toast(locale.value.savedSuccessfully);
      await loadData();
      _refreshParent();
      Get.back();
    } catch (e) {
      log('LabResult saveItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> deleteItem(int id) async {
    isLoading(true);
    try {
      await HealthServiceApis.deleteLabResult(id: id);
      toast(locale.value.deletedSuccessfully);
      await loadData();
      _refreshParent();
    } catch (e) {
      log('LabResult deleteItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  void _refreshParent() {
    try {
      Get.find<HealthSpaceController>().loadLabResults();
    } catch (_) {}
  }
}
