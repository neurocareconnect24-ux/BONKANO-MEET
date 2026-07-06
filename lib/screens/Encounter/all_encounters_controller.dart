import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/core_apis.dart';
import '../../utils/app_common.dart';
import 'model/encounter_list_model.dart';

class AllEncountersController extends GetxController {
  RxList<EncounterElement> combinedList = RxList();
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  @override
  void onReady() {
    getAllEncounters();
    super.onReady();
  }

  Future<void> getAllEncounters({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    try {
      // "Actes Médicaux" are real medical records (patient_encounters), not
      // appointments — an appointment being checked out doesn't mean a
      // medical record exists for it. Only the encounters endpoint should
      // ever feed this screen.
      List<EncounterElement> encounters = [];
      await CoreServiceApis.getEncounterList(
        page: page.value,
        patientId: loginUserData.value.id,
        encounterList: encounters,
        perPage: 50,
      );

      encounters.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a.encounterDate) ?? DateTime(1900);
        DateTime dateB = DateTime.tryParse(b.encounterDate) ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });

      if (page.value == 1) combinedList.clear();
      combinedList.addAll(encounters);

      isLastPage(encounters.length < 50);
    } catch (e) {
      log("getAllEncounters Err : $e");
    } finally {
      isLoading(false);
    }
  }
}
