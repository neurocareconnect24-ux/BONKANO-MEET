import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'add_emergency_contact_screen.dart';
import 'emergency_contact_controller.dart';

class EmergencyContactScreen extends StatelessWidget {
  EmergencyContactScreen({super.key});

  final EmergencyContactController controller = Get.put(EmergencyContactController());

  static const Color _emergencyColor = Color(0xFFF04336);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.emergencyContacts,
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
                          decoration: boxDecorationDefault(shape: BoxShape.circle, color: _emergencyColor.withValues(alpha: 0.1)),
                          child: const Icon(Icons.emergency_rounded, color: _emergencyColor, size: 22),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(item.name, style: boldTextStyle(size: 14))),
                            if (item.isPrimary)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: boxDecorationDefault(color: const Color(0xFF56CC85).withValues(alpha: 0.1), borderRadius: radius(8)),
                                child: Text(locale.value.isPrimary, style: boldTextStyle(size: 10, color: const Color(0xFF56CC85))),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            if (item.phone.isNotEmpty) Text(item.phone, style: secondaryTextStyle(size: 12)),
                            if (item.relationship.isNotEmpty) Text(item.relationship, style: secondaryTextStyle(size: 12)),
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
        onPressed: () => Get.to(() => AddEmergencyContactScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emergency_rounded, size: 60, color: secondaryTextColor),
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
