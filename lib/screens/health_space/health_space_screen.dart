import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import 'health_space_controller.dart';
import 'sdui/sdui_builder.dart';

class HealthSpaceScreen extends StatelessWidget {
  HealthSpaceScreen({super.key});

  final HealthSpaceController controller = Get.put(HealthSpaceController());

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      hasLeadingWidget: true,
      appBartitleText: locale.value.myHealthSpace,
      isLoading: controller.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () async => controller.loadAllData(),
        child: Obx(
          () {
            if (controller.isLoading.value && controller.sections.isEmpty) {
              return const SizedBox.shrink(); // Loader handled by AppScaffoldNew
            }
            if (controller.hasError.value) {
              return Center(child: Text(locale.value.somethingWentWrongPleaseTryAgainLater));
            }
            return AnimatedScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 90, left: 16, right: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // SDUI Header card
                if (controller.header.value != null)
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
                              controller.header.value?.title ?? locale.value.myHealthSpace,
                              style: boldTextStyle(color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                        if (controller.header.value?.subtitle != null) ...[
                          8.height,
                          Text(
                            controller.header.value!.subtitle!,
                            style: secondaryTextStyle(color: Colors.white.withValues(alpha: 0.8), size: 13),
                          ),
                        ]
                      ],
                    ),
                  ),
                24.height,

                // SDUI Dynamic Sections
                ...controller.sections.map((section) {
                  return buildSduiSection(section).paddingBottom(12);
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
