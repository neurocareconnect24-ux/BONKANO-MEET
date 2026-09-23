import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../../utils/colors.dart';

const int kDisclaimerVersion = 1;
const String kDisclaimerKey = 'medical_disclaimer_accepted_v';

class MedicalDisclaimer {
  static Future<void> showDisclaimerIfNeeded(BuildContext context) async {
    bool hasAccepted = getBoolAsync(kDisclaimerKey + kDisclaimerVersion.toString(), defaultValue: false);
    if (!hasAccepted) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false, // Bloque le bouton retour Android
          child: const MedicalDisclaimerDialog(),
        ),
      );
    }
  }
}

class MedicalDisclaimerDialog extends StatefulWidget {
  const MedicalDisclaimerDialog({Key? key}) : super(key: key);

  @override
  State<MedicalDisclaimerDialog> createState() => _MedicalDisclaimerDialogState();
}

class _MedicalDisclaimerDialogState extends State<MedicalDisclaimerDialog> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(locale.value.medicalDisclaimerTitle, style: boldTextStyle(size: 18, color: Colors.red)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(locale.value.medicalDisclaimerLong, style: primaryTextStyle()),
            16.height,
            CheckboxListTile(
              title: Text(locale.value.medicalDisclaimerAccept, style: secondaryTextStyle()),
              value: _accepted,
              activeColor: appColorPrimary,
              onChanged: (val) {
                setState(() => _accepted = val ?? false);
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )
          ],
        ),
      ),
      actions: [
        AppButton(
          text: locale.value.medicalDisclaimerContinue,
          color: _accepted ? appColorPrimary : Colors.grey,
          textColor: Colors.white,
          onTap: _accepted ? () async {
            await setValue(kDisclaimerKey + kDisclaimerVersion.toString(), true);
            Get.back();
          } : null,
        )
      ],
    );
  }
}