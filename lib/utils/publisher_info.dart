import 'package:get/get.dart';

/// Informations légales de l'éditeur de Bonkano (exigence Apple 5.1.1(ix)).
/// Les champs laissés vides ('') sont automatiquement masqués dans l'écran « À propos ».
class PublisherInfo {
  static const String companyName = 'NeuroCare Group';
  static const String legalForm = 'SARL au capital de 100 000 FCFA';
  static const String rccm = 'RB/COT/26 B 43860';
  static const String ifu = ''; // à compléter si souhaité (masqué tant que vide)
  static const String address = 'Ilot C/754, Quartier Suru-Léré, Parcelle Z, Cotonou, Bénin';
  static const String email = 'neurocareconnect24@gmail.com';

  static bool get _isFr => (Get.locale?.languageCode ?? 'fr') == 'fr';

  /// Sous le logo (écran de démarrage).
  static String get serviceOf => _isFr ? 'Un service de $companyName' : 'A service by $companyName';

  /// Pied de page des écrans de connexion / inscription.
  static String get publishedBy =>
      _isFr ? 'Bonkano est édité et exploité par $companyName' : 'Bonkano is published and operated by $companyName';

  /// Début de la phrase de consentement (suivie des liens CGU / confidentialité).
  static String get consentPrefix => _isFr
      ? "J'accepte que mes données soient traitées par $companyName, conformément aux "
      : 'I agree that my data will be processed by $companyName, in accordance with the ';

  static String get publisherTitle => _isFr ? 'Éditeur' : 'Publisher';
  static String get legalFormLabel => _isFr ? 'Forme juridique' : 'Legal form';
  static String get addressLabel => _isFr ? 'Adresse' : 'Address';
  static String get emailLabel => _isFr ? 'Contact' : 'Contact';
}
