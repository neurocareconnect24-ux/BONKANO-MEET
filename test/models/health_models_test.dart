import 'package:flutter_test/flutter_test.dart';
import 'package:bonkano_meet/screens/health_space/model/health_models.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  MedicalHistoryData
  // ═══════════════════════════════════════════════════════════════════════════
  group('MedicalHistoryData', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'id': 1,
        'type': 'Surgery',
        'title': 'Appendectomy',
        'description': 'Emergency appendix removal',
        'date': '2024-01-15',
        'patient_id': 42,
      };

      final data = MedicalHistoryData.fromJson(json);

      expect(data.id, 1);
      expect(data.type, 'Surgery');
      expect(data.title, 'Appendectomy');
      expect(data.description, 'Emergency appendix removal');
      expect(data.date, '2024-01-15');
      expect(data.patientId, 42);
    });

    test('fromJson handles missing fields with defaults', () {
      final data = MedicalHistoryData.fromJson({});

      expect(data.id, -1);
      expect(data.type, '');
      expect(data.title, '');
      expect(data.description, '');
      expect(data.date, '');
      expect(data.patientId, -1);
    });

    test('fromJson handles wrong types gracefully', () {
      final json = {
        'id': 'not_an_int',
        'type': 123,
        'title': null,
        'date': true,
        'patient_id': 'abc',
      };

      final data = MedicalHistoryData.fromJson(json);

      expect(data.id, -1);
      expect(data.type, '');
      expect(data.title, '');
      expect(data.date, '');
      expect(data.patientId, -1);
    });

    test('toJson produces correct map', () {
      final data = MedicalHistoryData(
        id: 5,
        type: 'Illness',
        title: 'Flu',
        description: 'Seasonal flu',
        date: '2024-03-01',
        patientId: 10,
      );

      final json = data.toJson();

      expect(json['id'], 5);
      expect(json['type'], 'Illness');
      expect(json['title'], 'Flu');
      expect(json['description'], 'Seasonal flu');
      expect(json['date'], '2024-03-01');
      expect(json['patient_id'], 10);
    });

    test('fromJson -> toJson roundtrip preserves data', () {
      final original = {
        'id': 7,
        'type': 'Allergy',
        'title': 'Peanut allergy',
        'description': 'Severe reaction',
        'date': '2023-06-20',
        'patient_id': 99,
      };

      final data = MedicalHistoryData.fromJson(original);
      final result = data.toJson();

      expect(result, original);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  AllergyData
  // ═══════════════════════════════════════════════════════════════════════════
  group('AllergyData', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'id': 10,
        'allergy_type': 'Food',
        'name': 'Peanut',
        'severity': 'High',
        'reaction': 'Anaphylaxis',
        'diagnosed_date': '2022-05-10',
        'patient_id': 42,
      };

      final data = AllergyData.fromJson(json);

      expect(data.id, 10);
      expect(data.allergyType, 'Food');
      expect(data.name, 'Peanut');
      expect(data.severity, 'High');
      expect(data.reaction, 'Anaphylaxis');
      expect(data.diagnosedDate, '2022-05-10');
      expect(data.patientId, 42);
    });

    test('fromJson handles empty JSON with defaults', () {
      final data = AllergyData.fromJson({});

      expect(data.id, -1);
      expect(data.allergyType, '');
      expect(data.name, '');
      expect(data.severity, '');
      expect(data.reaction, '');
      expect(data.diagnosedDate, '');
      expect(data.patientId, -1);
    });

    test('toJson produces correct snake_case keys', () {
      final data = AllergyData(
        id: 3,
        allergyType: 'Drug',
        name: 'Penicillin',
        severity: 'Medium',
        reaction: 'Rash',
        diagnosedDate: '2023-01-01',
        patientId: 5,
      );

      final json = data.toJson();

      expect(json['allergy_type'], 'Drug');
      expect(json['diagnosed_date'], '2023-01-01');
      expect(json['patient_id'], 5);
    });

    test('fromJson -> toJson roundtrip preserves data', () {
      final original = {
        'id': 3,
        'allergy_type': 'Drug',
        'name': 'Penicillin',
        'severity': 'Medium',
        'reaction': 'Rash',
        'diagnosed_date': '2023-01-01',
        'patient_id': 5,
      };

      final result = AllergyData.fromJson(original).toJson();
      expect(result, original);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  TreatmentData
  // ═══════════════════════════════════════════════════════════════════════════
  group('TreatmentData', () {
    test('fromJson parses valid JSON with bool isActive', () {
      final json = {
        'id': 1,
        'name': 'Amoxicillin',
        'dosage': '500mg',
        'frequency': 'Twice daily',
        'start_date': '2024-01-01',
        'end_date': '2024-01-15',
        'prescribed_by': 'Dr. Smith',
        'is_active': true,
        'patient_id': 42,
      };

      final data = TreatmentData.fromJson(json);

      expect(data.name, 'Amoxicillin');
      expect(data.isActive, true);
    });

    test('fromJson parses isActive from int (1)', () {
      final json = {
        'id': 1,
        'is_active': 1,
      };

      final data = TreatmentData.fromJson(json);
      expect(data.isActive, true);
    });

    test('fromJson parses isActive from int (0)', () {
      final json = {
        'id': 1,
        'is_active': 0,
      };

      final data = TreatmentData.fromJson(json);
      expect(data.isActive, false);
    });

    test('toJson converts isActive to int', () {
      final data = TreatmentData(isActive: true);
      expect(data.toJson()['is_active'], 1);

      final data2 = TreatmentData(isActive: false);
      expect(data2.toJson()['is_active'], 0);
    });

    test('default values are correct', () {
      final data = TreatmentData();

      expect(data.id, -1);
      expect(data.name, '');
      expect(data.isActive, false);
      expect(data.patientId, -1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  VaccinationData
  // ═══════════════════════════════════════════════════════════════════════════
  group('VaccinationData', () {
    test('fromJson parses valid JSON correctly', () {
      final json = {
        'id': 5,
        'vaccine_name': 'COVID-19 Pfizer',
        'date': '2024-03-15',
        'dose_number': 3,
        'next_due_date': '2024-09-15',
        'administered_by': 'Dr. Jones',
        'patient_id': 42,
      };

      final data = VaccinationData.fromJson(json);

      expect(data.vaccineName, 'COVID-19 Pfizer');
      expect(data.doseNumber, 3);
      expect(data.nextDueDate, '2024-09-15');
      expect(data.administeredBy, 'Dr. Jones');
    });

    test('fromJson handles missing dose_number', () {
      final data = VaccinationData.fromJson({});
      expect(data.doseNumber, 0);
    });

    test('toJson uses snake_case keys', () {
      final data = VaccinationData(
        vaccineName: 'BCG',
        doseNumber: 1,
        nextDueDate: '2025-01-01',
        administeredBy: 'Nurse',
      );

      final json = data.toJson();
      expect(json['vaccine_name'], 'BCG');
      expect(json['dose_number'], 1);
      expect(json['next_due_date'], '2025-01-01');
      expect(json['administered_by'], 'Nurse');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  LabResultData
  // ═══════════════════════════════════════════════════════════════════════════
  group('LabResultData', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 20,
        'test_name': 'Complete Blood Count',
        'date': '2024-02-20',
        'result': '14.5',
        'normal_range': '12.0-17.5',
        'unit': 'g/dL',
        'lab_name': 'LabCorp',
        'status': 'normal',
        'patient_id': 42,
      };

      final data = LabResultData.fromJson(json);

      expect(data.testName, 'Complete Blood Count');
      expect(data.result, '14.5');
      expect(data.normalRange, '12.0-17.5');
      expect(data.unit, 'g/dL');
      expect(data.labName, 'LabCorp');
      expect(data.status, 'normal');
    });

    test('fromJson -> toJson roundtrip', () {
      final original = {
        'id': 20,
        'test_name': 'HbA1c',
        'date': '2024-02-01',
        'result': '5.7',
        'normal_range': '4.0-5.6',
        'unit': '%',
        'lab_name': 'Quest',
        'status': 'elevated',
        'patient_id': 10,
      };

      expect(LabResultData.fromJson(original).toJson(), original);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  MedicalDocumentData
  // ═══════════════════════════════════════════════════════════════════════════
  group('MedicalDocumentData', () {
    test('fromJson parses valid JSON', () {
      final json = {
        'id': 15,
        'title': 'X-Ray Report',
        'category': 'Radiology',
        'file_url': 'https://example.com/xray.pdf',
        'upload_date': '2024-01-10',
        'file_type': 'pdf',
        'patient_id': 42,
      };

      final data = MedicalDocumentData.fromJson(json);

      expect(data.title, 'X-Ray Report');
      expect(data.category, 'Radiology');
      expect(data.fileUrl, 'https://example.com/xray.pdf');
      expect(data.fileType, 'pdf');
    });

    test('default values', () {
      final data = MedicalDocumentData();
      expect(data.id, -1);
      expect(data.title, '');
      expect(data.fileUrl, '');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  MeasurementData
  // ═══════════════════════════════════════════════════════════════════════════
  group('MeasurementData', () {
    test('fromJson parses numeric fields correctly', () {
      final json = {
        'id': 1,
        'date': '2024-03-01',
        'height': 175.5,
        'weight': 72.3,
        'bmi': 23.5,
        'systolic': 120,
        'diastolic': 80,
        'blood_sugar': 95.0,
        'patient_id': 42,
      };

      final data = MeasurementData.fromJson(json);

      expect(data.height, 175.5);
      expect(data.weight, 72.3);
      expect(data.bmi, 23.5);
      expect(data.systolic, 120);
      expect(data.diastolic, 80);
      expect(data.bloodSugar, 95.0);
    });

    test('fromJson handles int height/weight', () {
      final json = {
        'height': 175,
        'weight': 70,
        'bmi': 22,
        'blood_sugar': 90,
      };

      final data = MeasurementData.fromJson(json);

      expect(data.height, 175);
      expect(data.weight, 70);
    });

    test('fromJson handles wrong types for numeric fields', () {
      final json = {
        'height': 'tall',
        'weight': null,
        'systolic': '120',
        'blood_sugar': true,
      };

      final data = MeasurementData.fromJson(json);

      expect(data.height, 0);
      expect(data.weight, 0);
      expect(data.systolic, 0);
      expect(data.bloodSugar, 0);
    });

    test('toJson uses snake_case for blood_sugar', () {
      final data = MeasurementData(bloodSugar: 110.5);
      expect(data.toJson()['blood_sugar'], 110.5);
    });

    test('default values are zero', () {
      final data = MeasurementData();

      expect(data.height, 0);
      expect(data.weight, 0);
      expect(data.bmi, 0);
      expect(data.systolic, 0);
      expect(data.diastolic, 0);
      expect(data.bloodSugar, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  EmergencyContactData
  // ═══════════════════════════════════════════════════════════════════════════
  group('EmergencyContactData', () {
    test('fromJson parses valid JSON with bool isPrimary', () {
      final json = {
        'id': 1,
        'name': 'Jane Doe',
        'phone': '+1234567890',
        'relationship': 'Spouse',
        'is_primary': true,
        'patient_id': 42,
      };

      final data = EmergencyContactData.fromJson(json);

      expect(data.name, 'Jane Doe');
      expect(data.phone, '+1234567890');
      expect(data.relationship, 'Spouse');
      expect(data.isPrimary, true);
    });

    test('fromJson parses isPrimary from int (1)', () {
      final data = EmergencyContactData.fromJson({'is_primary': 1});
      expect(data.isPrimary, true);
    });

    test('fromJson parses isPrimary from int (0)', () {
      final data = EmergencyContactData.fromJson({'is_primary': 0});
      expect(data.isPrimary, false);
    });

    test('toJson converts isPrimary to int', () {
      final data = EmergencyContactData(isPrimary: true);
      expect(data.toJson()['is_primary'], 1);

      final data2 = EmergencyContactData(isPrimary: false);
      expect(data2.toJson()['is_primary'], 0);
    });

    test('fromJson handles null is_primary', () {
      final data = EmergencyContactData.fromJson({'is_primary': null});
      expect(data.isPrimary, false);
    });
  });
}
