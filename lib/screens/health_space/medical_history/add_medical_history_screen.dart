import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'medical_history_controller.dart';

class AddMedicalHistoryScreen extends StatelessWidget {
  AddMedicalHistoryScreen({super.key});

  final MedicalHistoryController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController descCont = TextEditingController();
  final TextEditingController dateCont = TextEditingController();
  final RxString selectedType = 'illness'.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addMedicalHistory,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type dropdown
              Text(locale.value.type, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedType.value,
                    decoration: inputDecoration(context, labelText: locale.value.type),
                    items: [
                      DropdownMenuItem(value: 'illness', child: Text(locale.value.illness)),
                      DropdownMenuItem(value: 'surgery', child: Text(locale.value.surgery)),
                      DropdownMenuItem(value: 'family_history', child: Text(locale.value.familyHistory)),
                    ],
                    onChanged: (v) => selectedType(v),
                  )),
              16.height,

              // Title
              Text(locale.value.title, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: titleCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.title),
              ),
              16.height,

              // Description
              Text(locale.value.description, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: descCont,
                textFieldType: TextFieldType.MULTILINE,
                minLines: 3,
                decoration: inputDecoration(context, labelText: locale.value.description),
              ),
              16.height,

              // Date
              Text(locale.value.date, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: dateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.date, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
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
                      'type': selectedType.value,
                      'title': titleCont.text.trim(),
                      'description': descCont.text.trim(),
                      'date': dateCont.text.trim(),
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
