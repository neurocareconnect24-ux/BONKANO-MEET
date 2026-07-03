import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../utils/app_common.dart';

class FedaPayService {
  num totalAmount;
  late Function(Map<String, dynamic>) onComplete;

  static const String _liveApiUrl = 'https://api.fedapay.com/v1/';
  static const String _sandboxApiUrl = 'https://sandbox-api.fedapay.com/v1/';

  FedaPayService({
    required this.totalAmount,
    required this.onComplete,
  });

  Future<Map<String, dynamic>> _getEnvConfig() async {
    final String response = await rootBundle.loadString('env.json');
    return json.decode(response) as Map<String, dynamic>;
  }

  Future<void> payWithFedaPay(BuildContext context) async {
    try {
      final env = await _getEnvConfig();
      final bool isLive = env['FEDA_LIVE'] == true;
      final String apiKey = isLive
          ? (env['FEDA_LIVE_KEY'] ?? '')
          : (env['FEDA_SANDBOX_KEY'] ?? '');
      final String baseUrl = isLive ? _liveApiUrl : _sandboxApiUrl;
      final String callbackUrl = isLive
          ? (env['FEDA_CALLBACK_PROD_URL'] ?? '')
          : (env['FEDA_CALLBACK_DEV_URL'] ?? '');

      if (apiKey.isEmpty) {
        log('FedaPay: Clé API manquante dans env.json');
        toast(locale.value.fedaPayTransactionError);
        return;
      }

      final String mobile = loginUserData.value.mobile.validate();
      final String email = loginUserData.value.email.validate();
      log('FedaPay: Création — montant: $totalAmount XOF, email: $email, tel: $mobile');

      // ─── ÉTAPE 1 : Créer la transaction ───────────────────────────────────
      final createBody = json.encode({
        'description': 'Paiement consultation - $email',
        'amount': totalAmount.toDouble(),
        'currency': {'iso': 'XOF'},
        'callback_url': callbackUrl,
        'customer': {
          'email': email,
          'phone_number': {'number': mobile, 'country': 'BJ'},
        },
      });

      log('FedaPay: POST ${baseUrl}transactions');
      final createResp = await http
          .post(
            Uri.parse('${baseUrl}transactions'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: createBody,
          )
          .timeout(const Duration(seconds: 30));

      log('FedaPay: Status création = ${createResp.statusCode}');
      log('FedaPay: Body création = ${createResp.body}');

      if (createResp.statusCode != 200 && createResp.statusCode != 201) {
        toast(locale.value.fedaPayTransactionError);
        return;
      }

      final Map<String, dynamic> createData = json.decode(createResp.body);
      final Map<String, dynamic>? trxData =
          createData['v1/transaction'] as Map<String, dynamic>?;

      if (trxData == null) {
        log('FedaPay: Clé "v1/transaction" absente. Réponse: $createData');
        toast(locale.value.fedaPayTransactionError);
        return;
      }

      final int? trxId = trxData['id'] as int?;
      if (trxId == null) {
        log('FedaPay: ID transaction absent.');
        toast(locale.value.fedaPayTransactionError);
        return;
      }
      log('FedaPay: Transaction créée — ID: $trxId');

      // ─── ÉTAPE 2 : Récupérer le token/URL de paiement ─────────────────────
      log('FedaPay: POST ${baseUrl}transactions/$trxId/token');
      final tokenResp = await http
          .post(
            Uri.parse('${baseUrl}transactions/$trxId/token'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: '{}',
          )
          .timeout(const Duration(seconds: 30));

      log('FedaPay: Status token = ${tokenResp.statusCode}');
      log('FedaPay: Body token = ${tokenResp.body}');

      if (tokenResp.statusCode != 200 && tokenResp.statusCode != 201) {
        toast(locale.value.fedaPayTransactionError);
        return;
      }

      final Map<String, dynamic> tokenData = json.decode(tokenResp.body);
      final String? paymentUrl = tokenData['url'] as String?;

      if (paymentUrl == null || paymentUrl.isEmpty) {
        log('FedaPay: URL de paiement absente. tokenData: $tokenData');
        toast(locale.value.fedaPayTransactionError);
        return;
      }
      log('FedaPay: URL = $paymentUrl');

      // ─── ÉTAPE 3 : Ouvrir FedaPay dans le navigateur externe ──────────────
      final Uri uri = Uri.parse(paymentUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('FedaPay: Impossible d\'ouvrir: $paymentUrl');
        toast(locale.value.fedaPayTransactionError);
        return;
      }

      // ─── ÉTAPE 4 : Attendre le retour puis vérifier automatiquement ────────
      if (!context.mounted) return;
      await _waitForReturnAndVerify(context, trxId, baseUrl, apiKey);
    } catch (e, stack) {
      log('FedaPay Exception: $e\n$stack');
      toast('${locale.value.transactionFailed}: $e');
    }
  }

  /// Affiche un indicateur de chargement et attend que l'utilisateur revienne
  /// sur l'app depuis le navigateur, puis vérifie le statut automatiquement.
  Future<void> _waitForReturnAndVerify(
      BuildContext context, int trxId, String baseUrl, String apiKey) async {
    final observer = _FedaLifecycleObserver();
    WidgetsBinding.instance.addObserver(observer);

    // Dialogue de chargement – non-dismissible
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text(
                'Paiement en cours…',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Revenez sur l\'application après avoir payé sur FedaPay. La vérification sera automatique.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );

    // Attend le retour en foreground (timeout 10 min)
    await observer.waitForResume(timeout: const Duration(minutes: 10));
    WidgetsBinding.instance.removeObserver(observer);

    // Ferme le dialogue
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    // Petit délai pour que FedaPay traite le paiement côté serveur
    await Future.delayed(const Duration(seconds: 2));

    // Vérifie le statut (avec retries)
    await _verifyWithRetries(trxId, baseUrl, apiKey);
  }

  /// Vérifie le statut avec jusqu'à 5 tentatives (cas « pending »).
  Future<void> _verifyWithRetries(
      int trxId, String baseUrl, String apiKey) async {
    const int maxRetries = 5;
    const Duration delay = Duration(seconds: 4);

    for (int i = 1; i <= maxRetries; i++) {
      try {
        log('FedaPay: Vérification $trxId — tentative $i/$maxRetries');
        final resp = await http
            .get(
              Uri.parse('${baseUrl}transactions/$trxId'),
              headers: {
                'Authorization': 'Bearer $apiKey',
                'Content-Type': 'application/json',
              },
            )
            .timeout(const Duration(seconds: 30));

        log('FedaPay: Status vérif = ${resp.statusCode}');
        log('FedaPay: Body vérif = ${resp.body}');

        final data = json.decode(resp.body) as Map<String, dynamic>;
        final trxMap = data['v1/transaction'] as Map<String, dynamic>?;
        final status = (trxMap?['status'] as String?) ?? 'unknown';

        log('FedaPay: Statut = $status (tentative $i)');

        if (status == 'approved' || status == 'transferred') {
          log('FedaPay: ✅ Paiement validé');
          toast(locale.value.transactionIsSuccessful);
          onComplete({'transaction_id': trxId.toString()});
          return;
        } else if (status == 'pending' && i < maxRetries) {
          log('FedaPay: ⏳ Pending, retry dans ${delay.inSeconds}s…');
          await Future.delayed(delay);
        } else if (status == 'pending') {
          log('FedaPay: ⚠️ Toujours pending après $maxRetries tentatives');
          toast(
              'Paiement en attente de confirmation FedaPay. Si le montant a été débité, contactez le support.');
          return;
        } else {
          log('FedaPay: ❌ Statut: $status');
          toast('${locale.value.transactionFailed} (statut: $status)');
          return;
        }
      } catch (e) {
        log('FedaPay: Erreur tentative $i: $e');
        if (i == maxRetries) {
          toast('${locale.value.transactionFailed}: $e');
        } else {
          await Future.delayed(delay);
        }
      }
    }
  }
}

/// Observe le cycle de vie de l'app et se déclenche quand elle revient
/// au premier plan après être passée en arrière-plan.
class _FedaLifecycleObserver extends WidgetsBindingObserver {
  bool _wentToBackground = false;
  final _done = _SafeCompleter<void>();

  Future<void> waitForResume({required Duration timeout}) =>
      _done.future.timeout(timeout, onTimeout: () {});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log('FedaPay Lifecycle: $state');
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _wentToBackground = true;
    }
    if (state == AppLifecycleState.resumed && _wentToBackground) {
      log('FedaPay Lifecycle: ✅ App revenue au premier plan');
      _done.complete();
    }
  }
}

/// Completer qui accepte plusieurs appels à complete() sans exception.
class _SafeCompleter<T> {
  final _c = Completer<T>();
  bool _done = false;

  Future<T> get future => _c.future;

  void complete([T? value]) {
    if (!_done) {
      _done = true;
      _c.complete(value);
    }
  }
}
