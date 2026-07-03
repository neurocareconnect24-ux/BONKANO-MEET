import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/health_apis.dart';
import 'model/health_models.dart';

class HealthSpaceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  RxList<MedicalHistoryData> medicalHistoryList = <MedicalHistoryData>[].obs;
  RxList<AllergyData> allergyList = <AllergyData>[].obs;
  RxList<TreatmentData> treatmentList = <TreatmentData>[].obs;
  RxList<VaccinationData> vaccinationList = <VaccinationData>[].obs;
  RxList<LabResultData> labResultList = <LabResultData>[].obs;
  RxList<MedicalDocumentData> medicalDocumentList = <MedicalDocumentData>[].obs;
  RxList<MeasurementData> measurementList = <MeasurementData>[].obs;
  RxList<EmergencyContactData> emergencyContactList = <EmergencyContactData>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading(true);
    hasError(false);
    await Future.wait([
      loadMedicalHistory(),
      loadAllergies(),
      loadTreatments(),
      loadVaccinations(),
      loadLabResults(),
      loadMedicalDocuments(),
      loadMeasurements(),
      loadEmergencyContacts(),
    ]).catchError((e) {
      log('HealthSpace loadAllData Error: $e');
      hasError(true);
      return <void>[];
    });
    isLoading(false);
  }

  Future<void> loadMedicalHistory() async {
    try {
      medicalHistoryList(await HealthServiceApis.getMedicalHistory());
    } catch (e) {
      log('loadMedicalHistory Error: $e');
    }
  }

  Future<void> loadAllergies() async {
    try {
      allergyList(await HealthServiceApis.getAllergies());
    } catch (e) {
      log('loadAllergies Error: $e');
    }
  }

  Future<void> loadTreatments() async {
    try {
      treatmentList(await HealthServiceApis.getTreatments());
    } catch (e) {
      log('loadTreatments Error: $e');
    }
  }

  Future<void> loadVaccinations() async {
    try {
      vaccinationList(await HealthServiceApis.getVaccinations());
    } catch (e) {
      log('loadVaccinations Error: $e');
    }
  }

  Future<void> loadLabResults() async {
    try {
      labResultList(await HealthServiceApis.getLabResults());
    } catch (e) {
      log('loadLabResults Error: $e');
    }
  }

  Future<void> loadMedicalDocuments() async {
    try {
      medicalDocumentList(await HealthServiceApis.getMedicalDocuments());
    } catch (e) {
      log('loadMedicalDocuments Error: $e');
    }
  }

  Future<void> loadMeasurements() async {
    try {
      measurementList(await HealthServiceApis.getMeasurements());
    } catch (e) {
      log('loadMeasurements Error: $e');
    }
  }

  Future<void> loadEmergencyContacts() async {
    try {
      emergencyContactList(await HealthServiceApis.getEmergencyContacts());
    } catch (e) {
      log('loadEmergencyContacts Error: $e');
    }
  }
}
