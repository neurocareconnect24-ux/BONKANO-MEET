import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bonkano_meet/api/core_apis.dart';
import 'package:bonkano_meet/main.dart';
import 'package:bonkano_meet/screens/booking/components/confirm_booking_bottomsheet.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../api/auth_apis.dart';
import '../../payment_gateways/feda_pay_service.dart';
import '../../utils/app_common.dart';
import '../../utils/common_base.dart';
import '../../utils/constants.dart';
import '../booking/appointments_controller.dart';
import '../booking/model/booking_req.dart';
import '../booking/model/save_payment_req.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/dashboard_screen.dart';
import 'booking_success_screen.dart';

// ignore: non_constant_identifier_names
// Note: variable globale mutable - s'assurer de toujours réinitialiser avant utilisation
PaymentController paymentController = PaymentController();

class PaymentController extends GetxController {
  bool isFromBookingDetail;
  bool isAdvancePaymentFailed;
  bool isRemainingPayment;
  num? amount;
  int? bid;

  PaymentController({
    this.isFromBookingDetail = false,
    this.isAdvancePaymentFailed = false,
    this.isRemainingPayment = false,
    this.amount,
    this.bid,
  });

  //
  BookingReq bookingData = BookingReq();
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_CASH.obs;
  TextEditingController optionalCont = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    optionalCont.dispose();
    super.onClose();
  }



  num get payAmount => isFromBookingDetail && amount.validate() > 0
      ? amount.validate()
      : bookingData.isEnableAdvancePayment
          ? bookingData.advancePayableAmount
          : bookingData.totalAmount;

  int get bookId => isFromBookingDetail && bid.validate() > 0 ? bid.validate() : saveBookingRes.value.saveBookingResData.id;

  savePaymentApi({
    required int bid,
    required String txnId,
    required String paymentType,
  }) {
    isLoading(true);
    hideKeyBoardWithoutContext();
    CoreServiceApis.savePayment(
      request: SavePaymentReq(
        id: bid,
        externalTransactionId: txnId,
        transactionType: paymentType,
        taxPercentage: appConfigs.value.exclusiveTaxList,
        paymentStatus: paymentType == PaymentMethods.PAYMENT_METHOD_CASH || bookingData.isEnableAdvancePayment || (isFromBookingDetail && isAdvancePaymentFailed) ? 0 : 1,
        advancePaymentAmount: (isFromBookingDetail && isAdvancePaymentFailed) ? payAmount : bookingData.advancePayableAmount,
        advancePaymentStatus: (isFromBookingDetail && isAdvancePaymentFailed) ? 1 : bookingData.isEnableAdvancePayment.getIntBool(),
        remainingPaymentAmount: isRemainingPayment ? payAmount : 0,
      ).toJson(),
    ).then((value) async {
      if (isFromBookingDetail) {
        Get.back(result: true);
      } else {
        onPaymentSuccess();
      }
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      log('savePaymentApi Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
    });
  }

  handleBookNowClick(BuildContext context,bool isQuickBook) {
    if (isFromBookingDetail) {
      payWithSelectedOption(context, isCashPayment: false);
    } else {
      Get.bottomSheet(
        ConfirmBookingBottomSheet(
          isQuickBook: isQuickBook,
          serviceName: paymentController.bookingData.serviceName.validate(),
          dateTime: "${paymentController.bookingData.appointmentDate.validate()} at ${paymentController.bookingData.appointmentTime.validate()}",
          price: paymentController.payAmount,
          titleText: locale.value.wouldYouLikeToProceedAndConfirmPayment,
          onConfirm: () {
            Get.back();
            if (saveBookingRes.value.saveBookingResData.id.isNegative) {
              saveBooking(context);
            } else {
              payWithSelectedOption(context);
            }
          },
        ),
      );
    }
  }

  void payWithSelectedOption(BuildContext context, {bool isCashPayment = true}) {
    if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_WALLET) {
      payWithWallet(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FEDAPAY) {
      payWithFedaPay(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CASH && isCashPayment) {
      payWithCash(context);
    }
  }



  payWithCash(BuildContext context) async {
    savePaymentApi(
      bid: bookId,
      paymentType: PaymentMethods.PAYMENT_METHOD_CASH,
      txnId: isFromBookingDetail && bid.validate() > 0 ? "#${bid.validate()}" : "",
    );
  }

  void payWithFedaPay(BuildContext context) {
    FedaPayService fedaPayService = FedaPayService(
      totalAmount: payAmount,
      onComplete: (res) {
        log("txn id: $res");
        savePaymentApi(
          bid: bookId,
          paymentType: PaymentMethods.PAYMENT_METHOD_FEDAPAY,
          txnId: res["transaction_id"] ?? "FedaPay_${bookId}_${DateTime.now().millisecondsSinceEpoch}",
        );
      },
    );
    fedaPayService.payWithFedaPay(context);
  }

  payWithWallet(BuildContext context) async {
    savePaymentApi(
      bid: bookId,
      paymentType: PaymentMethods.PAYMENT_METHOD_WALLET,
      txnId: isFromBookingDetail && bid.validate() > 0 ? "#${bid.validate()}" : "",
    );
  }

  saveBooking(BuildContext context, {List<PlatformFile>? files}) {
    isLoading(true);

    CoreServiceApis.bookServiceApi(
      request: bookingData.toJson(),
      files: bookingData.files,
      onSuccess: () async {
        payWithSelectedOption(context);
      },
      loaderOff: () {
        isLoading(false);
      },
    ).then((value) {}).catchError((e) {
      isLoading(false);
      log('saveBooking Error: $e');
      toast(locale.value.somethingWentWrong, print: true);
    });
  }

  void onPaymentSuccess() async {
    isLoading(false);
    reLoadBookingsOnDashboard();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.offUntil(
        GetPageRoute(
            page: () => BookingSuccessScreen(),
            binding: BindingsBuilder(() {
              setStatusBarColor(transparentColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark);
            })),
        (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
  }
}

void reLoadBookingsOnDashboard() {
  try {
    AppointmentsController aCont = Get.find();
    aCont.getAppointmentList();
  } catch (e) {
    log('E: $e');
  }
  try {
    DashboardController dashboardController = Get.find();
    dashboardController.currentIndex(1);
    dashboardController.reloadBottomTabs();
  } catch (e) {
    log('E: $e');
  }
  AuthServiceApis.getUserWallet();
}