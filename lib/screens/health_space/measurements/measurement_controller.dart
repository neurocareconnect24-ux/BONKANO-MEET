import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../api/health_apis.dart';
import '../../../main.dart';
import '../health_space_controller.dart';
import '../model/health_models.dart';

class MeasurementController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxList<MeasurementData> list = <MeasurementData>[].obs;

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
      list(await HealthServiceApis.getMeasurements());
    } catch (e) {
      log('Measurement loadData Error: $e');
      hasError(true);
      errorMessage(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> saveItem(Map<String, dynamic> request) async {
    isLoading(true);
    try {
      await HealthServiceApis.saveMeasurement(request: request);
      toast(locale.value.savedSuccessfully);
      await loadData();
      _refreshParent();
      Get.back();
    } catch (e) {
      log('Measurement saveItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  Future<void> deleteItem(int id) async {
    isLoading(true);
    try {
      await HealthServiceApis.deleteMeasurement(id: id);
      toast(locale.value.deletedSuccessfully);
      await loadData();
      _refreshParent();
    } catch (e) {
      log('Measurement deleteItem Error: $e');
      toast(locale.value.somethingWentWrong);
    }
    isLoading(false);
  }

  void _refreshParent() {
    try {
      Get.find<HealthSpaceController>().loadMeasurements();
    } catch (_) {}
  }
}
