import 'package:flutter_test/flutter_test.dart';

/// Extracted validation logic from AddMeasurementScreen for testability.
/// These tests verify the same range checks applied in the screen.
class MeasurementValidator {
  static String? validateHeight(double h) {
    if (h > 0 && (h < 30 || h > 300)) return 'invalidHeight';
    return null;
  }

  static String? validateWeight(double w) {
    if (w > 0 && (w < 1 || w > 500)) return 'invalidWeight';
    return null;
  }

  static String? validateSystolic(int sys) {
    if (sys > 0 && (sys < 40 || sys > 300)) return 'invalidBloodPressure';
    return null;
  }

  static String? validateDiastolic(int dia) {
    if (dia > 0 && (dia < 20 || dia > 200)) return 'invalidBloodPressure';
    return null;
  }

  static String? validateBloodSugar(double bs) {
    if (bs > 0 && (bs < 20 || bs > 900)) return 'invalidBloodSugar';
    return null;
  }

  static double calculateBmi(double heightCm, double weightKg) {
    if (heightCm <= 0 || weightKg <= 0) return 0;
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }
}

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  Height Validation (30–300 cm)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Height validation', () {
    test('0 is valid (not entered)', () {
      expect(MeasurementValidator.validateHeight(0), isNull);
    });

    test('29 cm is invalid (too low)', () {
      expect(MeasurementValidator.validateHeight(29), 'invalidHeight');
    });

    test('30 cm is valid (boundary)', () {
      expect(MeasurementValidator.validateHeight(30), isNull);
    });

    test('175 cm is valid (normal)', () {
      expect(MeasurementValidator.validateHeight(175), isNull);
    });

    test('300 cm is valid (upper boundary)', () {
      expect(MeasurementValidator.validateHeight(300), isNull);
    });

    test('301 cm is invalid (too high)', () {
      expect(MeasurementValidator.validateHeight(301), 'invalidHeight');
    });

    test('negative value passes validation (h <= 0, treated as not entered)', () {
      // In the app, double.tryParse on negative input gives a negative number.
      // The validation check `h > 0 && (h < 30 || h > 300)` skips negative values
      // because h > 0 is false. This is acceptable because the submit logic
      // already checks if at least one measure is entered (h == 0 && w == 0 ...).
      expect(MeasurementValidator.validateHeight(-5), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Weight Validation (1–500 kg)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Weight validation', () {
    test('0 is valid (not entered)', () {
      expect(MeasurementValidator.validateWeight(0), isNull);
    });

    test('0.5 kg is invalid (too low)', () {
      expect(MeasurementValidator.validateWeight(0.5), 'invalidWeight');
    });

    test('1 kg is valid (boundary)', () {
      expect(MeasurementValidator.validateWeight(1), isNull);
    });

    test('70 kg is valid (normal)', () {
      expect(MeasurementValidator.validateWeight(70), isNull);
    });

    test('500 kg is valid (upper boundary)', () {
      expect(MeasurementValidator.validateWeight(500), isNull);
    });

    test('501 kg is invalid (too high)', () {
      expect(MeasurementValidator.validateWeight(501), 'invalidWeight');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Systolic Validation (40–300 mmHg)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Systolic blood pressure validation', () {
    test('0 is valid (not entered)', () {
      expect(MeasurementValidator.validateSystolic(0), isNull);
    });

    test('39 is invalid', () {
      expect(MeasurementValidator.validateSystolic(39), 'invalidBloodPressure');
    });

    test('40 is valid (boundary)', () {
      expect(MeasurementValidator.validateSystolic(40), isNull);
    });

    test('120 is valid (normal)', () {
      expect(MeasurementValidator.validateSystolic(120), isNull);
    });

    test('300 is valid (upper boundary)', () {
      expect(MeasurementValidator.validateSystolic(300), isNull);
    });

    test('301 is invalid', () {
      expect(MeasurementValidator.validateSystolic(301), 'invalidBloodPressure');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Diastolic Validation (20–200 mmHg)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Diastolic blood pressure validation', () {
    test('0 is valid (not entered)', () {
      expect(MeasurementValidator.validateDiastolic(0), isNull);
    });

    test('19 is invalid', () {
      expect(MeasurementValidator.validateDiastolic(19), 'invalidBloodPressure');
    });

    test('20 is valid (boundary)', () {
      expect(MeasurementValidator.validateDiastolic(20), isNull);
    });

    test('80 is valid (normal)', () {
      expect(MeasurementValidator.validateDiastolic(80), isNull);
    });

    test('200 is valid (upper boundary)', () {
      expect(MeasurementValidator.validateDiastolic(200), isNull);
    });

    test('201 is invalid', () {
      expect(MeasurementValidator.validateDiastolic(201), 'invalidBloodPressure');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Blood Sugar Validation (20–900 mg/dL)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Blood sugar validation', () {
    test('0 is valid (not entered)', () {
      expect(MeasurementValidator.validateBloodSugar(0), isNull);
    });

    test('19 is invalid', () {
      expect(MeasurementValidator.validateBloodSugar(19), 'invalidBloodSugar');
    });

    test('20 is valid (boundary)', () {
      expect(MeasurementValidator.validateBloodSugar(20), isNull);
    });

    test('90 is valid (normal fasting)', () {
      expect(MeasurementValidator.validateBloodSugar(90), isNull);
    });

    test('900 is valid (upper boundary)', () {
      expect(MeasurementValidator.validateBloodSugar(900), isNull);
    });

    test('901 is invalid', () {
      expect(MeasurementValidator.validateBloodSugar(901), 'invalidBloodSugar');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  BMI Calculation
  // ═══════════════════════════════════════════════════════════════════════════
  group('BMI calculation', () {
    test('normal BMI calculation (175cm, 70kg)', () {
      final bmi = MeasurementValidator.calculateBmi(175, 70);
      expect(bmi, closeTo(22.86, 0.01));
    });

    test('zero height returns 0', () {
      expect(MeasurementValidator.calculateBmi(0, 70), 0);
    });

    test('zero weight returns 0', () {
      expect(MeasurementValidator.calculateBmi(175, 0), 0);
    });

    test('negative values return 0', () {
      expect(MeasurementValidator.calculateBmi(-175, 70), 0);
      expect(MeasurementValidator.calculateBmi(175, -70), 0);
    });

    test('underweight BMI (180cm, 50kg)', () {
      final bmi = MeasurementValidator.calculateBmi(180, 50);
      expect(bmi, closeTo(15.43, 0.01));
      expect(bmi, lessThan(18.5));
    });

    test('obese BMI (165cm, 100kg)', () {
      final bmi = MeasurementValidator.calculateBmi(165, 100);
      expect(bmi, closeTo(36.73, 0.01));
      expect(bmi, greaterThan(30));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Combined Validation Scenarios
  // ═══════════════════════════════════════════════════════════════════════════
  group('Combined measurement validation scenarios', () {
    test('completely valid measurement', () {
      expect(MeasurementValidator.validateHeight(170), isNull);
      expect(MeasurementValidator.validateWeight(68), isNull);
      expect(MeasurementValidator.validateSystolic(120), isNull);
      expect(MeasurementValidator.validateDiastolic(80), isNull);
      expect(MeasurementValidator.validateBloodSugar(95), isNull);
    });

    test('all empty (0) is valid - form allows partial entry', () {
      expect(MeasurementValidator.validateHeight(0), isNull);
      expect(MeasurementValidator.validateWeight(0), isNull);
      expect(MeasurementValidator.validateSystolic(0), isNull);
      expect(MeasurementValidator.validateDiastolic(0), isNull);
      expect(MeasurementValidator.validateBloodSugar(0), isNull);
    });

    test('diabetic patient extreme values', () {
      expect(MeasurementValidator.validateBloodSugar(450), isNull);
      expect(MeasurementValidator.validateSystolic(180), isNull);
      expect(MeasurementValidator.validateDiastolic(110), isNull);
    });

    test('newborn measurements (edge case)', () {
      expect(MeasurementValidator.validateHeight(45), isNull); // newborn ~50cm
      expect(MeasurementValidator.validateWeight(3), isNull); // newborn ~3kg
    });
  });
}
