class MedicalHistoryData {
  int id;
  String type;
  String title;
  String description;
  String date;
  int patientId;

  MedicalHistoryData({
    this.id = -1,
    this.type = "",
    this.title = "",
    this.description = "",
    this.date = "",
    this.patientId = -1,
  });

  factory MedicalHistoryData.fromJson(Map<String, dynamic> json) {
    return MedicalHistoryData(
      id: json['id'] is int ? json['id'] : -1,
      type: json['type'] is String ? json['type'] : "",
      title: json['title'] is String ? json['title'] : "",
      description: json['description'] is String ? json['description'] : "",
      date: json['date'] is String ? json['date'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'date': date,
      'patient_id': patientId,
    };
  }
}

class AllergyData {
  int id;
  String allergyType;
  String name;
  String severity;
  String reaction;
  String diagnosedDate;
  int patientId;

  AllergyData({
    this.id = -1,
    this.allergyType = "",
    this.name = "",
    this.severity = "",
    this.reaction = "",
    this.diagnosedDate = "",
    this.patientId = -1,
  });

  factory AllergyData.fromJson(Map<String, dynamic> json) {
    return AllergyData(
      id: json['id'] is int ? json['id'] : -1,
      allergyType: json['allergy_type'] is String ? json['allergy_type'] : "",
      name: json['name'] is String ? json['name'] : "",
      severity: json['severity'] is String ? json['severity'] : "",
      reaction: json['reaction'] is String ? json['reaction'] : "",
      diagnosedDate: json['diagnosed_date'] is String ? json['diagnosed_date'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergy_type': allergyType,
      'name': name,
      'severity': severity,
      'reaction': reaction,
      'diagnosed_date': diagnosedDate,
      'patient_id': patientId,
    };
  }
}

class TreatmentData {
  int id;
  String name;
  String dosage;
  String frequency;
  String startDate;
  String endDate;
  String prescribedBy;
  bool isActive;
  int patientId;

  TreatmentData({
    this.id = -1,
    this.name = "",
    this.dosage = "",
    this.frequency = "",
    this.startDate = "",
    this.endDate = "",
    this.prescribedBy = "",
    this.isActive = false,
    this.patientId = -1,
  });

  factory TreatmentData.fromJson(Map<String, dynamic> json) {
    return TreatmentData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      dosage: json['dosage'] is String ? json['dosage'] : "",
      frequency: json['frequency'] is String ? json['frequency'] : "",
      startDate: json['start_date'] is String ? json['start_date'] : "",
      endDate: json['end_date'] is String ? json['end_date'] : "",
      prescribedBy: json['prescribed_by'] is String ? json['prescribed_by'] : "",
      isActive: json['is_active'] is bool ? json['is_active'] : json['is_active'] == 1,
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'start_date': startDate,
      'end_date': endDate,
      'prescribed_by': prescribedBy,
      'is_active': isActive ? 1 : 0,
      'patient_id': patientId,
    };
  }
}

class VaccinationData {
  int id;
  String vaccineName;
  String date;
  int doseNumber;
  String nextDueDate;
  String administeredBy;
  int patientId;

  VaccinationData({
    this.id = -1,
    this.vaccineName = "",
    this.date = "",
    this.doseNumber = 0,
    this.nextDueDate = "",
    this.administeredBy = "",
    this.patientId = -1,
  });

  factory VaccinationData.fromJson(Map<String, dynamic> json) {
    return VaccinationData(
      id: json['id'] is int ? json['id'] : -1,
      vaccineName: json['vaccine_name'] is String ? json['vaccine_name'] : "",
      date: json['date'] is String ? json['date'] : "",
      doseNumber: json['dose_number'] is int ? json['dose_number'] : 0,
      nextDueDate: json['next_due_date'] is String ? json['next_due_date'] : "",
      administeredBy: json['administered_by'] is String ? json['administered_by'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccine_name': vaccineName,
      'date': date,
      'dose_number': doseNumber,
      'next_due_date': nextDueDate,
      'administered_by': administeredBy,
      'patient_id': patientId,
    };
  }
}

class LabResultData {
  int id;
  String testName;
  String date;
  String result;
  String normalRange;
  String unit;
  String labName;
  String status;
  int patientId;

  LabResultData({
    this.id = -1,
    this.testName = "",
    this.date = "",
    this.result = "",
    this.normalRange = "",
    this.unit = "",
    this.labName = "",
    this.status = "",
    this.patientId = -1,
  });

  factory LabResultData.fromJson(Map<String, dynamic> json) {
    return LabResultData(
      id: json['id'] is int ? json['id'] : -1,
      testName: json['test_name'] is String ? json['test_name'] : "",
      date: json['date'] is String ? json['date'] : "",
      result: json['result'] is String ? json['result'] : "",
      normalRange: json['normal_range'] is String ? json['normal_range'] : "",
      unit: json['unit'] is String ? json['unit'] : "",
      labName: json['lab_name'] is String ? json['lab_name'] : "",
      status: json['status'] is String ? json['status'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_name': testName,
      'date': date,
      'result': result,
      'normal_range': normalRange,
      'unit': unit,
      'lab_name': labName,
      'status': status,
      'patient_id': patientId,
    };
  }
}

class MedicalDocumentData {
  int id;
  String title;
  String category;
  String fileUrl;
  String uploadDate;
  String fileType;
  int patientId;

  MedicalDocumentData({
    this.id = -1,
    this.title = "",
    this.category = "",
    this.fileUrl = "",
    this.uploadDate = "",
    this.fileType = "",
    this.patientId = -1,
  });

  factory MedicalDocumentData.fromJson(Map<String, dynamic> json) {
    return MedicalDocumentData(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      category: json['category'] is String ? json['category'] : "",
      fileUrl: (json['file_url'] is String && json['file_url'].toString().isNotEmpty) ? json['file_url'] :
               (json['upload_document'] is String && json['upload_document'].toString().isNotEmpty) ? json['upload_document'] :
               (json['document_url'] is String && json['document_url'].toString().isNotEmpty) ? json['document_url'] :
               (json['document'] is String && json['document'].toString().isNotEmpty) ? json['document'] : "",
      uploadDate: json['upload_date'] is String ? json['upload_date'] : "",
      fileType: json['file_type'] is String ? json['file_type'] : "",
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'file_url': fileUrl,
      'upload_date': uploadDate,
      'file_type': fileType,
      'patient_id': patientId,
    };
  }
}

class MeasurementData {
  int id;
  String date;
  num height;
  num weight;
  num bmi;
  int systolic;
  int diastolic;
  num bloodSugar;
  int patientId;

  MeasurementData({
    this.id = -1,
    this.date = "",
    this.height = 0,
    this.weight = 0,
    this.bmi = 0,
    this.systolic = 0,
    this.diastolic = 0,
    this.bloodSugar = 0,
    this.patientId = -1,
  });

  factory MeasurementData.fromJson(Map<String, dynamic> json) {
    return MeasurementData(
      id: json['id'] is int ? json['id'] : -1,
      date: json['date'] is String ? json['date'] : "",
      height: json['height'] is num ? json['height'] : 0,
      weight: json['weight'] is num ? json['weight'] : 0,
      bmi: json['bmi'] is num ? json['bmi'] : 0,
      systolic: json['systolic'] is int ? json['systolic'] : 0,
      diastolic: json['diastolic'] is int ? json['diastolic'] : 0,
      bloodSugar: json['blood_sugar'] is num ? json['blood_sugar'] : 0,
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'systolic': systolic,
      'diastolic': diastolic,
      'blood_sugar': bloodSugar,
      'patient_id': patientId,
    };
  }
}

class EmergencyContactData {
  int id;
  String name;
  String phone;
  String relationship;
  bool isPrimary;
  int patientId;

  EmergencyContactData({
    this.id = -1,
    this.name = "",
    this.phone = "",
    this.relationship = "",
    this.isPrimary = false,
    this.patientId = -1,
  });

  factory EmergencyContactData.fromJson(Map<String, dynamic> json) {
    return EmergencyContactData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      phone: json['phone'] is String ? json['phone'] : "",
      relationship: json['relationship'] is String ? json['relationship'] : "",
      isPrimary: json['is_primary'] is bool ? json['is_primary'] : json['is_primary'] == 1,
      patientId: json['patient_id'] is int ? json['patient_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'is_primary': isPrimary ? 1 : 0,
      'patient_id': patientId,
    };
  }
}
