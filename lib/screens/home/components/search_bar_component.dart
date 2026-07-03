import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../doctor/doctor_list_screen.dart';

class SearchBarComponent extends StatelessWidget {
  const SearchBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Get.to(() => DoctorsListScreen());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: radius(16),
            border: Border.all(color: borderColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: secondaryTextColor.withValues(alpha: 0.6), size: 22),
              12.width,
              Expanded(
                child: Text(
                  locale.value.searchDoctorOrService,
                  style: secondaryTextStyle(size: 14, color: secondaryTextColor.withValues(alpha: 0.6)),
                ),
              ),
              Icon(Icons.tune_rounded, color: secondaryTextColor.withValues(alpha: 0.4), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
