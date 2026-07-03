import 'dart:io';
import 'package:nb_utils/nb_utils.dart';

import '../models/base_response_model.dart';
import '../network/network_utils.dart';
import '../screens/health_space/model/health_models.dart';
import '../utils/api_end_points.dart';

class HealthServiceApis {
  // Medical History
  static Future<List<MedicalHistoryData>> getMedicalHistory() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getMedicalHistory, method: HttpMethodType.GET));
    return res['data'] is List ? List<MedicalHistoryData>.from((res['data'] as List).map((x) => MedicalHistoryData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveMedicalHistory({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveMedicalHistory, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteMedicalHistory({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteMedicalHistory}/$id', method: HttpMethodType.POST)),
    );
  }

  // Allergies
  static Future<List<AllergyData>> getAllergies() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getAllergies, method: HttpMethodType.GET));
    return res['data'] is List ? List<AllergyData>.from((res['data'] as List).map((x) => AllergyData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveAllergy({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveAllergy, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteAllergy({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteAllergy}/$id', method: HttpMethodType.POST)),
    );
  }

  // Treatments
  static Future<List<TreatmentData>> getTreatments() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getTreatments, method: HttpMethodType.GET));
    return res['data'] is List ? List<TreatmentData>.from((res['data'] as List).map((x) => TreatmentData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveTreatment({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveTreatment, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteTreatment({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteTreatment}/$id', method: HttpMethodType.POST)),
    );
  }

  // Vaccinations
  static Future<List<VaccinationData>> getVaccinations() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getVaccinations, method: HttpMethodType.GET));
    return res['data'] is List ? List<VaccinationData>.from((res['data'] as List).map((x) => VaccinationData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveVaccination({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveVaccination, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteVaccination({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteVaccination}/$id', method: HttpMethodType.POST)),
    );
  }

  // Lab Results
  static Future<List<LabResultData>> getLabResults() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getLabResults, method: HttpMethodType.GET));
    return res['data'] is List ? List<LabResultData>.from((res['data'] as List).map((x) => LabResultData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveLabResult({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveLabResult, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteLabResult({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteLabResult}/$id', method: HttpMethodType.POST)),
    );
  }

  // Medical Documents
  static Future<List<MedicalDocumentData>> getMedicalDocuments() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getMedicalDocuments, method: HttpMethodType.GET));
    return res['data'] is List ? List<MedicalDocumentData>.from((res['data'] as List).map((x) => MedicalDocumentData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveMedicalDocument({required Map<String, dynamic> request, File? file}) async {
    if (file != null) {
      return BaseResponseModel.fromJson(
        await buildMultiPartResponse(
          endPoint: APIEndPoints.saveMedicalDocument,
          request: request,
          fileKey: 'file',
          files: [file],
        ),
      );
    } else {
      return BaseResponseModel.fromJson(
        await handleResponse(await buildHttpResponse(APIEndPoints.saveMedicalDocument, method: HttpMethodType.POST, request: request)),
      );
    }
  }

  static Future<BaseResponseModel> deleteMedicalDocument({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteMedicalDocument}/$id', method: HttpMethodType.POST)),
    );
  }

  // Measurements
  static Future<List<MeasurementData>> getMeasurements() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getMeasurements, method: HttpMethodType.GET));
    return res['data'] is List ? List<MeasurementData>.from((res['data'] as List).map((x) => MeasurementData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveMeasurement({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveMeasurement, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteMeasurement({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteMeasurement}/$id', method: HttpMethodType.POST)),
    );
  }

  // Emergency Contacts
  static Future<List<EmergencyContactData>> getEmergencyContacts() async {
    final res = await handleResponse(await buildHttpResponse(APIEndPoints.getEmergencyContacts, method: HttpMethodType.GET));
    return res['data'] is List ? List<EmergencyContactData>.from((res['data'] as List).map((x) => EmergencyContactData.fromJson(x))) : [];
  }

  static Future<BaseResponseModel> saveEmergencyContact({required Map<String, dynamic> request}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse(APIEndPoints.saveEmergencyContact, method: HttpMethodType.POST, request: request)),
    );
  }

  static Future<BaseResponseModel> deleteEmergencyContact({required int id}) async {
    return BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('${APIEndPoints.deleteEmergencyContact}/$id', method: HttpMethodType.POST)),
    );
  }
}
