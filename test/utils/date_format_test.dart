import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

/// Tests for date formatting logic used across the app.
/// The app uses intl DateFormat extensively; these tests verify the format
/// strings produce expected outputs (same patterns as in common_base.dart
/// and DateFormatConst in constants.dart).
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  Date Format Constants (mirrors DateFormatConst)
  // ═══════════════════════════════════════════════════════════════════════════
  group('DateFormatConst format strings', () {
    final testDate = DateTime(2024, 3, 15, 14, 30, 0);

    test('DD_MM_YY format', () {
      final result = DateFormat('dd-MM-yy').format(testDate);
      expect(result, '15-03-24');
    });

    test('DD_MM_YYYY format', () {
      final result = DateFormat('dd/MM/yyyy').format(testDate);
      expect(result, '15/03/2024');
    });

    test('yyyy_MM_dd format (API format)', () {
      final result = DateFormat('yyyy-MM-dd').format(testDate);
      expect(result, '2024-03-15');
    });

    test('yyyy_MM_dd_HH_mm format', () {
      final result = DateFormat('yyyy-MM-dd HH:mm').format(testDate);
      expect(result, '2024-03-15 14:30');
    });

    test('HH_mm 12-hour format', () {
      final result = DateFormat('hh:mm a').format(testDate);
      expect(result, '02:30 PM');
    });

    test('HH_mm 24-hour format', () {
      final result = DateFormat('HH:mm').format(testDate);
      expect(result, '14:30');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Date Parsing (common patterns from API responses)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Date parsing from API strings', () {
    test('parse yyyy-MM-dd string', () {
      final date = DateFormat('yyyy-MM-dd').parse('2024-03-15');
      expect(date.year, 2024);
      expect(date.month, 3);
      expect(date.day, 15);
    });

    test('parse yyyy-MM-dd HH:mm string', () {
      final date = DateFormat('yyyy-MM-dd HH:mm').parse('2024-03-15 14:30');
      expect(date.hour, 14);
      expect(date.minute, 30);
    });

    test('invalid date string throws FormatException', () {
      expect(
        () => DateFormat('yyyy-MM-dd').parseStrict('not-a-date'),
        throwsFormatException,
      );
    });

    test('empty string throws FormatException', () {
      expect(
        () => DateFormat('yyyy-MM-dd').parseStrict(''),
        throwsFormatException,
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Date Comparison (used for appointment filtering)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Date comparisons', () {
    test('isAfter works for future dates', () {
      final future = DateTime.now().add(const Duration(days: 1));
      expect(future.isAfter(DateTime.now()), true);
    });

    test('isBefore works for past dates', () {
      final past = DateTime.now().subtract(const Duration(days: 1));
      expect(past.isBefore(DateTime.now()), true);
    });

    test('same day comparison', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final alsoToday = DateTime(now.year, now.month, now.day);
      expect(today, alsoToday);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Duration Formatting (mirrors common_base.dart toFormattedDuration)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Duration formatting', () {
    test('format minutes duration', () {
      const duration = Duration(minutes: 30);
      expect(duration.inMinutes, 30);
      expect(duration.inHours, 0);
    });

    test('format hours and minutes', () {
      const duration = Duration(hours: 1, minutes: 45);
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      expect(hours, 1);
      expect(minutes, 45);
    });

    test('format multi-hour duration', () {
      const duration = Duration(hours: 3, minutes: 15);
      expect(duration.inHours, 3);
      expect(duration.inMinutes.remainder(60), 15);
    });
  });
}
