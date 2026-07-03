import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'treatment_controller.dart';
import '../../../services/notification_service.dart';

class AddTreatmentScreen extends StatelessWidget {
  AddTreatmentScreen({super.key});

  final TreatmentController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController dosageCont = TextEditingController();
  final TextEditingController frequencyCont = TextEditingController();
  final TextEditingController startDateCont = TextEditingController();
  final TextEditingController endDateCont = TextEditingController();
  final TextEditingController prescribedByCont = TextEditingController();
  final RxBool isActive = false.obs;
  final RxBool enableReminder = false.obs;
  final Rx<TimeOfDay?> reminderTime = Rx<TimeOfDay?>(null);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addTreatment,
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

              // Dosage
              Text(locale.value.dosage, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: dosageCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.dosage),
              ),
              16.height,

              // Frequency
              Text(locale.value.frequency, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: frequencyCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.frequency),
              ),
              16.height,

              // Start Date
              Text(locale.value.startDate, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: startDateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.startDate, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    startDateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              16.height,

              // End Date
              Text(locale.value.endDate, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: endDateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.endDate, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    endDateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              16.height,

              // Prescribed By
              Text(locale.value.prescribedBy, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: prescribedByCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.prescribedBy),
              ),
              16.height,

              // Is Active
              Obx(() => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(locale.value.activeTreatment, style: boldTextStyle(size: 14)),
                    value: isActive.value,
                    activeColor: appColorPrimary,
                    onChanged: (v) => isActive(v),
                  )),
              
              // Enable Reminder (Pilulier)
              Obx(() => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Activer le rappel (Pilulier)", style: boldTextStyle(size: 14)),
                    value: enableReminder.value,
                    activeColor: appColorPrimary,
                    onChanged: (v) {
                      enableReminder(v);
                      if (v && reminderTime.value == null) {
                        reminderTime(const TimeOfDay(hour: 8, minute: 0));
                      }
                    },
                  )),
                  
              Obx(() => enableReminder.value 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text("Heure du rappel", style: boldTextStyle(size: 14)),
                        8.height,
                        AppTextField(
                          controller: TextEditingController(text: reminderTime.value != null ? reminderTime.value!.format(context) : ""),
                          textFieldType: TextFieldType.NAME,
                          readOnly: true,
                          decoration: inputDecoration(context, labelText: "Heure du rappel", suffixIcon: const Icon(Icons.access_time, size: 18)),
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: reminderTime.value ?? const TimeOfDay(hour: 8, minute: 0),
                            );
                            if (picked != null) {
                              reminderTime(picked);
                            }
                          },
                        ),
                        16.height,
                      ],
                    )
                  : const SizedBox()),
                  
              32.height,

              // Submit
              AppButton(
                width: Get.width,
                text: locale.value.save,
                color: appColorPrimary,
                textStyle: boldTextStyle(color: Colors.white),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (enableReminder.value && reminderTime.value != null) {
                       NotificationService().scheduleDailyTreatmentReminder(
                         id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                         title: "Rappel de médicament",
                         body: "Il est l'heure de prendre : ${nameCont.text.trim()} (${dosageCont.text.trim()})",
                         hour: reminderTime.value!.hour,
                         minute: reminderTime.value!.minute,
                       );
                       toast("Rappel programmé à ${reminderTime.value!.format(context)}");
                    }
                    
                    controller.saveItem({
                      'name': nameCont.text.trim(),
                      'dosage': dosageCont.text.trim(),
                      'frequency': frequencyCont.text.trim(),
                      'start_date': startDateCont.text.trim(),
                      'end_date': endDateCont.text.trim(),
                      'prescribed_by': prescribedByCont.text.trim(),
                      'is_active': isActive.value,
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
