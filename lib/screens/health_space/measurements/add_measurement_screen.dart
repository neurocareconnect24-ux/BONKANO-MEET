import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'measurement_controller.dart';

class AddMeasurementScreen extends StatelessWidget {
  AddMeasurementScreen({super.key});

  final MeasurementController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateCont = TextEditingController();
  final TextEditingController heightCont = TextEditingController();
  final TextEditingController weightCont = TextEditingController();
  final TextEditingController systolicCont = TextEditingController();
  final TextEditingController diastolicCont = TextEditingController();
  final TextEditingController bloodSugarCont = TextEditingController();

  final RxString bmiDisplay = ''.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addMeasurement,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Text(locale.value.date, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: dateCont,
                textFieldType: TextFieldType.OTHER,
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

              // Height (cm)
              Text(locale.value.heightCm, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: heightCont,
                textFieldType: TextFieldType.OTHER,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: inputDecoration(context, labelText: locale.value.heightCm),
                onChanged: (_) => _calculateBmi(),
              ),
              16.height,

              // Weight (kg)
              Text(locale.value.weightKg, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: weightCont,
                textFieldType: TextFieldType.OTHER,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: inputDecoration(context, labelText: locale.value.weightKg),
                onChanged: (_) => _calculateBmi(),
              ),
              16.height,

              // BMI (auto-calculated, read-only)
              Obx(() => bmiDisplay.value.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.value.bmi, style: boldTextStyle(size: 14)),
                        8.height,
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: boxDecorationDefault(
                            color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                            borderRadius: radius(12),
                          ),
                          child: Text(bmiDisplay.value, style: boldTextStyle(size: 14, color: const Color(0xFF9C27B0))),
                        ),
                        16.height,
                      ],
                    )
                  : const SizedBox.shrink()),

              // Blood Pressure header
              Text(locale.value.bloodPressure, style: boldTextStyle(size: 14)),
              8.height,
              Row(
                children: [
                  // Systolic
                  Expanded(
                    child: AppTextField(
                      controller: systolicCont,
                      textFieldType: TextFieldType.OTHER,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(context, labelText: locale.value.systolic),
                    ),
                  ),
                  16.width,
                  // Diastolic
                  Expanded(
                    child: AppTextField(
                      controller: diastolicCont,
                      textFieldType: TextFieldType.OTHER,
                      keyboardType: TextInputType.number,
                      decoration: inputDecoration(context, labelText: locale.value.diastolic),
                    ),
                  ),
                ],
              ),
              16.height,

              // Blood Sugar
              Text(locale.value.bloodSugar, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: bloodSugarCont,
                textFieldType: TextFieldType.OTHER,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: inputDecoration(context, labelText: locale.value.bloodSugar),
              ),
              32.height,

              // Submit
              AppButton(
                width: Get.width,
                text: locale.value.save,
                color: appColorPrimary,
                textStyle: boldTextStyle(color: Colors.white),
                onTap: () {
                  final double h = double.tryParse(heightCont.text.trim()) ?? 0;
                  final double w = double.tryParse(weightCont.text.trim()) ?? 0;
                  double bmi = 0;
                  if (h > 0 && w > 0) {
                    bmi = w / ((h / 100) * (h / 100));
                  }

                  if (dateCont.text.trim().isEmpty) {
                    toast(locale.value.dateIsRequired);
                    return;
                  }

                  if (h == 0 && w == 0 && systolicCont.text.trim().isEmpty && diastolicCont.text.trim().isEmpty && bloodSugarCont.text.trim().isEmpty) {
                    toast(locale.value.pleaseEnterAtLeastOneMeasure);
                    return;
                  }

                  // Numeric range validation
                  if (h > 0 && (h < 30 || h > 300)) {
                    toast(locale.value.invalidHeight);
                    return;
                  }
                  if (w > 0 && (w < 1 || w > 500)) {
                    toast(locale.value.invalidWeight);
                    return;
                  }
                  final int sys = int.tryParse(systolicCont.text.trim()) ?? 0;
                  final int dia = int.tryParse(diastolicCont.text.trim()) ?? 0;
                  if (sys > 0 && (sys < 40 || sys > 300)) {
                    toast(locale.value.invalidBloodPressure);
                    return;
                  }
                  if (dia > 0 && (dia < 20 || dia > 200)) {
                    toast(locale.value.invalidBloodPressure);
                    return;
                  }
                  final double bs = double.tryParse(bloodSugarCont.text.trim()) ?? 0;
                  if (bs > 0 && (bs < 20 || bs > 900)) {
                    toast(locale.value.invalidBloodSugar);
                    return;
                  }

                  controller.saveItem({
                    'date': dateCont.text.trim(),
                    'height': h,
                    'weight': w,
                    'bmi': double.parse(bmi.toStringAsFixed(1)),
                    'systolic': int.tryParse(systolicCont.text.trim()) ?? 0,
                    'diastolic': int.tryParse(diastolicCont.text.trim()) ?? 0,
                    'blood_sugar': double.tryParse(bloodSugarCont.text.trim()) ?? 0,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateBmi() {
    final double h = double.tryParse(heightCont.text.trim()) ?? 0;
    final double w = double.tryParse(weightCont.text.trim()) ?? 0;
    if (h > 0 && w > 0) {
      final double bmi = w / ((h / 100) * (h / 100));
      bmiDisplay(bmi.toStringAsFixed(1));
    } else {
      bmiDisplay('');
    }
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
