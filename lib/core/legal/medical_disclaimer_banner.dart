import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../../utils/colors.dart';

class MedicalDisclaimerBanner extends StatelessWidget {
  const MedicalDisclaimerBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.orange.shade50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 20),
          8.width,
          Expanded(
            child: Text(
              locale.value.medicalDisclaimerShort,
              style: secondaryTextStyle(size: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}