import 'dart:convert';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'sdui/sdui_models.dart';
import '../../main.dart';

class HealthSpaceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  RxList<SduiSection> sections = <SduiSection>[].obs;
  Rx<SduiHeader?> header = Rx<SduiHeader?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading(true);
    hasError(false);
    try {
      // Simulate API call to /api/health-tabs
      await Future.delayed(const Duration(seconds: 1));
      
      String jsonResponse = '''
      {
        "header": {
          "title": "Mon Espace Santé",
          "subtitle": "Synthèse de votre dossier",
          "icon": "favorite_rounded"
        },
        "sections": [
          {
            "id": "medical_history",
            "title": "Antécédents",
            "subtitle": "Vos antécédents médicaux",
            "type": "list_card",
            "icon": "history_rounded",
            "color": "0xFF5670CC",
            "action": {
              "type": "navigate",
              "route": "/medical-history"
            }
          },
          {
            "id": "allergies",
            "title": "Allergies",
            "subtitle": "Vos allergies connues",
            "type": "list_card",
            "icon": "warning_amber_rounded",
            "color": "0xFFF67E7D",
            "action": {
              "type": "navigate",
              "route": "/allergies"
            }
          },
          {
            "id": "treatments",
            "title": "Traitements",
            "subtitle": "Traitements en cours",
            "type": "list_card",
            "icon": "medication_rounded",
            "color": "0xFF56CC85",
            "action": {
              "type": "navigate",
              "route": "/treatments"
            }
          },
          {
            "id": "vaccinations",
            "title": "Vaccinations",
            "subtitle": "Carnet de vaccination",
            "type": "list_card",
            "icon": "vaccines_rounded",
            "color": "0xFFFFCE70",
            "action": {
              "type": "navigate",
              "route": "/vaccinations"
            }
          },
          {
            "id": "lab_results",
            "title": "Résultats d'analyse",
            "subtitle": "Examens biologiques",
            "type": "list_card",
            "icon": "science_rounded",
            "color": "0xFF48D0B8",
            "action": {
              "type": "navigate",
              "route": "/lab-results"
            }
          },
          {
            "id": "medical_documents",
            "title": "Documents médicaux",
            "subtitle": "Ordonnances, certificats...",
            "type": "list_card",
            "icon": "description_rounded",
            "color": "0xFFE56F0F",
            "action": {
              "type": "navigate",
              "route": "/medical-documents"
            }
          },
          {
            "id": "measurements",
            "title": "Mesures & Constantes",
            "subtitle": "Suivi de vos mesures",
            "type": "list_card",
            "icon": "monitor_weight_rounded",
            "color": "0xFF9C27B0",
            "action": {
              "type": "navigate",
              "route": "/measurements"
            }
          },
          {
            "id": "emergency_contacts",
            "title": "Contacts d'urgence",
            "subtitle": "Personnes à prévenir",
            "type": "list_card",
            "icon": "emergency_rounded",
            "color": "0xFFF04336",
            "action": {
              "type": "navigate",
              "route": "/emergency-contacts"
            }
          }
        ]
      }
      ''';

      final Map<String, dynamic> parsedJson = jsonDecode(jsonResponse);
      final sduiResponse = SduiResponse.fromJson(parsedJson);

      header.value = sduiResponse.header;
      sections.assignAll(sduiResponse.sections);

    } catch (e) {
      log('HealthSpace loadAllData Error: $e');
      hasError(true);
    }
    isLoading(false);
  }

  // Fallback methods for backward compatibility with sub-screens
  Future<void> loadMedicalHistory() async => loadAllData();
  Future<void> loadAllergies() async => loadAllData();
  Future<void> loadTreatments() async => loadAllData();
  Future<void> loadVaccinations() async => loadAllData();
  Future<void> loadLabResults() async => loadAllData();
  Future<void> loadMedicalDocuments() async => loadAllData();
  Future<void> loadMeasurements() async => loadAllData();
  Future<void> loadEmergencyContacts() async => loadAllData();
}
