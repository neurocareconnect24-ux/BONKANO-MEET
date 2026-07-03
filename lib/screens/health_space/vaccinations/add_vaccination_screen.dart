import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'vaccination_controller.dart';

class AddVaccinationScreen extends StatelessWidget {
  AddVaccinationScreen({super.key});

  final VaccinationController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController vaccineNameCont = TextEditingController();
  final TextEditingController dateCont = TextEditingController();
  final TextEditingController doseNumberCont = TextEditingController();
  final TextEditingController nextDueDateCont = TextEditingController();
  final TextEditingController administeredByCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addVaccination,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vaccine Name
              Text(locale.value.vaccineName, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: vaccineNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.vaccineName),
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
              16.height,

              // Dose Number
              Text(locale.value.doseNumber, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: doseNumberCont,
                textFieldType: TextFieldType.NUMBER,
                decoration: inputDecoration(context, labelText: locale.value.doseNumber),
              ),
              16.height,

              // Next Due Date
              Text(locale.value.nextDueDate, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: nextDueDateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.nextDueDate, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    nextDueDateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              16.height,

              // Administered By
              Text(locale.value.administeredBy, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: administeredByCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.administeredBy),
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
                      'vaccine_name': vaccineNameCont.text.trim(),
                      'date': dateCont.text.trim(),
                      'dose_number': doseNumberCont.text.trim().toInt(),
                      'next_due_date': nextDueDateCont.text.trim(),
                      'administered_by': administeredByCont.text.trim(),
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
