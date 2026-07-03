import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'allergy_controller.dart';

class AddAllergyScreen extends StatelessWidget {
  AddAllergyScreen({super.key});

  final AllergyController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController reactionCont = TextEditingController();
  final TextEditingController diagnosedDateCont = TextEditingController();
  final RxString selectedAllergyType = 'medication'.obs;
  final RxString selectedSeverity = 'mild'.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addAllergy,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              Text(locale.value.name, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.name),
              ),
              16.height,

              // Allergy Type dropdown
              Text(locale.value.allergyType, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedAllergyType.value,
                    decoration: inputDecoration(context, labelText: locale.value.allergyType),
                    items: [
                      DropdownMenuItem(value: 'medication', child: Text(locale.value.medication)),
                      DropdownMenuItem(value: 'food', child: Text(locale.value.food)),
                      DropdownMenuItem(value: 'environment', child: Text(locale.value.environment)),
                    ],
                    onChanged: (v) => selectedAllergyType(v),
                  )),
              16.height,

              // Severity dropdown
              Text(locale.value.severity, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedSeverity.value,
                    decoration: inputDecoration(context, labelText: locale.value.severity),
                    items: [
                      DropdownMenuItem(value: 'mild', child: Text(locale.value.mild)),
                      DropdownMenuItem(value: 'moderate', child: Text(locale.value.moderate)),
                      DropdownMenuItem(value: 'severe', child: Text(locale.value.severe)),
                    ],
                    onChanged: (v) => selectedSeverity(v),
                  )),
              16.height,

              // Reaction
              Text(locale.value.reaction, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: reactionCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.reaction),
              ),
              16.height,

              // Diagnosed Date
              Text(locale.value.diagnosedDate, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: diagnosedDateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.diagnosedDate, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    diagnosedDateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              32.height,

              // Submit
              AppButton(
                width: Get.width,
                text: locale.value.save,
                color: appColorPrimary,
                textStyle: boldTextStyle(color: Colors.white),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    controller.saveItem({
                      'allergy_type': selectedAllergyType.value,
                      'name': nameCont.text.trim(),
                      'severity': selectedSeverity.value,
                      'reaction': reactionCont.text.trim(),
                      'diagnosed_date': diagnosedDateCont.text.trim(),
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(BuildContext context, {String? labelText, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: secondaryTextStyle(),
      enabledBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: BorderSide(color: borderColor.withValues(alpha: 0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: const BorderSide(color: appColorPrimary)),
      errorBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: const BorderSide(color: cancelStatusColor)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: const BorderSide(color: cancelStatusColor)),
      suffixIcon: suffixIcon,
    );
  }
}
