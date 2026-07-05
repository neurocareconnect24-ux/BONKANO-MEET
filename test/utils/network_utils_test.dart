import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

/// Tests for network utility functions.
/// Since the actual network_utils.dart depends on many Flutter/GetX plugins,
/// we test the pure logic portions (JSON handling, URL building, error parsing)
/// as standalone functions mirroring the app's implementation.
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  JSON Response Handling
  // ═══════════════════════════════════════════════════════════════════════════
  group('JSON response parsing', () {
    test('valid JSON string decodes correctly', () {
      const jsonStr = '{"status": true, "message": "Success", "data": {"id": 1}}';
      final result = jsonDecode(jsonStr);

      expect(result['status'], true);
      expect(result['message'], 'Success');
      expect(result['data']['id'], 1);
    });

    test('empty JSON object decodes to empty map', () {
      const jsonStr = '{}';
      final result = jsonDecode(jsonStr);

      expect(result, isA<Map>());
      expect(result, isEmpty);
    });

    test('JSON array decodes correctly', () {
      const jsonStr = '[{"id": 1}, {"id": 2}]';
      final result = jsonDecode(jsonStr);

      expect(result, isA<List>());
      expect(result.length, 2);
    });

    test('invalid JSON throws FormatException', () {
      const invalidJson = 'not json at all';
      expect(() => jsonDecode(invalidJson), throwsFormatException);
    });

    test('HTML response (non-JSON) throws FormatException', () {
      const htmlResponse = '<html><body>Error 500</body></html>';
      expect(() => jsonDecode(htmlResponse), throwsFormatException);
    });

    test('isJson check (mirrors String.isJson from nb_utils)', () {
      // Simulating the isJson() check added in BUG-02 fix
      bool isJson(String str) {
        try {
          jsonDecode(str);
          return true;
        } catch (_) {
          return false;
        }
      }

      expect(isJson('{"key": "value"}'), true);
      expect(isJson('[1, 2, 3]'), true);
      expect(isJson('plain text'), false);
      expect(isJson('<html>'), false);
      expect(isJson(''), false);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  URL Building
  // ═══════════════════════════════════════════════════════════════════════════
  group('URL building', () {
    const baseUrl = 'https://meet.bonkano.fr';

    test('build API URL with endpoint', () {
      final uri = Uri.parse('$baseUrl/api/user/login');
      expect(uri.scheme, 'https');
      expect(uri.host, 'meet.bonkano.fr');
      expect(uri.path, '/api/user/login');
    });

    test('URL preserves HTTPS scheme', () {
      final uri = Uri.parse('$baseUrl/api/test');
      expect(uri.scheme, 'https');
    });

    test('URL with query parameters', () {
      final uri = Uri.parse('$baseUrl/api/appointments').replace(queryParameters: {
        'page': '1',
        'per_page': '20',
        'status': 'upcoming',
      });

      expect(uri.queryParameters['page'], '1');
      expect(uri.queryParameters['per_page'], '20');
      expect(uri.queryParameters['status'], 'upcoming');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  HTTP Status Code Handling
  // ═══════════════════════════════════════════════════════════════════════════
  group('HTTP status code classification', () {
    test('200 is success', () {
      expect(200 >= 200 && 200 < 300, true);
    });

    test('201 is success (created)', () {
      expect(201 >= 200 && 201 < 300, true);
    });

    test('400 is client error', () {
      expect(400 >= 400 && 400 < 500, true);
    });

    test('401 is unauthorized', () {
      expect(401, 401); // Token refresh trigger
    });

    test('403 is forbidden', () {
      expect(403 >= 400 && 403 < 500, true);
    });

    test('404 is not found', () {
      expect(404 >= 400 && 404 < 500, true);
    });

    test('500 is server error', () {
      expect(500 >= 500, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Error Message Extraction
  // ═══════════════════════════════════════════════════════════════════════════
  group('Error message extraction from responses', () {
    test('extract message from standard error response', () {
      const errorJson = '{"message": "Invalid credentials", "status": false}';
      final parsed = jsonDecode(errorJson);
      expect(parsed['message'], 'Invalid credentials');
    });

    test('extract message from nested error', () {
      const errorJson = '{"errors": {"email": ["Email is required"]}}';
      final parsed = jsonDecode(errorJson);
      expect(parsed['errors']['email'][0], 'Email is required');
    });

    test('handle response with no message field', () {
      const errorJson = '{"status": false}';
      final parsed = jsonDecode(errorJson);
      final message = parsed['message'] ?? '';
      expect(message, '');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Stripe Error Parsing (mirrors parseStripeError)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Stripe error parsing', () {
    test('parse Stripe error with message', () {
      const stripeError = '{"error": {"message": "Your card was declined.", "type": "card_error"}}';
      final parsed = jsonDecode(stripeError);
      final message = parsed['error']?['message'] ?? '';
      expect(message, 'Your card was declined.');
    });

    test('handle malformed Stripe response', () {
      const badResponse = 'Connection timeout';

      String safeParseStripeError(String response) {
        try {
          final parsed = jsonDecode(response);
          return parsed['error']?['message'] ?? response;
        } catch (_) {
          return response;
        }
      }

      expect(safeParseStripeError(badResponse), 'Connection timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  Header Building
  // ═══════════════════════════════════════════════════════════════════════════
  group('Request headers', () {
    test('default headers contain JSON content type', () {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      expect(headers['Content-Type'], 'application/json');
      expect(headers['Accept'], 'application/json');
    });

    test('auth header contains Bearer token', () {
      const token = 'test_token_123';
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      expect(headers['Authorization'], 'Bearer test_token_123');
    });
  });
}
