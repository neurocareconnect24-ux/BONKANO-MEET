import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../components/health_section_card.dart';
import 'sdui_models.dart';
import '../medical_history/medical_history_screen.dart';
import '../allergies/allergy_screen.dart';
import '../treatments/treatment_screen.dart';
import '../vaccinations/vaccination_screen.dart';
import '../lab_results/lab_result_screen.dart';
import '../medical_documents/medical_document_screen.dart';
import '../measurements/measurement_screen.dart';
import '../emergency_contacts/emergency_contact_screen.dart';

Widget buildSduiSection(SduiSection section) {
  switch (section.type) {
    case 'list_card':
      return HealthSectionCard(
        title: section.title,
        subtitle: section.subtitle ?? '',
        icon: _getIconFromString(section.icon),
        iconColor: _hexToColor(section.color),
        itemCount: 0, // Dynamic item count can be fetched from API later
        onTap: () => _handleSduiAction(section.action),
      );
    default:
      return const SizedBox.shrink();
  }
}

IconData _getIconFromString(String? iconName) {
  switch (iconName) {
    case 'history_rounded':
      return Icons.history_rounded;
    case 'warning_amber_rounded':
      return Icons.warning_amber_rounded;
    case 'medication_rounded':
      return Icons.medication_rounded;
    case 'vaccines_rounded':
      return Icons.vaccines_rounded;
    case 'science_rounded':
      return Icons.science_rounded;
    case 'description_rounded':
      return Icons.description_rounded;
    case 'monitor_weight_rounded':
      return Icons.monitor_weight_rounded;
    case 'emergency_rounded':
      return Icons.emergency_rounded;
    default:
      return Icons.info_outline;
  }
}

Color _hexToColor(String? hexString) {
  if (hexString == null || hexString.isEmpty) return Colors.blueAccent;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', '').replaceFirst('0x', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

void _handleSduiAction(SduiAction? action) {
  if (action == null) return;
  if (action.type == 'navigate') {
    switch (action.route) {
      case '/medical-history':
        Get.to(() => MedicalHistoryScreen());
        break;
      case '/allergies':
        Get.to(() => AllergyScreen());
        break;
      case '/treatments':
        Get.to(() => TreatmentScreen());
        break;
      case '/vaccinations':
        Get.to(() => VaccinationScreen());
        break;
      case '/lab-results':
        Get.to(() => LabResultScreen());
        break;
      case '/medical-documents':
        Get.to(() => MedicalDocumentScreen());
        break;
      case '/measurements':
        Get.to(() => MeasurementScreen());
        break;
      case '/emergency-contacts':
        Get.to(() => EmergencyContactScreen());
        break;
    }
  }
}
