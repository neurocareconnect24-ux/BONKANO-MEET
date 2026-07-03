import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import 'add_measurement_screen.dart';
import 'measurement_controller.dart';

class MeasurementScreen extends StatelessWidget {
  MeasurementScreen({super.key});

  final MeasurementController controller = Get.put(MeasurementController());

  static const Color _iconColor = Color(0xFF9C27B0);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.bodyMeasurements,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header: icon, date, delete button
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: boxDecorationDefault(shape: BoxShape.circle, color: _iconColor.withValues(alpha: 0.1)),
                                child: const Icon(Icons.monitor_weight_rounded, color: _iconColor, size: 22),
                              ),
                              12.width,
                              Expanded(
                                child: Text(item.date, style: boldTextStyle(size: 14)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: cancelStatusColor, size: 20),
                                onPressed: () => _confirmDelete(context, item.id),
                              ),
                            ],
                          ),
                          12.height,

                          /// Height / Weight / BMI chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (item.height > 0)
                                _chip('${locale.value.heightCm}: ${item.height}', context),
                              if (item.weight > 0)
                                _chip('${locale.value.weightKg}: ${item.weight}', context),
                              if (item.bmi > 0)
                                _chip('${locale.value.bmi}: ${item.bmi.toStringAsFixed(1)}', context),
                            ],
                          ),

                          /// Blood Pressure
                          if (item.systolic > 0 || item.diastolic > 0) ...[
                            8.height,
                            Text(
                              '${locale.value.bloodPressure}: ${item.systolic}/${item.diastolic} mmHg',
                              style: secondaryTextStyle(size: 12),
                            ),
                          ],

                          /// Blood Sugar
                          if (item.bloodSugar > 0) ...[
                            4.height,
                            Text(
                              '${locale.value.bloodSugar}: ${item.bloodSugar} mg/dL',
                              style: secondaryTextStyle(size: 12),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
      fabWidget: FloatingActionButton(
        backgroundColor: appColorPrimary,
        onPressed: () => Get.to(() => AddMeasurementScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _chip(String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: boxDecorationDefault(
        color: _iconColor.withValues(alpha: 0.1),
        borderRadius: radius(20),
      ),
      child: Text(label, style: secondaryTextStyle(size: 12, color: _iconColor)),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monitor_weight_rounded, size: 60, color: secondaryTextColor),
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
