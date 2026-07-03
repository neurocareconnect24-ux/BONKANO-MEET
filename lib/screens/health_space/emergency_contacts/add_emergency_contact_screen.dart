import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'emergency_contact_controller.dart';

class AddEmergencyContactScreen extends StatelessWidget {
  AddEmergencyContactScreen({super.key});

  final EmergencyContactController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController phoneCont = TextEditingController();
  final RxString selectedRelationship = 'parents'.obs;
  final RxBool isPrimary = false.obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addEmergencyContact,
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

              // Phone
              Text(locale.value.contactNumber, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: phoneCont,
                textFieldType: TextFieldType.PHONE,
                decoration: inputDecoration(context, labelText: locale.value.contactNumber),
              ),
              16.height,

              // Relationship dropdown
              Text(locale.value.relationship, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedRelationship.value,
                    decoration: inputDecoration(context, labelText: locale.value.relationship),
                    items: [
                      DropdownMenuItem(value: 'parents', child: Text(locale.value.parents)),
                      DropdownMenuItem(value: 'spouse', child: Text(locale.value.spouse)),
                      DropdownMenuItem(value: 'brother', child: Text(locale.value.brother)),
                      DropdownMenuItem(value: 'siblings', child: Text(locale.value.siblings)),
                      DropdownMenuItem(value: 'relative', child: Text(locale.value.relative)),
                      DropdownMenuItem(value: 'other', child: Text(locale.value.other)),
                    ],
                    onChanged: (v) => selectedRelationship(v),
                  )),
              16.height,

              // Is Primary
              Obx(() => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(locale.value.isPrimary, style: boldTextStyle(size: 14)),
                    value: isPrimary.value,
                    activeColor: appColorPrimary,
                    onChanged: (v) => isPrimary(v),
                  )),
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
                      'name': nameCont.text.trim(),
                      'phone': phoneCont.text.trim(),
                      'relationship': selectedRelationship.value,
                      'is_primary': isPrimary.value,
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
