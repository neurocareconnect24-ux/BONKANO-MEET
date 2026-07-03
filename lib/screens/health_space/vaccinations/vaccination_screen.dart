import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'add_vaccination_screen.dart';
import 'vaccination_controller.dart';

class VaccinationScreen extends StatelessWidget {
  VaccinationScreen({super.key});

  final VaccinationController controller = Get.put(VaccinationController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.vaccinations,
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
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: const Color(0xFFFFCE70).withValues(alpha: 0.1)),
                          child: const Icon(Icons.vaccines_rounded, color: Color(0xFFFFCE70), size: 22),
                        ),
                        title: Text(item.vaccineName, style: boldTextStyle(size: 14)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            if (item.date.isNotEmpty) Text(item.date, style: secondaryTextStyle(size: 12)),
                            if (item.doseNumber > 0) Text('${locale.value.doseNumber}: ${item.doseNumber}', style: secondaryTextStyle(size: 12)),
                            if (item.nextDueDate.isNotEmpty) Text('${locale.value.nextDueDate}: ${item.nextDueDate}', style: secondaryTextStyle(size: 12)),
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
        onPressed: () => Get.to(() => AddVaccinationScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.vaccines_rounded, size: 60, color: secondaryTextColor),
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
