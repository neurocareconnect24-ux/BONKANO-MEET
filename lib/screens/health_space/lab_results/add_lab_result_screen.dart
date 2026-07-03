import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'lab_result_controller.dart';

class AddLabResultScreen extends StatelessWidget {
  AddLabResultScreen({super.key});

  final LabResultController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController testNameCont = TextEditingController();
  final TextEditingController dateCont = TextEditingController();
  final TextEditingController resultCont = TextEditingController();
  final TextEditingController normalRangeCont = TextEditingController();
  final TextEditingController unitCont = TextEditingController();
  final TextEditingController labNameCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addLabResult,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test Name
              Text(locale.value.testName, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: testNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.testName),
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

              // Result
              Text(locale.value.result, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: resultCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.result),
              ),
              16.height,

              // Normal Range
              Text(locale.value.normalRange, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: normalRangeCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.normalRange),
              ),
              16.height,

              // Unit
              Text(locale.value.unit, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: unitCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.unit),
              ),
              16.height,

              // Lab Name
              Text(locale.value.labName, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: labNameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.labName),
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
                      'test_name': testNameCont.text.trim(),
                      'date': dateCont.text.trim(),
                      'result': resultCont.text.trim(),
                      'normal_range': normalRangeCont.text.trim(),
                      'unit': unitCont.text.trim(),
                      'lab_name': labNameCont.text.trim(),
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
