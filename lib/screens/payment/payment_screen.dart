import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/auth_apis.dart';
import '../../components/app_scaffold.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../dashboard/dashboard_controller.dart';
import 'payment_controller.dart';

class PaymentScreen extends StatelessWidget {
  final bool isQuickBook ;
  const PaymentScreen({super.key, this.isQuickBook=false});


  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      appBartitleText: locale.value.payment,
      isLoading: paymentController.isLoading,
      appBarVerticalSize: Get.height * 0.12,
      body: RefreshIndicator(
        onRefresh: () async {
          await AuthServiceApis.getUserWallet();
          await getAppConfigurations();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "* ${locale.value.noteForCashPaymentPurposesDontUseThePayNowBut}",
                  style: secondaryTextStyle(color: appColorSecondary, size: 11, fontStyle: FontStyle.italic),
                ).paddingTop(16).visible(paymentController.isFromBookingDetail && !paymentController.isAdvancePaymentFailed),
                16.height,
                Text(locale.value.choosePaymentMethod, style: primaryTextStyle(size: 18)),
                8.height,
                Text(locale.value.chooseOurConvenientPaymentOptionAndUnlockUnli, style: secondaryTextStyle()),
                32.height,
                cashAfterService(context).visible(isQuickBook).paddingOnly(bottom: 8),
                Column(
                  children: [
                    if (!paymentController.bookingData.isOnlineService && !paymentController.isFromBookingDetail && !paymentController.bookingData.isEnableAdvancePayment) cashAfterService(context).paddingOnly(bottom: 8),
                    fedaPayWidget(context).paddingOnly(bottom: 8),
                  ],
                ).visible(!isQuickBook)
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ).makeRefreshable,
      ),
      widgetsStackedOverBody: [
        Positioned(
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          left: 16,
          right: 16,
          child: AppButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: appColorSecondary,
            onTap: () {
              paymentController.handleBookNowClick(context,isQuickBook);
            },
            textStyle: appButtonFontColorText,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(locale.value.proceed, style: primaryTextStyle(color: Colors.white)),
            ),
          ),
        )
      ],
    );
  }






  Widget cashAfterService(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Obx(
        () => RadioListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 2),
          tileColor: context.cardColor,
          controlAffinity: ListTileControlAffinity.trailing,
          shape: RoundedRectangleBorder(borderRadius: radius()),
          secondary: const Image(
            image: AssetImage(Assets.iconsIcCash),
            color: appColorPrimary,
            height: 18,
            width: 24,
          ),
          fillColor: WidgetStateProperty.all(appColorPrimary),
          title: Text(locale.value.cashAfterService, style: primaryTextStyle()),
          value: PaymentMethods.PAYMENT_METHOD_CASH,
          groupValue: paymentController.paymentOption.value,
          onChanged: (value) {
            paymentController.paymentOption(value.toString());
          },
        ),
      ),
    );
  }

  Widget fedaPayWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Obx(
        () => RadioListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 2),
          tileColor: context.cardColor,
          controlAffinity: ListTileControlAffinity.trailing,
          shape: RoundedRectangleBorder(borderRadius: radius()),
          secondary: Container(
            height: 24,
            width: 24,
            decoration: boxDecorationDefault(
              shape: BoxShape.circle,
              color: appColorPrimary.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.payment_rounded, color: appColorPrimary, size: 16),
          ),
          fillColor: WidgetStateProperty.all(appColorPrimary),
          title: Text("FedaPay", style: primaryTextStyle()),
          value: PaymentMethods.PAYMENT_METHOD_FEDAPAY,
          groupValue: paymentController.paymentOption.value,
          onChanged: (value) {
            paymentController.paymentOption(value.toString());
          },
        ),
      ),
    );
  }
}