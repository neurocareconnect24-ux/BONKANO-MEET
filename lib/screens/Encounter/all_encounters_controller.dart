import 'dart:async';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../api/core_apis.dart';
import '../../utils/app_common.dart';
import '../../utils/constants.dart';
import '../booking/model/appointments_res_model.dart';
import 'model/encounter_list_model.dart';

class AllEncountersController extends GetxController {
  RxList<dynamic> combinedList = RxList();
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;

  @override
  void onReady() {
    getAllEncounters();
    super.onReady();
  }

  Future<void> getAllEncounters({bool showLoader = true}) async {
    if (showLoader) {
      isLoading(true);
    }
    try {
      // Fetch Encounters
      List<EncounterElement> encounters = [];
      await CoreServiceApis.getEncounterList(
        page: page.value,
        patientId: loginUserData.value.id,
        encounterList: encounters,
        perPage: 50,
      );

      // Fetch Completed Appointments (Consultations)
      List<AppointmentData> appointments = [];
      await CoreServiceApis.getAppointmentList(
        page: page.value,
        appointments: appointments,
        filterByStatus: 'completed', // We only want history in Actes Médicaux
        perPage: 50,
      );

      // Safety net: only keep appointments actually checked out.
      // The backend's status=checkout filter has been seen to leak
      // pending-validation appointments into this "completed" list.
      List<AppointmentData> checkedOutAppointments =
          appointments.where((a) => a.status == BookingStatusConst.CHECKOUT).toList();

      // Combine and Sort
      List<dynamic> combined = [...encounters, ...checkedOutAppointments];
      combined.sort((a, b) {
        DateTime dateA = _getDateTime(a);
        DateTime dateB = _getDateTime(b);
        return dateB.compareTo(dateA);
      });

      if (page.value == 1) combinedList.clear();
      combinedList.addAll(combined);
      
      // Simplified pagination check for combined list
      isLastPage(combined.length < 50); 
      
    } catch (e) {
      log("getAllEncounters Err : $e");
    } finally {
      isLoading(false);
    }
  }

  DateTime _getDateTime(dynamic item) {
    if (item is EncounterElement) {
      return DateTime.tryParse(item.encounterDate) ?? DateTime(1900);
    } else if (item is AppointmentData) {
      return DateTime.tryParse(item.appointmentDate) ?? DateTime(1900);
    }
    return DateTime(1900);
  }
}
