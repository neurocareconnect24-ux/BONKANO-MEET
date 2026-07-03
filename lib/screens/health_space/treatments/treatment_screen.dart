import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'add_treatment_screen.dart';
import 'treatment_controller.dart';

class TreatmentScreen extends StatelessWidget {
  TreatmentScreen({super.key});

  final TreatmentController controller = Get.put(TreatmentController());

  static const Color _treatmentColor = Color(0xFF56CC85);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.currentTreatments,
      isLoading: controller.isLoading,
      body: Obx(
        () => controller.hasError.value
            ? _errorState()
            : controller.list.isEmpty
                ? _emptyState()
                : RefreshIndicator(
                onRefresh: () async => controller.loadData(),
                child: AnimatedListView(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.list.length,
                  itemBuilder: (context, index) {
                    final item = controller.list[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: _treatmentColor.withValues(alpha: 0.1)),
                          child: const Icon(Icons.medication_rounded, color: _treatmentColor, size: 22),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(item.name, style: boldTextStyle(size: 14))),
                            if (item.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: boxDecorationDefault(color: _treatmentColor.withValues(alpha: 0.1), borderRadius: radius(8)),
                                child: Text(locale.value.active, style: boldTextStyle(size: 10, color: _treatmentColor)),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            if (item.dosage.isNotEmpty) Text(item.dosage, style: secondaryTextStyle(size: 12)),
                            if (item.frequency.isNotEmpty) Text(item.frequency, style: secondaryTextStyle(size: 12)),
                            if (item.startDate.isNotEmpty) Text(item.startDate, style: secondaryTextStyle(size: 12)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: cancelStatusColor, size: 20),
                          onPressed: () => _confirmDelete(context, item.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      fabWidget: FloatingActionButton(
        backgroundColor: appColorPrimary,
        onPressed: () => Get.to(() => AddTreatmentScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medication_rounded, size: 60, color: secondaryTextColor),
          16.height,
          Text(locale.value.noDataYet, style: secondaryTextStyle(size: 16)),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 60, color: cancelStatusColor),
          16.height,
          Text(controller.errorMessage.value, style: secondaryTextStyle(size: 16)),
          16.height,
          TextButton.icon(
            onPressed: () => controller.loadData(),
            icon: const Icon(Icons.refresh, color: appColorPrimary),
            label: Text(locale.value.retry, style: boldTextStyle(size: 14, color: appColorPrimary)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showConfirmDialogCustom(
      context,
      primaryColor: appColorPrimary,
      title: locale.value.confirmDelete,
      positiveText: locale.value.delete,
      negativeText: locale.value.cancel,
      onAccept: (_) => controller.deleteItem(id),
    );
  }
}
