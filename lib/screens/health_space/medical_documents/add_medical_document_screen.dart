import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'medical_document_controller.dart';

class AddMedicalDocumentScreen extends StatelessWidget {
  AddMedicalDocumentScreen({super.key});

  final MedicalDocumentController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController uploadDateCont = TextEditingController();
  final RxString selectedCategory = 'report'.obs;
  final Rx<File> attachedFile = File('').obs;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.addDocument,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(locale.value.title, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: titleCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(context, labelText: locale.value.title),
              ),
              16.height,

              // Category dropdown
              Text(locale.value.category, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() => DropdownButtonFormField<String>(
                    value: selectedCategory.value,
                    decoration: inputDecoration(context, labelText: locale.value.category),
                    items: [
                      DropdownMenuItem(value: 'report', child: Text(locale.value.report)),
                      DropdownMenuItem(value: 'prescription', child: Text(locale.value.prescription)),
                      DropdownMenuItem(value: 'imaging', child: Text(locale.value.imaging)),
                      DropdownMenuItem(value: 'other', child: Text(locale.value.other)),
                    ],
                    onChanged: (v) => selectedCategory(v),
                  )),
              16.height,

              // Upload Date
              Text(locale.value.uploadDate, style: boldTextStyle(size: 14)),
              8.height,
              AppTextField(
                controller: uploadDateCont,
                textFieldType: TextFieldType.NAME,
                readOnly: true,
                decoration: inputDecoration(context, labelText: locale.value.uploadDate, suffixIcon: const Icon(Icons.calendar_today, size: 18)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    uploadDateCont.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
              16.height,

              // Document Attachment
              Text(locale.value.file, style: boldTextStyle(size: 14)),
              8.height,
              Obx(() {
                if (attachedFile.value.path.isEmpty) {
                  return InkWell(
                    onTap: () async {
                      List<PlatformFile> picked = await pickFiles(type: FileType.custom);
                      if (picked.isNotEmpty && picked.first.path != null) {
                        attachedFile(File(picked.first.path!));
                      }
                    },
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      decoration: boxDecorationWithRoundedCorners(
                        border: Border.all(color: appColorPrimary.withValues(alpha: 0.4), width: 1.5, style: BorderStyle.solid),
                        borderRadius: radius(12),
                        backgroundColor: appColorPrimary.withValues(alpha: 0.05),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, color: appColorPrimary, size: 36),
                          12.height,
                          Text("Sélectionner un document (PDF, JPG, PNG...)", style: boldTextStyle(size: 12, color: appColorPrimary)),
                        ],
                      ),
                    ),
                  );
                } else {
                  String filename = attachedFile.value.path.split('/').last.split('\\').last;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: boxDecorationDefault(
                      color: context.cardColor,
                      borderRadius: radius(12),
                      border: Border.all(color: borderColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: appColorPrimary.withValues(alpha: 0.1)),
                          child: const Icon(Icons.insert_drive_file_outlined, color: appColorPrimary, size: 24),
                        ),
                        16.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filename, style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                              4.height,
                              Text(
                                "${(attachedFile.value.lengthSync() / 1024).toStringAsFixed(1)} KB",
                                style: secondaryTextStyle(size: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: cancelStatusColor),
                          onPressed: () => attachedFile(File('')),
                        ),
                      ],
                    ),
                  );
                }
              }),
              32.height,

              // Submit
              AppButton(
                width: Get.width,
                text: locale.value.save,
                color: appColorPrimary,
                textStyle: boldTextStyle(color: Colors.white),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    if (attachedFile.value.path.isEmpty) {
                      toast("Veuillez sélectionner un fichier à téléverser");
                      return;
                    }
                    controller.saveItem({
                      'title': titleCont.text.trim(),
                      'category': selectedCategory.value,
                      'upload_date': uploadDateCont.text.trim(),
                    }, file: attachedFile.value);
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
