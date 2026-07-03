import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../health_space/health_space_screen.dart';
import '../../health_space/medical_history/medical_history_screen.dart';
import '../../health_space/allergies/allergy_screen.dart';
import '../../health_space/treatments/treatment_screen.dart';
import '../../health_space/measurements/measurement_screen.dart';

class HealthQuickAccessComponent extends StatelessWidget {
  const HealthQuickAccessComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.value.quickHealthAccess, style: boldTextStyle(size: 16)),
            GestureDetector(
              onTap: () {
                doIfLoggedIn(() {
                  Get.to(() => HealthSpaceScreen());
                });
              },
              child: Text(locale.value.seeAll, style: primaryTextStyle(color: appColorPrimary, size: 13)),
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
        12.height,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _QuickAccessCard(
                icon: Icons.history_rounded,
                color: const Color(0xFF5670CC),
                title: locale.value.medicalHistorySection,
                onTap: () => doIfLoggedIn(() => Get.to(() => MedicalHistoryScreen())),
              ),
              12.width,
              _QuickAccessCard(
                icon: Icons.warning_amber_rounded,
                color: const Color(0xFFF67E7D),
                title: locale.value.allergies,
                onTap: () => doIfLoggedIn(() => Get.to(() => AllergyScreen())),
              ),
              12.width,
              _QuickAccessCard(
                icon: Icons.medication_rounded,
                color: const Color(0xFF56CC85),
                title: locale.value.currentTreatments,
                onTap: () => doIfLoggedIn(() => Get.to(() => TreatmentScreen())),
              ),
              12.width,
              _QuickAccessCard(
                icon: Icons.monitor_weight_rounded,
                color: const Color(0xFF9C27B0),
                title: locale.value.bodyMeasurements,
                onTap: () => doIfLoggedIn(() => Get.to(() => MeasurementScreen())),
              ),
            ],
          ),
        ),
        16.height,
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: boxDecorationDefault(
          color: context.cardColor,
          borderRadius: radius(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: boxDecorationDefault(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            10.height,
            Text(
              title,
              style: primaryTextStyle(size: 11),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
