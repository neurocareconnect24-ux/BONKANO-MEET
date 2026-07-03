import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import 'components/health_section_card.dart';
import 'health_space_controller.dart';
import 'medical_history/medical_history_screen.dart';
import 'allergies/allergy_screen.dart';
import 'treatments/treatment_screen.dart';
import 'vaccinations/vaccination_screen.dart';
import 'lab_results/lab_result_screen.dart';
import 'medical_documents/medical_document_screen.dart';
import 'measurements/measurement_screen.dart';
import 'emergency_contacts/emergency_contact_screen.dart';

class HealthSpaceScreen extends StatelessWidget {
  HealthSpaceScreen({super.key});

  final HealthSpaceController controller = Get.put(HealthSpaceController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: false,
      appBartitleText: locale.value.myHealthSpace,
      isLoading: controller.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () async => controller.loadAllData(),
        child: Obx(
          () => AnimatedScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 90, left: 16, right: 16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: boxDecorationDefault(
                  color: appColorPrimary,
                  borderRadius: radius(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                        12.width,
                        Text(
                          locale.value.myHealthSpace,
                          style: boldTextStyle(color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    8.height,
                    Text(
                      _getHealthSummary(),
                      style: secondaryTextStyle(color: Colors.white.withValues(alpha: 0.8), size: 13),
                    ),
                  ],
                ),
              ),
              24.height,

              // Section cards
              HealthSectionCard(
                title: locale.value.medicalHistorySection,
                subtitle: '${controller.medicalHistoryList.length} ${locale.value.medicalHistorySection.toLowerCase()}',
                icon: Icons.history_rounded,
                iconColor: const Color(0xFF5670CC),
                itemCount: controller.medicalHistoryList.length,
                onTap: () => Get.to(() => MedicalHistoryScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.allergies,
                subtitle: '${controller.allergyList.length} ${locale.value.allergies.toLowerCase()}',
                icon: Icons.warning_amber_rounded,
                iconColor: const Color(0xFFF67E7D),
                itemCount: controller.allergyList.length,
                onTap: () => Get.to(() => AllergyScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.currentTreatments,
                subtitle: '${controller.treatmentList.where((t) => t.isActive).length} ${locale.value.activeTreatment.toLowerCase()}',
                icon: Icons.medication_rounded,
                iconColor: const Color(0xFF56CC85),
                itemCount: controller.treatmentList.length,
                onTap: () => Get.to(() => TreatmentScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.vaccinations,
                subtitle: '${controller.vaccinationList.length} ${locale.value.vaccinations.toLowerCase()}',
                icon: Icons.vaccines_rounded,
                iconColor: const Color(0xFFFFCE70),
                itemCount: controller.vaccinationList.length,
                onTap: () => Get.to(() => VaccinationScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.labResults,
                subtitle: '${controller.labResultList.length} ${locale.value.labResults.toLowerCase()}',
                icon: Icons.science_rounded,
                iconColor: const Color(0xFF48D0B8),
                itemCount: controller.labResultList.length,
                onTap: () => Get.to(() => LabResultScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.medicalDocuments,
                subtitle: '${controller.medicalDocumentList.length} ${locale.value.medicalDocuments.toLowerCase()}',
                icon: Icons.description_rounded,
                iconColor: const Color(0xFFE56F0F),
                itemCount: controller.medicalDocumentList.length,
                onTap: () => Get.to(() => MedicalDocumentScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.bodyMeasurements,
                subtitle: _getLatestBmi(),
                icon: Icons.monitor_weight_rounded,
                iconColor: const Color(0xFF9C27B0),
                itemCount: controller.measurementList.length,
                onTap: () => Get.to(() => MeasurementScreen()),
              ),
              12.height,

              HealthSectionCard(
                title: locale.value.emergencyContacts,
                subtitle: '${controller.emergencyContactList.length} ${locale.value.emergencyContacts.toLowerCase()}',
                icon: Icons.emergency_rounded,
                iconColor: const Color(0xFFF04336),
                itemCount: controller.emergencyContactList.length,
                onTap: () => Get.to(() => EmergencyContactScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getHealthSummary() {
    int totalItems = controller.medicalHistoryList.length +
        controller.allergyList.length +
        controller.treatmentList.length +
        controller.vaccinationList.length +
        controller.labResultList.length +
        controller.medicalDocumentList.length +
        controller.measurementList.length +
        controller.emergencyContactList.length;
    if (totalItems == 0) return locale.value.noDataYet;
    return '$totalItems ${locale.value.medicalDocuments.toLowerCase()}';
  }

  String _getLatestBmi() {
    if (controller.measurementList.isNotEmpty) {
      final latest = controller.measurementList.last;
      if (latest.bmi > 0) {
        return '${locale.value.bmi}: ${latest.bmi.toStringAsFixed(1)}';
      }
    }
    return locale.value.noDataYet;
  }
}
